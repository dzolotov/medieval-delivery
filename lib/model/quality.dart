import 'package:flame/components.dart';

import '../component/grass.dart';

enum Quality {
  UNKNOWN,
  GREEN,
  FORBIDDEN,
  RED,
  YELLOW;

  static Quality? getByName(String name) {
    try {
      return Quality.values.firstWhere((q) => q.name == name);
    } catch (_) {
      return null;
    }
  }

  double getSlowFactor() => switch (this) {
        Quality.GREEN => 1,
        Quality.YELLOW => 2,
        Quality.RED => 4,
        Quality.FORBIDDEN => 1,
        Quality.UNKNOWN => 1,
      };

  SpriteComponent getSprite() => switch (this) {
        Quality.GREEN => GreenGrass(),
        Quality.FORBIDDEN => BrickSprite(),
        Quality.RED => RedGrass(),
        Quality.YELLOW => YellowGrass(),
        Quality.UNKNOWN => GrayGrass(),
      };
}
