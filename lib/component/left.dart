import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../game_widget.dart';

class LeftButton extends SpriteComponent
    with TapCallbacks, HasGameRef<DeliveryGame> {
  VoidCallback onTap;

  LeftButton({required this.onTap});

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  FutureOr<void> onLoad() async {
    width = 64;
    height = 64;
    sprite = Sprite(await game.images.load('left.png'));
  }
}
