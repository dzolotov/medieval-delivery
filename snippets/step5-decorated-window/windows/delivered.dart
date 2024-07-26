import 'package:deliverysim/game_widget.dart';
import 'package:deliverysim/model/product.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import '../component/decorated_window.dart';
import '../model/action_description.dart';

void showDelivered(
  DeliveryGame game,
  List<Product> toTarget,
) async {
  game.world.currentPlayer?.isModal = true;
  FlameAudio.play('door.mp3');
  final spritesheet = SpriteSheet(
    image: await game.images.load('borders.png'),
    srcSize: Vector2(64, 64),
  );

  late DecoratedWindow dw;
  dw = DecoratedWindow(
      widthFactor: 0.8,
      heightFactor: 0.6,
      borderNo: 0,
      spriteSheet: spritesheet,
      lines: [
        'You have delivered parcels',
        for (final parcel in toTarget)
          '${parcel.name} (${parcel.weight} pounds) -> ${parcel.deliveryCost}',
      ],
      actions: [
        ActionDescription(
          action: 'Take the money',
          onTap: () {
            dw.removeFromParent();
            game.world.currentPlayer?.isModal = false;

            FlameAudio.play('coins.mp3');
            game.world.currentPlayer?.money +=
                toTarget.map((e) => e.deliveryCost!).reduce((a, b) => a + b);
            //remove from bag
            toTarget.toList().forEach((e) {
              game.world.currentPlayer?.bag.remove(e);
            });
          },
        ),
      ])
    ..position = Vector2.zero()
    ..size = game.viewportResolution;

  game.camera.viewport.add(dw);
}
