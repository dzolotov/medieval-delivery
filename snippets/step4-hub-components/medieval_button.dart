import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../model/action_description.dart';
import '../theme/theme.dart';

class MedievalButton extends PositionComponent
    with TapCallbacks, HoverCallbacks {
  ActionDescription action;

  double width;
  Component? background;
  double scaleFactor;

  MedievalButton({
    required this.action,
    required this.width,
    required this.scaleFactor,
  });

  @override
  FutureOr<void> onLoad() {
    final renderer = TextPaint(
      style:  TextStyle(
        fontFamily: GameTheme.font,
        color: Colors.white,
        fontSize: 24*scaleFactor,
      ),
    );
    final metrics = renderer.getLineMetrics(action.action);
    final position = Vector2((width - 128*scaleFactor - metrics.width) / 2, 0);
    add(
      TextComponent(text: action.action, textRenderer: renderer)
        ..position = position,
    );
    add(
      RectangleComponent(
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.white)
        ..size = metrics.size + Vector2(8, 8)
        ..position = position - Vector2(4, 4),
    );
    size = Vector2(width, metrics.size.y);
  }

  @override
  void onTapDown(TapDownEvent event) {
    action.onTap();
  }
}
