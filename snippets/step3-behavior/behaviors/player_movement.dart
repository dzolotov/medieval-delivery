import 'dart:convert';
import 'dart:ui';

import 'package:deliverysim/component/player_sprite.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';

import '../model/direction.dart';
import '../model/quality.dart';
import '../theme/theme.dart';

class PlayerMovementBehavior extends Behavior<PlayerSprite>
    with KeyboardHandler, HasGameRef<DeliveryGame> {
  int waitingEffects = 0;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final world = game.world;
    if (event is! KeyDownEvent || world.currentPlayer!.isModal || world.currentPlayer!.isDead) {
      return false;
    }
    final p = world.currentPlayer!;
    final q = world.gameMap[p.y * world.mapWidth + p.x].quality;
    double duration = q.getSlowFactor();
    //cargo -> slow
    duration = duration * (1 + p.cargoWeight / p.current.capacity);
    final controller = EffectController(
        duration: duration.toDouble(),
        onMax: () {
          waitingEffects--;
          if (waitingEffects == 0) {
            //apply all waiting effects
            final waiting = [];
            for (final p in parent.children) {
              waiting.add(p);
            }
            for (final e in waiting) {
              if (e is MoveByEffect) {
                parent.position = e.target.position;
                parent.position.x = clampDouble(
                    e.target.position.x,
                    -GameTheme.spriteSize *
                        world.scaleFactor *
                        world.mapWidth /
                        2,
                    GameTheme.spriteSize *
                        world.scaleFactor *
                        (world.mapWidth / 2 - 1));
                parent.position.y = clampDouble(
                    e.target.position.y,
                    -GameTheme.spriteSize *
                        world.scaleFactor *
                        world.mapHeight /
                        2,
                    GameTheme.spriteSize *
                        world.scaleFactor *
                        (world.mapHeight / 2 - 1));
                e.removeFromParent();
              }
            }
          }
          //update player position to effective
        });
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final p = world.currentPlayer!;
      if (p.y > 0 &&
          world.gameMap[p.x + (p.y - 1) * world.mapWidth].quality !=
              Quality.FORBIDDEN) {
        p.y--;
        final effect = MoveByEffect(
            Vector2(0, -GameTheme.spriteSize * world.scaleFactor), controller);
        parent.add(effect);
        waitingEffects++;
        return true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final p = world.currentPlayer!;
      if (p.y < world.mapHeight - 1 &&
          world.gameMap[p.x + (p.y + 1) * world.mapWidth].quality !=
              Quality.FORBIDDEN) {
        p.y++;

        waitingEffects++;
        parent.add(MoveByEffect(
            Vector2(0, GameTheme.spriteSize * world.scaleFactor), controller));
        return true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      final p = world.currentPlayer!;
      if (p.x > 0 &&
          world.gameMap[p.x - 1 + p.y * world.mapWidth].quality !=
              Quality.FORBIDDEN) {
        p.x--;

        waitingEffects++;
        world.currentPlayer?.isMirrored = true;
        game.camera.follow(
            world.updatePlayer(world.currentPlayer!, updatePosition: false)!, snap: true);
        parent.add(MoveByEffect(
            Vector2(-GameTheme.spriteSize * world.scaleFactor, 0.0),
            controller));
        return true;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final p = world.currentPlayer!;
      if (p.x < world.mapWidth - 1 &&
          world.gameMap[p.x + 1 + p.y * world.mapWidth].quality !=
              Quality.FORBIDDEN) {
        p.x++;

        waitingEffects++;
        world.currentPlayer?.isMirrored = false;
        game.camera.follow(
            world.updatePlayer(world.currentPlayer!, updatePosition: false)!, snap: true);
        parent.add(MoveByEffect(
            Vector2(GameTheme.spriteSize * world.scaleFactor, 0.0),
            controller));
        return true;
      }
    }
    return false;
  }
}
