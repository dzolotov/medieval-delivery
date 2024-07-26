import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game_widget.dart';

class RightButton extends SpriteComponent
    with TapCallbacks, HasGameRef<DeliveryGame> {
  VoidCallback onTap;

  RightButton({required this.onTap});

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  FutureOr<void> onLoad() async {
    width = 64;
    height = 64;
    sprite = Sprite(await game.images.load('right.png'));
    size = Vector2.all(64);
  }
}
