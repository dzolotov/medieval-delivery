import 'dart:async';
import 'dart:ui';

import 'package:deliverysim/game_widget.dart';
import 'package:deliverysim/theme/theme.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Route;

class GameOverComponent extends PositionComponent
    with TapCallbacks, HasGameRef<DeliveryGame> {
  @override
  void onTapDown(TapDownEvent event) async {
    game.world.players.remove(game.world.currentPlayerId);
    game.world.build();
    game.world.updatePlayer(game.world.currentPlayer!, updatePosition: true);
    game.camera.follow(game.world.currentPlayerComponent!, snap: true);
    game.router.pop();
    game.world.backgroundMusic =
        await FlameAudio.loopLongAudio('greensleeves.mp3');
  }

  @override
  FutureOr<void> onLoad() async {
    final p = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.fill;
    //barrier
    add(RectangleComponent()
      ..paint = p
      ..position = size * 0.1
      ..size = size * 0.8);
    final renderer = TextPaint(
      style: const TextStyle(
          fontFamily: GameTheme.font, fontSize: 96, color: Colors.red),
    );
    add(
      TextComponent(text: 'GAME\nOVER', textRenderer: renderer)
        ..anchor = Anchor.center
        ..position = size / 2,
    );
  }
}
