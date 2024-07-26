import 'dart:async';

import 'package:deliverysim/behaviors/player_pickup_collision_behavior.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../game_widget.dart';
import '../theme/theme.dart';
import '../world/cellitems/map_item.dart';

class PickupPointSprite extends SpriteComponent
    with HasGameRef<DeliveryGame>, EntityMixin {
  PickupPoint descriptor;

  String filename;

  PickupPointSprite(
    this.filename,
    this.descriptor,
  );

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('crystals/$filename'));
    size = Vector2.all(GameTheme.spriteSize*game.world.scaleFactor);
    add(
      RectangleHitbox(
        position: Vector2.all(2),
        size: Vector2.all(GameTheme.spriteSize*game.world.scaleFactor - 4),
      ),
    );
  }
}
