import '../../snippets/step1-world/components/pickup_sprite.dart';
import 'package:deliverysim/component/player_sprite.dart';
import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../windows/pickup.dart';

class PlayerPickupPointCollisionBehavior
    extends CollisionBehavior<PickupPointSprite, PlayerSprite>
    with HasGameRef<DeliveryGame> {
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PickupPointSprite other) {
    showPickupWindow(
      other.descriptor,
      () {
        game.world.dropItem(other.descriptor);
        game.world.placePickup();
      },
      game,
    );
  }
}
