import 'package:deliverysim/multiplayer/messages/base.dart';

class SetLeaderMessage extends MessageBase {
  String id;

  SetLeaderMessage({required this.id});

  @override
  String get type => 'setLeader';

  @override
  Map<String, dynamic> repr() => {'id': id};
}
