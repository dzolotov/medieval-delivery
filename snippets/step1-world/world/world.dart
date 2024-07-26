import 'dart:developer';
import 'dart:math' hide log;

import 'components/food_sprite.dart';
import 'package:deliverysim/component/player_sprite.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:uuid/uuid.dart';

import '../component/drop_sprite.dart';
import '../component/pickup_sprite.dart';
import '../model/crystals.dart';
import '../model/player_information.dart';
import '../model/product.dart';
import '../model/quality.dart';
import '../model/transport_type.dart';
import '../theme/theme.dart';
import 'cellitems/cell.dart';
import 'cellitems/map_item.dart';

typedef PlaceObjectCallback = bool Function(int, int);

class DeliveryWorld extends World
    with HasCollisionDetection, HasGameRef<DeliveryGame> {
  int get mapWidth => 32;

  int get mapHeight => 32;

  static const timeFactor = 3.0;

  static const moodDegrade = 0.01;

  static const mode3d = false;

  double get scaleFactor => game.size.x > game.size.y ? 0.5 : 1.0;

  static const transports = [
    TransportType(
      type: 'Walking courier',
      model: 'knight',
      capacity: 20,
      price: 200,
    ),
    TransportType(
      type: 'Horse Carriage',
      model: 'horse_carriage',
      capacity: 100,
      price: 10000,
    ),
    TransportType(
      type: 'Dragon',
      model: 'dragon',
      capacity: 200,
      price: 30000,
    ),
  ];

  AudioPlayer? backgroundMusic;

  late List<CellDescriptor> gameMap =
      List.generate(mapWidth * mapHeight, (_) => CellDescriptor.empty());

  static const dayStart = 7 * 60; //start of the day

  static const dayEnd = 19 * 60; //end of the day

  //NPC - game time,
  final dayTime = Timer(((DeliveryWorld.dayEnd - DeliveryWorld.dayStart) /
          DeliveryWorld.timeFactor)
      .toDouble());

  final players = <String, PlayerInformation>{};

  String currentPlayerId = const Uuid().v4().toString();

  PlayerInformation? get currentPlayer => players[currentPlayerId];

  void placeObject(PlaceObjectCallback callback) {
    while (true) {
      final x = Random().nextInt(mapWidth);
      final y = Random().nextInt(mapHeight);
      final pos = y * mapWidth + x;
      if (gameMap[pos].quality != Quality.FORBIDDEN) {
        if (callback(x, y)) {
          break;
        }
      }
    }
  }

  void gameoverPlayer(String uuid) {
    //remove from gamemap
    players.remove(uuid);
  }

  void placeOwnPlayer(String uuid) {
    if (!players.containsKey(uuid)) {
      placeObject((x, y) {
        players[uuid] = PlayerInformation(
          uuid: uuid,
          x: x,
          y: y,
          money: 1000,
        );
        return true;
      });
    }
  }

  void drawDrop(DropPoint point) {
    int x = point.x;
    int y = point.y;
    final drop = DropSprite(point)
      ..position = Vector2(
          (x - mapWidth ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor,
          (y - mapHeight ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor)
      ..width = GameTheme.spriteSize * game.world.scaleFactor
      ..height = GameTheme.spriteSize * game.world.scaleFactor
      ..anchor = Anchor.center;
    point.component = drop;
    add(drop);
  }

  void placeDrop(String name) {
    placeObject((x, y) {
      final pos = y * mapWidth + x;
      final descriptor = CellDescriptor(
        content: DropPoint(
          x: x,
          y: y,
          name: name,
          uuid: const Uuid().v4().toString(),
        ),
        quality: gameMap[pos].quality,
      );
      gameMap[pos] = descriptor;
      drawDrop(descriptor.content as DropPoint);
      return true;
    });
  }

  void drawFood(FoodPoint point) {
    int x = point.x;
    int y = point.y;
    final food = FoodSprite()
      ..position = Vector2(
          (x - mapWidth ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor,
          (y - mapHeight ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor)
      ..width = GameTheme.spriteSize * game.world.scaleFactor
      ..height = GameTheme.spriteSize * game.world.scaleFactor
      ..anchor = Anchor.center;
    point.component = food;
    add(food);
  }

  void placeFood() {
    placeObject((x, y) {
      final pos = y * mapWidth + x;
      final descriptor = CellDescriptor(
        content: FoodPoint(
          x: x,
          y: y,
          uuid: const Uuid().v4().toString(),
        ),
        quality: gameMap[pos].quality,
      );
      gameMap[pos] = descriptor;
      drawFood(descriptor.content as FoodPoint);
      return true;
    });
  }

  void dropItem(MapItem item) {
    item.component?.removeFromParent();
  }

  void drawPickup(PickupPoint point) {
    int x = point.x;
    int y = point.y;
    final crystal = PickupPointSprite(point.crystalType, point)
      ..position = Vector2(
          (x - mapWidth ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor,
          (y - mapHeight ~/ 2) * GameTheme.spriteSize * game.world.scaleFactor)
      ..width = GameTheme.spriteSize * game.world.scaleFactor
      ..height = GameTheme.spriteSize * game.world.scaleFactor
      ..anchor = Anchor.center;
    point.component = crystal;
    add(crystal);
  }

  void placePickup() {
    final drops = gameMap
        .where((e) => e.content?.type == MapItemType.drop)
        .map((e) => (e.content as DropPoint).name)
        .toList();
    placeObject((x, y) {
      final pos = y * mapWidth + x;
      final products = <Product>[];
      final count = Random().nextInt(6) + 2;
      for (int i = 0; i < count; i++) {
        products.add(
          Product(
            name: medievalProducts.random(),
            weight: Random().nextInt(16) + 2,
            target: drops.random(),
          ),
        );
      }
      final descriptor = CellDescriptor(
        content: PickupPoint(
          x: x,
          y: y,
          crystalType: crystals.keys.toList().random(),
          products: products,
          uuid: const Uuid().v4().toString(),
        ),
        quality: gameMap[pos].quality,
      );
      gameMap[pos] = descriptor;
      drawPickup(descriptor.content as PickupPoint);
      return true;
    });
  }

  void spreadZones() {
    final grainsCount = Random().nextInt(10) + 5;
    //place grains
    for (int y = 0; y < mapHeight; y++) {
      for (int x = 0; x < mapWidth; x++) {
        gameMap[y * mapWidth + x].content = null;
        gameMap[y * mapWidth + x].quality = Quality.GREEN;
      }
    }
    for (int g = 0; g < grainsCount; g++) {
      Quality quality;
      do {
        quality = Quality.values.random();
      } while (quality == Quality.GREEN || quality == Quality.UNKNOWN);
      final xc = Random().nextInt(mapWidth);
      final yc = Random().nextInt(mapHeight);
      //spread to radium random distance
      final ref = min(mapWidth, mapHeight);
      int distance = Random().nextInt(ref ~/ 7) + ref ~/ 16;
      for (int angle = 0; angle < 360; angle++) {
        final rad = angle / 180 * pi;
        for (int i = 0; i < distance * 10; i++) {
          final x = (xc + i / 10 * cos(rad)).floor();
          final y = (yc + i / 10 * sin(rad)).floor();
          if (x >= 0 && x < mapWidth && y >= 0 && y < mapHeight) {
            gameMap[y * mapWidth + x].quality = quality;
          }
        }
        final delta = Random().nextInt(5) - 2; //-2 - +2
        distance += delta;
        if (distance > ref ~/ 6) {
          distance = ref ~/ 6;
        }
        if (distance < 1) {
          //minimal distance
          distance = 1;
        }
      }
    }
  }

  void build() {
    spreadZones();
    populateBackground();
    placeOwnPlayer(currentPlayerId);
    placeDrop('A');
    placeDrop('B');
    placeDrop('C');
    placePickup();
    placePickup();
    placeFood();
    placeFood();
  }

  void populateBackground() {
    if (gameMap.isEmpty) {
      return;
    }
    for (int y = -mapHeight ~/ 2; y < mapHeight / 2; y++) {
      for (int x = -mapWidth ~/ 2; x < mapWidth / 2; x++) {
        SpriteComponent spriteComponent =
            gameMap[(y + mapHeight ~/ 2) * mapWidth + (x + mapWidth ~/ 2)]
                .quality
                .getSprite();
        add(
          spriteComponent
            ..position = Vector2(
                x * GameTheme.spriteSize * game.world.scaleFactor,
                y * GameTheme.spriteSize * game.world.scaleFactor)
            ..width = GameTheme.spriteSize * game.world.scaleFactor
            ..height = GameTheme.spriteSize * game.world.scaleFactor
            ..anchor = Anchor.center,
        );
      }
    }
  }

  ReadOnlyPositionProvider? get currentPlayerComponent =>
      players[currentPlayerId]?.component as ReadOnlyPositionProvider?;

  ReadOnlyPositionProvider? updatePlayer(PlayerInformation playerInformation,
      {required bool updatePosition}) {
    if (!updatePosition) {
      //only rotation
      final player = playerInformation.component as PlayerSprite;
      if (player.isFlippedHorizontally != playerInformation.isMirrored) {
        player.flipHorizontally();
      }
      return player;
    }
    playerInformation.component?.removeFromParent();
    if (!playerInformation.isDead) {
      final player = PlayerSprite()
        ..position = Vector2(
            (playerInformation.x - mapWidth ~/ 2) *
                GameTheme.spriteSize *
                game.world.scaleFactor,
            (playerInformation.y - mapHeight ~/ 2) *
                GameTheme.spriteSize *
                game.world.scaleFactor)
        ..anchor = Anchor.center;
      playerInformation.component = player;
      add(player);
      return player;
    } else {
      playerInformation.component = null;
      return null;
    }
  }

  void cleanup() {
    for (final e in children) {
      e.removeFromParent();
    }
  }

  void drop(MapItem item) => gameMap[item.y * mapWidth + item.x].content = null;

  void place(MapItem item) =>
      gameMap[item.y * mapWidth + item.x].content = item;
}
