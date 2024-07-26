import 'dart:async';
import 'dart:math';

import 'package:deliverysim/component/game_over.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Route;

import '../game_widget.dart';
import '../world/world.dart';

class TimeOfDayComponent extends CustomPainterComponent
    with HasGameRef<DeliveryGame> {
  TimeOfDayComponent({required super.painter});

  @override
  FutureOr<void> onLoad() => size = Vector2.all(64);

  @override
  void update(double dt) {
    super.update(dt);
    final dayTime = game.world.dayTime;
    final player = game.world.currentPlayer;
    if (player == null) {
      return;
    }
    if (!player.isResting && !player.isDead) {
      game.world.currentPlayer!.mood -= DeliveryWorld.moodDegrade;
      if (game.world.currentPlayer!.mood <= 0) {
        //game over
        game.world.currentPlayer!.isDead = true;
        game.world.currentPlayer?.component?.removeFromParent();
        game.world.backgroundMusic?.stop();
        FlameAudio.play('gameover.mp3');
        game.world.gameoverPlayer(game.world.currentPlayerId);
        game.router.pushRoute(
          Route(
            () => GameOverComponent()
              ..size = game.viewportResolution
              ..position = Vector2.zero(),
          ),
        );
      }
    }
    dayTime.update(dt);
    if (dayTime.finished) {
      game.resetDay();
    }
  }
}

class TimeOfDayCustomPainter extends CustomPainter {
  TimeOfDayCustomPainter(this.world);

  DeliveryWorld world;
  int previousAngle = -1;

  @override
  void paint(Canvas canvas, Size size) {
    //will call 60fps
    canvas.drawArc(
        Offset.zero & size,
        0,
        -pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white);
    final delta = (world.dayTime.current * DeliveryWorld.timeFactor) /
        (DeliveryWorld.dayEnd - DeliveryWorld.dayStart);
    final angle = pi * (1 - delta);
    canvas.drawCircle(
      Offset(32 + cos(angle) * 32, 32 - sin(angle) * 32),
      8,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.yellow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //todo: check timer limit
    final delta = (world.dayTime.current * DeliveryWorld.timeFactor) /
        (DeliveryWorld.dayEnd - DeliveryWorld.dayStart);
    final angle = ((pi * (1 - delta)) / pi * 180).toInt();
    if (angle == previousAngle) {
      return false;
    } else {
      previousAngle = angle;
      return true;
    }
  }
}
