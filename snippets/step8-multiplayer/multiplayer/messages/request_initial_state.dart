import 'package:deliverysim/multiplayer/messages/base.dart';

class RequestInitialStateMessage extends MessageBase {
  @override
  String get type => 'requestInitialState';

  @override
  Map<String, dynamic> repr() => {};
}
