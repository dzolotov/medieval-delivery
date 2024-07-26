import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';

import '../../../lib/game_widget.dart';
import '../../../lib/theme/theme.dart';
import '../../../lib/world/cellitems/map_item.dart';

class DropSprite extends SpriteComponent
    with HasGameRef<DeliveryGame>, EntityMixin {
  DropPoint dropPoint;

  DropSprite(this.dropPoint);

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('house.png'));
    size = Vector2.all(GameTheme.spriteSize*game.world.scaleFactor);
    add(
      RectangleHitbox(
        position: Vector2.all(2),
        size: Vector2.all(GameTheme.spriteSize*game.world.scaleFactor - 4),
      ),
    );
    final renderer = TextPaint(
      style: const TextStyle(
        fontSize: 28,
        fontFamily: GameTheme.font,
        color: Colors.white,
      ),
    );
    final metrics = renderer.getLineMetrics(dropPoint.name);
    add(
      TextComponent(
          text: dropPoint.name,
          textRenderer: renderer,
          //to the center
          position: Vector2((GameTheme.spriteSize*game.world.scaleFactor - metrics.width) / 2,
              (GameTheme.spriteSize*game.world.scaleFactor - metrics.height) / 2)),
    );
  }
}
