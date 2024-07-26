import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_widget.dart';
import '../theme/theme.dart';

class MoneyComponent extends PositionComponent with HasGameRef<DeliveryGame> {
  TextComponent? tc;
  int prevMoney = 0;

  @override
  void update(double dt) {
    final player = game.world.currentPlayer;
    if (player == null) {
      return;
    }

    if (player.money != prevMoney) {
      prevMoney = player.money;
      tc?.removeFromParent();
      tc = TextComponent(
        text: player.money.toString(),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontFamily: GameTheme.font,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      )..position = Vector2(48, -4);
      add(tc!);
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    final sheet = await SpriteAnimation.load(
      'coins.png',
      SpriteAnimationData.range(
        start: 0,
        end: 4,
        amount: 5,
        stepTimes: List.generate(5, (_) => 0.1),
        textureSize: Vector2.all(16),
      ),
    );
    add(SpriteAnimationComponent(animation: sheet, size: Vector2.all(32)));
  }
}
