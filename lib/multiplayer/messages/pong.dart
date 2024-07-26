import 'package:deliverysim/multiplayer/messages/base.dart';

class PongMessage extends MessageBase {
  @override
  String get type => 'pong';

  @override
  Map<String, dynamic> repr() => {};
}