import 'package:deliverysim/multiplayer/messages/base.dart';

import '../../model/product.dart';

class ChangeProductListMessage extends MessageBase {
  String uuid;
  List<Product> products;

  ChangeProductListMessage({
    required this.uuid,
    required this.products,
  });

  @override
  String get type => 'changeProductList';

  @override
  Map<String, dynamic> repr() => {
        'uuid': uuid,
        'products': products.map((e) => e.toJson()).toList(),
      };
}
