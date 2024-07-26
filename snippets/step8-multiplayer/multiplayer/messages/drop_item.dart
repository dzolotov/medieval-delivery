import 'package:deliverysim/multiplayer/messages/base.dart';

class DropItemMessage extends MessageBase {
  String uuid;

  DropItemMessage({required this.uuid});

  @override
  String get type => 'drop_item';

  @override
  Map<String, dynamic> repr() => {
        'uuid': uuid,
      };
}
