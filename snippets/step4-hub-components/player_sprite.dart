import 'dart:async';

import '../behaviors/player_food_collision_behavior.dart';
import '../behaviors/player_movement.dart';
import '../behaviors/player_pickup_collision_behavior.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../behaviors/player_droppoint_collision.dart';
import '../game_widget.dart';
import '../theme/theme.dart';

class PlayerSprite extends PositionComponent
    with HasGameRef<DeliveryGame>, EntityMixin {
  @override
  FutureOr<void> onLoad() async {
    addAll([
      PropagatingCollisionBehavior(
        RectangleHitbox(
          position: Vector2.all(2),
          size: Vector2.all(GameTheme.spriteSize * game.world.scaleFactor - 4),
        ),
      ),
      PlayerDropPointCollisionBehavior(),
      PlayerPickupPointCollisionBehavior(),
      PlayerFoodPointCollisionBehavior(),
      PlayerMovementBehavior(),
    ]);
    size = Vector2.all(GameTheme.spriteSize*game.world.scaleFactor);

    final animation = await SpriteAnimation.load(
      'courier_spritesheet.png',
      SpriteAnimationData.range(
        start: 0,
        end: 3,
        amount: 4,
        stepTimes: List.generate(4, (_) => 0.15),
        textureSize: Vector2.all(32),
      ),
    );
    add(
      SpriteAnimationComponent(
        position: Vector2.all(GameTheme.spriteSize*game.world.scaleFactor / 2),
        anchor: Anchor.center,
        animation: animation,
        size: Vector2.all(GameTheme.spriteSize*game.world.scaleFactor),
      ),
    );
  }
}
