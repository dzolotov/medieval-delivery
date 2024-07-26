import 'package:deliverysim/component/drop_sprite.dart';
import 'package:deliverysim/windows/delivered.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../component/decorated_window.dart';
import '../component/player_sprite.dart';
import '../game_widget.dart';
import '../model/action_description.dart';

class PlayerDropPointCollisionBehavior
    extends CollisionBehavior<DropSprite, PlayerSprite>
    with HasGameRef<DeliveryGame> {
  @override
  Future<void> onCollisionStart(
      Set<Vector2> intersectionPoints, DropSprite other) async {
    //apply drop
    final player = game.world.currentPlayer!;
    try {
      final toTarget =
          player.bag.where((e) => e.target == other.dropPoint.name).toList();
      if (toTarget.isNotEmpty) {
        //show dialog
        showDelivered(game, toTarget);
      }
    } catch (_) {
      //just skip the drop
    }
  }
}
