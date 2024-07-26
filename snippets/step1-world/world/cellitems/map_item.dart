import 'package:flame/components.dart';

import '../../model/product.dart';

class MapItem {
  Component? component;
  int x;
  int y;
  MapItemType type;
  String uuid;

  MapItem({
    required this.x,
    required this.y,
    required this.type,
    required this.uuid,
  });

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'itemType': type.name,
        'uuid': uuid,
      };
}

enum MapItemType {
  pickup,
  drop,
  food,
  player,
}

class DropPoint extends MapItem {
  String name;

  DropPoint({
    required super.x,
    required super.y,
    required super.uuid,
    required this.name,
  }) : super(type: MapItemType.drop);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'name': name,
      };

  DropPoint.fromJson(Map<String, dynamic> data)
      : this(
          x: data['x'],
          y: data['y'],
          uuid: data['uuid'],
          name: data['name'],
        );
}

class PickupPoint extends MapItem {
  List<Product> products;
  String crystalType;

  PickupPoint({
    required super.x,
    required super.y,
    required super.uuid,
    required this.products,
    required this.crystalType,
  }) : super(type: MapItemType.pickup);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'crystalType': crystalType,
        'products': products.map((e) => e.toJson()).toList(),
      };

  PickupPoint.fromJson(Map<String, dynamic> data)
      : this(
            x: data['x'],
            y: data['y'],
            uuid: data['uuid'],
            crystalType: data['crystalType'],
            products:
                data['products'].map((e) => Product.fromJson(e)).toList());
}

class FoodPoint extends MapItem {
  FoodPoint({
    required super.x,
    required super.y,
    required super.uuid,
  }) : super(type: MapItemType.food);

  FoodPoint.fromJson(Map<String, dynamic> data)
      : this(
          x: data['x'],
          y: data['y'],
          uuid: data['uuid'],
        );
}
