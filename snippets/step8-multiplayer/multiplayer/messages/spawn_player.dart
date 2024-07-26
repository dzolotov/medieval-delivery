import 'package:deliverysim/multiplayer/messages/base.dart';

class SpawnPlayerMessage extends MessageBase {
  String uuid;
  int x;
  int y;

  SpawnPlayerMessage({
    required this.uuid,
    required this.x,
    required this.y,
  });

  @override
  String get type => 'spawnPlayer';

  @override
  Map<String, dynamic> repr() => {
        'uuid': uuid,
        'x': x,
        'y': y,
      };
}
