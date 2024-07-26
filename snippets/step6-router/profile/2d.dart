import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide OverlayRoute;

class Knight extends OverlayRoute {
  Knight()
      : super(
          (context, game) => Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SafeArea(
              child: Image.asset(
                'assets/images/knight.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        );
}

class HorseCarriage extends OverlayRoute {
  HorseCarriage()
      : super(
          (context, game) => Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SafeArea(
              child: Image.asset(
                'assets/images/horse.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        );
}

class Dragon extends OverlayRoute {
  Dragon()
      : super(
          (context, game) => Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SafeArea(
              child: Image.asset(
                'assets/images/dragon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        );
}
