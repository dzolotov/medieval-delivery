import 'package:deliverysim/multiplayer/messages/base.dart';

class GameOverPlayerMessage extends MessageBase {
  String uuid;

  GameOverPlayerMessage({required this.uuid});

  @override
  String get type => 'gameOverPlayer';

  @override
  Map<String, dynamic> repr() => {'uuid': uuid};
}
