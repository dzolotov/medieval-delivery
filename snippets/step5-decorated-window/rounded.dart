import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RoundedComponent extends PositionComponent {
  final Color color;
  final double cornerRadius;
  Color overrideColor;
  double ratio;

  RoundedComponent({
    required super.size,
    this.color = const Color(0xFFFFFFFF),
    this.cornerRadius = 50,
    this.overrideColor = Colors.black,
    this.ratio = 0.5,
    super.position,
  });

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        Radius.circular(cornerRadius),
      ),
    );
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width * ratio, height),
        Paint()
          ..color = overrideColor
          ..style = PaintingStyle.fill);
    canvas.restore();
  }
}
