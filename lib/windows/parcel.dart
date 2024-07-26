import 'dart:math';

import 'package:deliverysim/game_widget.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../component/decorated_window.dart';
import '../model/action_description.dart';
import '../model/crystals.dart';
import '../world/cellitems/map_item.dart';

void showParcel(
  SpriteSheet spritesheet,
  PickupPoint pickupPoint,
  int parcel,
  DeliveryGame game, {
  required ValueSetter<DecoratedWindow> onSkip,
  required ValueSetter<DecoratedWindow> onAccept,
}) {
  DecoratedWindow? dw;
  //evaluate cost
  final product = pickupPoint.products[parcel - 1];
  final targetLocation = game.world.gameMap.indexed
      .where((e) {
        return e.$2.content?.type == MapItemType.drop &&
            (e.$2.content as DropPoint).name == product.target;
      })
      .first
      .$1;
  final tlx = targetLocation % game.world.mapWidth;
  final tly = targetLocation ~/ game.world.mapWidth;
  final distance = sqrt((tlx - pickupPoint.x) * (tlx - pickupPoint.x) +
      (tly - pickupPoint.y) * (tly - pickupPoint.y));
  final cost = (product.weight * distance * 2.0).round(); //2 pounds per kg*m
  product.deliveryCost = cost;
  final borderNo = crystals[pickupPoint.crystalType];
  dw = DecoratedWindow(
      widthFactor: 0.8,
      heightFactor: 0.8,
      borderNo: borderNo!,
      spriteSheet: spritesheet,
      lines: [
        'Welcome to Pick-up Point',
        'Take ${product.name}',
        '${product.weight} pounds',
        'to house ${product.target}',
        'Cost: $cost',
        '',
        'Parcel $parcel/${pickupPoint.products.length}',
      ],
      actions: [
        ActionDescription(
          action: 'Skip parcel',
          onTap: () => onSkip(dw!),
        ),
        ActionDescription(
          action: 'Take parcel to delivery',
          onTap: () => onAccept(dw!),
        ),
      ])
    ..size = game.size;
  game.camera.viewport.add(dw);
}
