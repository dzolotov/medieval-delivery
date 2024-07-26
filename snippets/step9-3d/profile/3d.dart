import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide OverlayRoute;

class Knight3D extends OverlayRoute {
  Knight3D() : super((context, game) => const SizedBox.shrink());
}

class Dragon3D extends OverlayRoute {
  Dragon3D() : super((context, game) => const SizedBox.shrink());
}

class HorseCarriage3D extends OverlayRoute {
  HorseCarriage3D() : super((context, game) => const SizedBox.shrink());
}

/*
class Knight3D extends OverlayRoute {
  Knight3D()
      : super(
          (context, game) {
            final animation = ValueNotifier(0.0);
            final t = Ticker((dt) {
              animation.value = dt.inMilliseconds / 1000;
            }).start();
            return ValueListenableBuilder(
              valueListenable: animation,
              builder: (context, value, _) => SceneBox(
                root: Node.transform(
                  transform: Matrix4.rotationY(value),
                  children: [Node.asset('models/knight2.glb')],
                ),
                camera: Camera(
                  position: Vector3(0, 0, 70),
                  target: Vector3(0, 0, 0),
                  up: Vector3(0, 1, 0),
                ),
              ),
            );
          },
        );
}

class Pegasus extends OverlayRoute {
  Pegasus()
      : super(
          (context, game) {
            final animation = ValueNotifier(0.0);
            Ticker((dt) {
              animation.value = dt.inMilliseconds / 1000;
            }).start();
            return ValueListenableBuilder(
              valueListenable: animation,
              builder: (context, value, _) => SceneBox(
                root: Node.transform(
                  transform: Matrix4.rotationY(value),
                  children: [Node.asset('models/pegasus.glb')],
                ),
                camera: Camera(
                  position: Vector3(0, 0, 10),
                  target: Vector3(0, 0, 0),
                  up: Vector3(0, 1, 0),
                ),
              ),
            );
          },
        );
}

class HorseCarriage extends OverlayRoute {
  HorseCarriage()
      : super(
          (context, game) {
            final animation = ValueNotifier(0.0);
            final t = Ticker((dt) {
              animation.value = dt.inMilliseconds / 1000;
            }).start();
            return ValueListenableBuilder(
              valueListenable: animation,
              builder: (context, value, _) => SceneBox(
                root: Node.transform(
                  transform: Matrix4.rotationY(value),
                  children: [Node.asset('models/horse_carriage.glb')],
                ),
                camera: Camera(
                  position: Vector3(0, 0, 30),
                  target: Vector3(0, 0, 0),
                  up: Vector3(0, 1, 0),
                ),
              ),
            );
          },
        );
}
*/
