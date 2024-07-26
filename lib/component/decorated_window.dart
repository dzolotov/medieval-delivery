import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../game_widget.dart';
import '../model/action_description.dart';
import '../theme/theme.dart';
import 'medieval_button.dart';

class DecoratedWindow extends PositionComponent with HasGameRef<DeliveryGame> {
  SpriteSheet spriteSheet;
  int borderNo;
  double widthFactor;
  double heightFactor;
  PositionComponent? customComponent;
  List<String>? lines;
  List<ActionDescription>? actions;

  DecoratedWindow({
    required this.widthFactor,
    required this.heightFactor,
    required this.borderNo,
    required this.spriteSheet,
    this.customComponent,
    this.lines,
    this.actions,
  });

  @override
  Future<void> onLoad() async {
    double scale = 1.0;
    if (size.x > size.y) {
      heightFactor = 0.9;
      scale = 0.5;
    }
    final borderX = (borderNo % 5) * 3;
    final borderY = (borderNo ~/ 5) * 3;

    final width = (size.x * widthFactor) ~/ (64 * scale) * (64 * scale);
    final height = (size.y * heightFactor) ~/ (64 * scale) * (64 * scale);
    final topLength = (width - 128 * scale) ~/ (64 * scale);
    final leftLength = (height - 128 * scale) ~/ (64 * scale);
    double shiftY = (size.y - height) / 2;
    for (int y = 0; y <= leftLength; y++) {
      //top window line
      double shiftX = (size.x - width) / 2;
      add(
        SpriteComponent(
            sprite: spriteSheet.getSprite(
                borderY +
                    (y == 0
                        ? 0
                        : y < leftLength
                            ? 1
                            : 2),
                borderX))
          ..position = Vector2(shiftX, shiftY)
          ..size = Vector2.all(64 * scale),
      );
      for (int i = 0; i < topLength; i++) {
        shiftX += 64 * scale;
        add(
          SpriteComponent(
              sprite: spriteSheet.getSprite(
                  borderY +
                      (y == 0
                          ? 0
                          : y < leftLength
                              ? 1
                              : 2),
                  borderX + 1))
            ..position = Vector2(shiftX, shiftY)
            ..size = Vector2.all(64 * scale),
        );
      }
      shiftX += 64 * scale;
      add(
        SpriteComponent(
            sprite: spriteSheet.getSprite(
                borderY +
                    (y == 0
                        ? 0
                        : y < leftLength
                            ? 1
                            : 2),
                borderX + 2))
          ..position = Vector2(shiftX, shiftY)
          ..size = Vector2.all(64 * scale),
      );
      shiftY += 64 * scale;
    }
    //show lines
    if (lines != null && lines!.isNotEmpty) {
      double shiftX = (size.x - width) / 2 + 64 * scale;
      shiftY = (size.y - height) / 2 + 64 * scale;
      for (final line in lines ?? []) {
        final renderer = TextPaint(
          style: TextStyle(
            fontFamily: GameTheme.font,
            color: Colors.white,
            fontSize: scale * 22,
          ),
        );
        final metrics = renderer.getLineMetrics(line);
        final position =
            Vector2((width - 128 * scale - metrics.width) / 2 + shiftX, shiftY);
        add(
          TextComponent(text: line, textRenderer: renderer)
            ..position = position,
        );
        shiftY += metrics.height + 8;
      }

      shiftX = (size.x - width) / 2 + 64 * scale;
      shiftY = (size.y - height) / 2 + height - 128 * scale - 48;
      for (final action in actions ?? <ActionDescription>[]) {
        add(MedievalButton(
          action: action,
          width: width.toDouble(),
          scaleFactor: scale,
        )..position = Vector2(shiftX, shiftY));
        shiftY -= 48 * scale;
      }
    }
    if (customComponent != null) {
      add(customComponent!
        ..position = Vector2.all(64 * scale)
        ..size = Vector2(width - 128 * scale, height - 128 * scale));
    }
  }
}
