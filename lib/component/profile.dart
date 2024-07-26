import 'dart:async';

import 'package:deliverysim/component/medieval_button.dart';
import 'package:deliverysim/model/action_description.dart';
import 'package:deliverysim/world/world.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide CloseButton;

import '../game_widget.dart';
import '../model/transport_type.dart';
import '../theme/theme.dart';
import 'close.dart';
import 'left.dart';
import 'right.dart';

class ProfileComponent extends PositionComponent with HasGameRef<DeliveryGame> {
  int currentTransport = 0;

  int lastTransport = 0;

  void build() {}

  @override
  void update(double dt) {
    if (lastTransport != currentTransport) {
      for (final f in children) {
        f.removeFromParent();
      }
      final p = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.brown.shade900;
      //background
      add(RectangleComponent()
        ..size = size
        ..position = Vector2.zero()
        ..paint = p);
      add(CloseButton(onTap: () {
        game.router.pop(); //2d/3d model overlay
        game.router.pop(); //close profile
      })
        ..position = Vector2(size.x - 64, 40)
        ..size = Vector2.all(32));
      final transport = DeliveryWorld.transports[currentTransport];
      game.router.pushOverlay(transport.model);
      final renderer = TextPaint(
          style: const TextStyle(
        fontFamily: GameTheme.font,
        fontSize: 22,
        color: Colors.white,
      ));
      final str = transport.type;
      add(
        TextComponent(text: str, textRenderer: renderer)
          ..position = Vector2(
              (size.x - renderer.getLineMetrics(str).width) / 2, size.y * 0.7),
      );
      final str2 = 'Capacity: ${transport.capacity}';
      add(
        TextComponent(text: str2, textRenderer: renderer)
          ..position = Vector2(
              (size.x - renderer.getLineMetrics(str2).width) / 2,
              size.y * 0.75),
      );
      final str3 = 'Price: ${transport.price}';
      add(
        TextComponent(text: str3, textRenderer: renderer)
          ..position = Vector2(
            (size.x - renderer.getLineMetrics(str3).width) / 2,
            size.y * 0.8,
          ),
      );
      final rendererBold = TextPaint(
          style: const TextStyle(
        fontFamily: GameTheme.font,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ));
      final cp = game.world.currentPlayer!;
      if (cp.current == DeliveryWorld.transports[currentTransport]) {
        const str4 = 'Selected';
        add(
          TextComponent(text: str4, textRenderer: rendererBold)
            ..position = Vector2(
              (size.x - rendererBold.getLineMetrics(str4).width) / 2,
              size.y * 0.85,
            ),
        );
      } else {
        if (cp.availableTransports
            .contains(DeliveryWorld.transports[currentTransport])) {
          final canSell = cp.availableTransports.length != 1;
          add(
            MedievalButton(
              action: ActionDescription(
                  action: 'Select',
                  onTap: () {
                    if (cp.cargoWeight > transport.capacity) {
                      FlameAudio.play('error.mp3');
                    } else {
                      cp.current = transport;
                      lastTransport = -1;
                    }
                  }),
              width: size.x / 4,
              scaleFactor: game.world.scaleFactor,
            )..position = Vector2(
                canSell ? size.x * 0.45 : size.x * 3 / 4, size.y * 0.85),
          );
          if (canSell) {
            add(
              MedievalButton(
                action: ActionDescription(
                    action: 'Sell',
                    onTap: () {
                      cp.availableTransports.remove(transport);
                      FlameAudio.play('coins.mp3');
                      cp.money += transport.price;
                      lastTransport = -1;
                    }),
                width: size.x / 2,
                scaleFactor: game.world.scaleFactor,
              )..position = Vector2(size.x / 2, size.y * 0.85),
            );
          }
        } else {
          //check money
          if (cp.money >= transport.price) {
            add(
              MedievalButton(
                action: ActionDescription(
                    action: 'Buy',
                    onTap: () {
                      FlameAudio.play('coins.mp3');
                      cp.availableTransports.add(transport);
                      cp.money -= transport.price;
                      lastTransport = -1;
                    }),
                width: size.x * 3 / 4,
                scaleFactor: game.world.scaleFactor,
              )..position = Vector2(size.x / 4, size.y * 0.85),
            );
          }
        }
      }

      if (currentTransport < DeliveryWorld.transports.length - 1) {
        add(RightButton(onTap: () {
          currentTransport++;
          game.router.pop();
        })
          ..position = size - Vector2.all(GameTheme.spriteSize*game.world.scaleFactor));
      }
      if (currentTransport > 0) {
        add(LeftButton(onTap: () {
          currentTransport--;
          game.router.pop();
        })
          ..position = Vector2(32, size.y - GameTheme.spriteSize*game.world.scaleFactor));
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    lastTransport = -1;
    currentTransport = 0;
  }
}
