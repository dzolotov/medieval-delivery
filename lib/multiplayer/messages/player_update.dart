import 'package:deliverysim/multiplayer/messages/base.dart';

class PlayerUpdateMessage extends MessageBase {
  int x;
  int y;
  String uuid;

  PlayerUpdateMessage({
    required this.x,
    required this.y,
    required this.uuid,
  });

  @override
  String get type => 'playerUpdate';

  @override
  Map<String, dynamic> repr() => {'x': x, 'y': y, 'uuid': uuid};
}
