import 'package:deliverysim/multiplayer/messages/base.dart';

class RequestLeaderMessage extends MessageBase {
  RequestLeaderMessage();

  @override
  String get type => 'requestLeader';

  @override
  Map<String, dynamic> repr() => {};
}
