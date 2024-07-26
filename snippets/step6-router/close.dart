import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../game_widget.dart';

class CloseButton extends SpriteComponent
    with TapCallbacks, HasGameRef<DeliveryGame> {
  VoidCallback onTap;

  CloseButton({required this.onTap});

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  FutureOr<void> onLoad() async {
    width = 32;
    height = 32;
    sprite = Sprite(await game.images.load('close.png'));
  }
}
