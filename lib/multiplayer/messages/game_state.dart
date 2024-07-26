import 'dart:convert';

import 'package:deliverysim/multiplayer/messages/base.dart';
import 'package:deliverysim/world/cellitems/cell.dart';

import '../../model/player_information.dart';

class GameStateMessage extends MessageBase {
  Map<String, PlayerInformation> players;
  List<CellDescriptor> gameMap;
  double time;

  GameStateMessage({
    required this.players,
    required this.gameMap,
    required this.time,
  });

  @override
  String get type => 'gameState';

  @override
  Map<String, dynamic> repr() => {
        'players': players.entries
            .map(
              (e) => {
                'uuid': e.key,
                ...e.value.toJson(),
              },
            )
            .toList(),
        'map': gameMap.map((e) => e.toJson()).toList(),
        'time': time,
      };
}
