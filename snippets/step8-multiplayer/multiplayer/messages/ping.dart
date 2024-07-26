import 'package:deliverysim/multiplayer/messages/base.dart';

class PingMessage extends MessageBase {

  @override
  String get type => 'ping';

  @override
  Map<String, dynamic> repr() => {};
}