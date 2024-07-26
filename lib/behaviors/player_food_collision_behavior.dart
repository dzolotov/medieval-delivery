import 'package:deliverysim/component/player_sprite.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../component/food_sprite.dart';
import '../windows/tavern.dart';

class PlayerFoodPointCollisionBehavior
    extends CollisionBehavior<FoodSprite, PlayerSprite>
    with HasGameRef<DeliveryGame> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, FoodSprite other) {
    FlameAudio.play('taverndoor.mp3');
    showFoodWindow(game);
  }
}
