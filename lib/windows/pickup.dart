import 'package:deliverysim/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../component/decorated_window.dart';
import '../multiplayer/messages/change_product_list.dart';
import '../world/cellitems/map_item.dart';
import 'parcel.dart';

void showPickupWindow(
  PickupPoint pickupPoint,
  VoidCallback removePickupPoint,
  DeliveryGame game,
) async {
  FlameAudio.play('open.mp3');
  game.world.currentPlayer?.isModal = true;

  final spritesheet = SpriteSheet(
    image: await game.images.load('borders.png'),
    srcSize: Vector2(64, 64),
  );
  int parcel = 1;
  late ValueSetter<DecoratedWindow> skip;
  late ValueSetter<DecoratedWindow> accept;

  void show(spritesheet, pickupPoint, parcel) {
    showParcel(
      spritesheet,
      pickupPoint,
      parcel,
      game,
      onSkip: skip,
      onAccept: accept,
    );
  }

  accept = (dw) {
    //move parcel to player's bag
    final player = game.world.currentPlayer!;
    if (player.cargoWeight + pickupPoint.products[parcel - 1].weight >
        player.current.capacity) {
      FlameAudio.play('error.mp3');
      return;
    }
    FlameAudio.play('take.mp3');
    game.camera.viewport.remove(dw);
    player.bag.add(pickupPoint.products[parcel - 1]);
    pickupPoint.products.removeAt(parcel - 1);
    game.world.multiplayer?.broadcast(ChangeProductListMessage(
      uuid: pickupPoint.uuid,
      products: pickupPoint.products,
    ));
    if (pickupPoint.products.isEmpty) {
      removePickupPoint();
    }
    if (parcel <= pickupPoint.products.length) {
      show(spritesheet, pickupPoint, parcel);
    }
    game.world.currentPlayer?.isModal = false;
  };

  skip = (dw) {
    //hide window
    game.camera.viewport.remove(dw);
    parcel++;
    if (parcel <= pickupPoint.products.length) {
      show(spritesheet, pickupPoint, parcel);
    }
    game.world.currentPlayer?.isModal = false;
  };
  show(spritesheet, pickupPoint, parcel);
}
