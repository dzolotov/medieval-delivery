import 'dart:async';

import 'package:deliverysim/component/rounded.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MoodComponent extends PositionComponent with HasGameRef<DeliveryGame> {
  late RoundedComponent rc;

  static const colors = <int, Color>{
    0: Colors.red,
    10: Colors.redAccent,
    25: Colors.orange,
    50: Colors.yellow,
    75: Colors.teal,
    100: Colors.lightGreen,
  };

  @override
  FutureOr<void> onLoad() {
    rc = RoundedComponent(
      size: Vector2(
          size.x * 0.45 * game.world.scaleFactor, 16 * game.world.scaleFactor),
      color: Colors.white10,
      overrideColor: Colors.white10,
      ratio: 0,
    )..position = Vector2(
        size.x * (game.world.scaleFactor < 1 ? 0.5 : 0.55),
        size.y * (game.world.scaleFactor < 1 ? 0.1 : 0.13),
      );
    add(rc);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final player = game.world.currentPlayer;
    if (player == null) {
      return;
    }
    rc.ratio = player.mood / 100;
    for (int i = 0; i < colors.length - 1; i++) {
      final kleft = colors.keys.toList()[i];
      final kright = colors.keys.toList()[i + 1];

      if (player.mood >= kleft && player.mood <= kright) {
        final tween = ColorTween(
            begin: colors.values.toList()[i],
            end: colors.values.toList()[i + 1]);
        final color = tween.lerp((player.mood - kleft) / (kright - kleft));
        rc.overrideColor = color!;
      }
    }
  }
}
