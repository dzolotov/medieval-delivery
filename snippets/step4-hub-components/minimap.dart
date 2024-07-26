import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_widget.dart';
import '../model/quality.dart';
import '../world/cellitems/map_item.dart';

class MiniMap extends CustomPainterComponent with HasGameRef<DeliveryGame> {
  Color _getQualityColor(
    Quality quality,
  ) {
    if (quality == Quality.FORBIDDEN) {
      return Colors.blueGrey.withOpacity(0.3);
    }
    if (quality == Quality.RED) {
      return Colors.red.withOpacity(0.3);
    }
    if (quality == Quality.YELLOW) {
      return Colors.yellow.withOpacity(0.3);
    }
    return Colors.black;
  }

  Color _getColor(
    MapItemType? item,
    double width,
    double height,
  ) {
    switch (item) {
      case MapItemType.pickup:
        return Colors.white;
      case MapItemType.food:
        return Colors.green;
      case MapItemType.drop:
        return Colors.orangeAccent;
      case MapItemType.player:
        return Colors.blue;
      case null:
        return Colors.black;
    }
  }

  Path getPath(MapItemType? item, double width, double height) {
    switch (item) {
      case MapItemType.food:
        return Path()
          ..moveTo(width / 2, 0)
          ..lineTo(width, height / 2)
          ..lineTo(width / 2, height)
          ..lineTo(0, height / 2)
          ..close();
      case MapItemType.pickup:
        return Path()
          ..moveTo(width / 2, 0)
          ..lineTo(width, height)
          ..lineTo(0, height)
          ..close();
      case MapItemType.drop:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(width, height / 2)
          ..lineTo(0, height)
          ..close();
      case MapItemType.player:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(width, 0)
          ..lineTo(width, height)
          ..lineTo(0, height)
          ..close();
      case null:
        return Path();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(Offset.zero & size.toSize(), Paint()..color = Colors.black);
    final rectWidth = size.x / game.world.mapWidth;
    final rectHeight = size.y / game.world.mapHeight;
    if (game.world.gameMap.isNotEmpty) {
      for (int y = 0; y < game.world.mapHeight; y++) {
        for (int x = 0; x < game.world.mapWidth; x++) {
          final xp = size.x * x / game.world.mapWidth;
          final yp = size.y * y / game.world.mapHeight;
          final paint = Paint()
            ..color = _getQualityColor(
                game.world.gameMap[y * game.world.mapWidth + x].quality);
          canvas.drawRect(Offset(xp, yp) & Size(rectWidth, rectHeight), paint);
        }
      }
    }
    for (final (k, v) in game.world.gameMap.indexed) {
      int px = k % game.world.mapWidth;
      int py = k ~/ game.world.mapHeight;
      final x = size.x * px / game.world.mapWidth;
      final y = size.y * py / game.world.mapHeight;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = _getColor(v.content?.type, rectWidth, rectHeight);
      final path = getPath(v.content?.type, rectWidth, rectHeight);
      canvas.save();
      canvas.translate(x, y);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    for (final k in game.world.players.keys) {
      final x = game.world.players[k]!.x * size.x / game.world.mapWidth;
      final y = game.world.players[k]!.y * size.y / game.world.mapHeight;
      final paint = Paint()..color = Colors.lightBlue;
      canvas.drawRect(Offset(x, y) & Size(rectWidth, rectHeight), paint);
    }
    canvas.drawRect(
      Offset.zero & size.toSize(),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke,
    );
  }
}
