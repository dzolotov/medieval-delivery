import 'package:deliverysim/model/transport_type.dart';
import 'package:deliverysim/world/cellitems/map_item.dart';
import 'package:deliverysim/world/world.dart';

import 'product.dart';

class PlayerInformation extends MapItem {
  bool? isMirrored = false;

  int money;
  TransportType current = DeliveryWorld.transports.first;
  Set<TransportType> availableTransports = {
    DeliveryWorld.transports.first,
  };
  bool isModal = false;
  bool isDead = false;
  bool isResting = false;
  double mood = 100.0;
  List<Product> bag = [];

  int get cargoWeight =>
      bag.isEmpty ? 0 : bag.map((e) => e.weight).reduce((a, b) => a + b);

  PlayerInformation({
    required super.x,
    required super.y,
    required super.uuid,
    required this.money,
    this.isMirrored,
    this.isDead = false,
    this.isResting = false,
  }) : super(type: MapItemType.player);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'isMirrored': isMirrored,
        'isResting': isResting,
        'isDead': isDead,
      };

  PlayerInformation.fromJson(Map<String, dynamic> data)
      : this(
          x: data['x'],
          y: data['y'],
          money: data['money'] ?? 0,
          uuid: data['uuid'],
          isMirrored: data['isMirrored'],
          isDead: data['isDead'],
          isResting: data['isResting'],
        );
}
