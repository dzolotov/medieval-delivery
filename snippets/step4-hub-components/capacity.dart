import 'dart:async';

import 'package:deliverysim/component/rounded.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CapacityComponent extends PositionComponent
    with HasGameRef<DeliveryGame> {
  late RoundedComponent rc;

  TextComponent? tc;

  void updateText() {
    if (tc != null) {
      tc?.removeFromParent();
    }
    final player = game.world.currentPlayer!;
    final renderer = TextPaint(
      style: const TextStyle(
        fontFamily: GameTheme.font,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
    final cap = '${player.cargoWeight} / ${player.current.capacity}';
    tc = TextComponent(text: cap, textRenderer: renderer)
      ..position = Vector2(
          size.x * 0.1 +
              (size.x * 0.7 - renderer.getLineMetrics(cap).width) / 2,
          size.y * 0.9);
    add(tc!);
  }

  @override
  FutureOr<void> onLoad() {
    rc = RoundedComponent(
      size: Vector2(size.x * 0.7, 16),
      color: Colors.white,
      overrideColor: Colors.blue,
      ratio: 0,
    )..position = Vector2(size.x * 0.1, size.y * 0.9);
    add(rc);
    updateText();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final player = game.world.currentPlayer;
    if (player==null) {
      return;
    }
    rc.ratio = player.cargoWeight / player.current.capacity;
    updateText();
  }
}
