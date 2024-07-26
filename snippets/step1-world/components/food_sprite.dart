import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';

import '../../../lib/game_widget.dart';
import '../../../lib/theme/theme.dart';
import '../../../lib/world/cellitems/map_item.dart';

class FoodSprite extends SpriteComponent
    with HasGameRef<DeliveryGame>, EntityMixin {
  FoodSprite();

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('tavern.png'));
    size = Vector2.all(GameTheme.spriteSize*game.world.scaleFactor);
    add(
      RectangleHitbox(
        position: Vector2.all(2),
        size: Vector2.all(GameTheme.spriteSize*game.world.scaleFactor - 4),
      ),
    );
  }
}
