import 'dart:developer';
import 'dart:math' hide log;

import 'package:deliverysim/component/game_over.dart';
import 'package:deliverysim/component/mood.dart';
import 'package:deliverysim/component/profile/2d.dart';
import 'package:deliverysim/model/player_information.dart';
import 'package:deliverysim/multiplayer/messages/game_state.dart';
import 'package:deliverysim/multiplayer/messages/request_initial_state.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'component/capacity.dart';
import 'component/minimap.dart';
import 'component/money.dart';
import '../snippets/step1-world/components/player_icon_sprite.dart';
import 'component/profile.dart';
import 'component/profile/3d.dart';
import 'component/time_of_day.dart';
import 'multiplayer/multiplayer.dart';
import 'theme/theme.dart';
import 'world/cellitems/cell.dart';
import 'world/world.dart';

final pickupPoints = [];

class DeliveryGame extends FlameGame<DeliveryWorld>
    with TapDetector, ScrollDetector, HasKeyboardHandlerComponents {
  final Vector2 viewportResolution;
  late final RouterComponent router;

  // @override
  // bool debugMode = true;

  DeliveryGame({
    required this.viewportResolution,
    required super.world,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            viewfinder: Viewfinder(key: ComponentKey.named('viewFinder')),
            width: viewportResolution.x,
            height: viewportResolution.y,
            hudComponents: [
              MiniMap()
                ..size = Vector2.all(
                  min(viewportResolution.x, viewportResolution.y) / 4,
                )
                ..position = viewportResolution / 20,
              MoneyComponent()
                ..position = Vector2(
                  viewportResolution.x /
                      (viewportResolution.x > viewportResolution.y ? 4 : 2),
                  64 * (viewportResolution.x > viewportResolution.y ? 0.5 : 1),
                ),
              CapacityComponent()..size = viewportResolution,
              TimeOfDayComponent(painter: TimeOfDayCustomPainter(world!))
                ..position = Vector2(
                  viewportResolution.x - GameTheme.spriteSize,
                  64 * (viewportResolution.x > viewportResolution.y ? 0.5 : 1),
                ),
              PlayerIconSprite()
                ..position = viewportResolution -
                    Vector2(
                        64 /
                            (viewportResolution.x > viewportResolution.y
                                ? 1.2
                                : 1),
                        (128 /
                                (viewportResolution.x > viewportResolution.y
                                    ? 2
                                    : 1)) -
                            8)
                ..size = Vector2.all(
                    64 / (viewportResolution.x > viewportResolution.y ? 2 : 1)),
              MoodComponent()..size = viewportResolution,
            ],
          ),
        );

  void resetDay() {
    world.dayTime
      ..reset()
      ..start();
    world.gameMap.clear();
    world.gameMap = List.generate(
        world.mapWidth * world.mapHeight, (_) => CellDescriptor.empty());

    world
      ..cleanup()
      ..build()
      ..updatePlayer(
        world.currentPlayer!,
        updatePosition: true,
      );
    //send update
    world.multiplayer?.broadcast(
      GameStateMessage(
        players: world.players,
        gameMap: world.gameMap,
        time: world.dayTime.current,
      ),
    );
    world.placeOwnPlayer(world.currentPlayerId);
    camera.follow(
      world.updatePlayer(world.currentPlayer!, updatePosition: true)!,
      snap: true,
    );
  }

  @override
  Future<void> onLoad() async {
    if (DeliveryWorld.enableMultiplayer) {
      world.multiplayer = Multiplayer(world);
      await world.multiplayer!.initWebRTC();
      world.multiplayer?.addListener(world.multiplayerUpdate);
    }
    router = RouterComponent(initialRoute: 'game', routes: {
      'game': Route(() {
        //transparent stub
        return RectangleComponent();
      }),
      'profile': Route(() {
        return ProfileComponent()
          ..size = viewportResolution
          ..position = Vector2.zero();
      }),
      'knight': DeliveryWorld.mode3d ? Knight3D() : Knight(),
      'horse_carriage':
          DeliveryWorld.mode3d ? HorseCarriage3D() : HorseCarriage(),
      'dragon': DeliveryWorld.mode3d ? Dragon3D() : Dragon(),
    });
    resetDay();
    world.backgroundMusic = await FlameAudio.loopLongAudio('greensleeves.mp3');
    camera.setBounds(
      Rectangle.fromRect(
        Vector2(
              -world.mapWidth / 2 * GameTheme.spriteSize * world.scaleFactor,
              -world.mapHeight * GameTheme.spriteSize * world.scaleFactor,
            ) &
            Vector2(
              world.mapWidth.toDouble() *
                  GameTheme.spriteSize *
                  world.scaleFactor,
              world.mapHeight.toDouble() *
                  GameTheme.spriteSize *
                  world.scaleFactor *
                  viewportResolution.y /
                  viewportResolution.x,
            ),
      ),
    );
    camera.viewport.add(router);
  }
}
