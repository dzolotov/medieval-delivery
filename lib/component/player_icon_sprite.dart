import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';

import '../game_widget.dart';

class PlayerIconSprite extends PositionComponent
    with HasGameRef<DeliveryGame>, TapCallbacks {
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.router.pushNamed('profile');
  }

  @override
  FutureOr<void> onLoad() async {
    final s = SpriteSheet(
        image: await game.images.load('courier_spritesheet.png'),
        srcSize: Vector2.all(32));
    add(SpriteComponent(sprite: s.getSprite(0, 0))..size = Vector2.all(64));
  }
}
