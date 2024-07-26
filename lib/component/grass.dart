import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../game_widget.dart';

class GreenGrass extends SpriteComponent with HasGameRef<DeliveryGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('grass.png'));
  }
}

class RedGrass extends SpriteComponent with HasGameRef<DeliveryGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('grass.png'));
    add(
      ColorEffect(
        Colors.red,
        opacityFrom: 0.0,
        opacityTo: 0.4,
        EffectController(duration: 0.5),
      ),
    );
  }
}

class GrayGrass extends SpriteComponent with HasGameRef<DeliveryGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('grass.png'));
    add(
      ColorEffect(
        Colors.grey,
        opacityFrom: 0.0,
        opacityTo: 0.4,
        EffectController(duration: 0.5),
      ),
    );
  }
}

class BrickSprite extends SpriteComponent with HasGameRef<DeliveryGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('brick.png'));
  }
}

class YellowGrass extends SpriteComponent with HasGameRef<DeliveryGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await game.images.load('grass.png'));
    add(
      ColorEffect(
        Colors.yellow,
        opacityFrom: 0.0,
        opacityTo: 0.4,
        EffectController(duration: 0.5),
      ),
    );
  }
}
