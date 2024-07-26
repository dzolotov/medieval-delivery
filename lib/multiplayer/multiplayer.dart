import 'dart:async';
import 'dart:convert';
import 'dart:math' hide log;

import 'package:deliverysim/multiplayer/messages/base.dart';
import 'package:deliverysim/multiplayer/messages/ping.dart';
import 'package:deliverysim/multiplayer/messages/pong.dart';
import 'package:deliverysim/multiplayer/messages/request_initial_state.dart';
import 'package:deliverysim/multiplayer/messages/request_leader.dart';
import 'package:deliverysim/world/world.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:developer';

import 'messages/set_leader.dart';
import 'webrtc/call_sample/signaling.dart';

typedef PlayerId = String;
typedef PeerId = String;

typedef MultiplayerMessageHandler = void Function(
    PeerId source, Map<String, dynamic> message);

class Multiplayer {
  DeliveryWorld world;

  Multiplayer(this.world);

  static const host = 'webrtc.dzolotov.tech';

  late Signaling signaling;

  bool stateIsSynchronized = false;

  String self = ''; //self peer id
  String _leader = ''; //coordinates game time and field

  List<String> messages = [];

  List<MultiplayerMessageHandler> _handlers = [];

  void broadcast(MessageBase message) {
    if (outgoingChannels.isNotEmpty) {
      log('Broadcast to: ${outgoingChannels.length}, $message',
          name: 'WebRTC $self');
      for (final outgoing in outgoingChannels.values) {
        outgoing.send(RTCDataChannelMessage(message.marshal()));
      }
    }
  }

  void unicast(String to, MessageBase message) {
    log('To: $to, $message', name: 'WebRTC $self');
    outgoingChannels[to]?.send(RTCDataChannelMessage(message.marshal()));
  }

  Future<void> disconnect() async {
    for (final e in outgoingChannels.values) {
      await e.close();
    }
  }

  void addListener(MultiplayerMessageHandler listener) =>
      _handlers.add(listener);

  void removeListener(MultiplayerMessageHandler listener) =>
      _handlers.remove(listener);

  Map<PeerId, PlayerId?> playersLink = {};
  Map<PeerId, RTCDataChannel> outgoingChannels = {};
  Map<PeerId, RTCDataChannel?> incomingChannels = {};
  Timer? leaderRequestTimer;
  Map<PeerId, Timer?> inviteTimeoutTimer = {};
  Set<PeerId> _peers = {};
  Map<PeerId, Timer?> pingTimer = {};
  Map<PeerId, Timer?> pingWaitTimer = {};

  Future<void> initWebRTC() async {
    signaling = Signaling(host, null);
    signaling.onPeersUpdate = (peers) async {
      //Peers list updated
      final _newPeers = peers['peers'];
      self = peers['self'];
      final ids = _newPeers.map((e) => e['id']).cast<String>().toList().toSet();
      if (ids.length == 1) {
        //we started first
        _leader = self;
      }
      _peers = ids;
      final registered = playersLink.keys.toSet();
      final newIds = ids.difference(registered);
      final removedIds = registered.difference(ids);
      for (final newId in newIds) {
        playersLink[newId] = null;
        if (newId != self) {
          log('Create p2p channel with $newId', name: 'WebRTC $self');
          //it is possible to timeout here if destination is not reachable
          signaling.invite(newId, 'data', false);
          inviteTimeoutTimer[newId] = Timer(Duration(seconds: 2), () {
            inviteTimeoutTimer[newId] = null;
            log('Remove peer $newId with invite timeout', name: 'WebRTC $self');
            _peers.remove(newId);
            if (_peers.length == 1) {
              //we are only one, take leadership
              _leader = self;
              log('Leadership owner by ourselves (no one in neighbourghood)',
                  name: 'WebRTC $self');
            }
          });
        }
      }
      for (final removedId in removedIds) {
        if (removedId == _leader) {
          //leader was removed, take leadership (who can)
          _leader = self;
          outgoingChannels.remove(removedId);
          incomingChannels.remove(removedId);
          pingTimer[removedId]?.cancel();
          pingTimer.remove(removedId);
          log('Leader was lost, now leader is me: $_leader',
              name: 'WebRTC $self');
          broadcast(SetLeaderMessage(id: _leader));
        }
        playersLink.remove(removedId);
      }
      playersLink[self] = world.currentPlayerId;
    };
    signaling.onDataChannel = (session, channel) {
      channel.onDataChannelState = (state) {
        if (state == RTCDataChannelState.RTCDataChannelOpen) {
          //cancel timer on any message
          inviteTimeoutTimer[session.pid]?.cancel();
          inviteTimeoutTimer.remove(session.pid);
          log('New outgoing channel to ${session.pid}', name: 'WebRTC $self');
          outgoingChannels[session.pid] = channel;
          if (pingTimer[session.pid] != null) {
            pingTimer[session.pid]?.cancel();
          }
          pingTimer[session.pid] =
              Timer.periodic(const Duration(seconds: 30), (_) {
            log('Ping message for ${session.pid}', name: 'WebRTC $self');
            unicast(session.pid, PingMessage());
            log('Create waiting timer for ${session.pid}',
                name: 'WebRTC $self');
            pingWaitTimer[session.pid] = Timer(const Duration(seconds: 2), () {
              //timeout - remove from peers, reelect leader
              log('Ping timeout to ${session.pid}, disconnect',
                  name: 'WebRTC $self');
              _peers.remove(session.pid);
              outgoingChannels[session.pid]?.close();
              outgoingChannels.remove(session.pid);
              incomingChannels.remove(session.pid);
              pingTimer[session.pid]?.cancel();
              pingWaitTimer.remove(session.pid);
              pingTimer.remove(session.pid);
              if (session.pid == _leader) {
                _leader = self;
                broadcast(SetLeaderMessage(id: self));
              }
            });
          });
          //check leader if needed
          if (_leader.isEmpty) {
            unicast(session.pid, RequestLeaderMessage());
            leaderRequestTimer =
                Timer(Duration(milliseconds: Random().nextInt(500) + 1000), () {
              //if no leader - take leadership
              log('Leader is force set to $self', name: 'WebRTC $self');
              _leader = self;
              broadcast(SetLeaderMessage(id: self));
            });
          } else {
            final selectLeader = SetLeaderMessage(id: _leader);
            unicast(session.pid, selectLeader);
          }
        }
        if (state == RTCDataChannelState.RTCDataChannelClosing) {
          log('Delete outgoing channel with ${session.pid}',
              name: 'WebRTC $self');
          outgoingChannels.remove(session.pid);
        }
      };
    };
    signaling.onDataChannelMessage = (session, channel, message) {
      log('New message from ${session.sid}: ${message.text}',
          name: 'WebRTC $self');
      for (final handler in _handlers) {
        handler.call(session.pid, jsonDecode(message.text));
      }
    };
    signaling.onCallStateChange = (session, state) {
      if (state == CallState.CallStateRinging) {
        //accepting everyone
        signaling.accept(session.sid, 'data');
        incomingChannels[session.sid] = session.dc;
      }
    };
    addListener((from, message) {
      switch (message['type']) {
        case 'requestLeader':
          //request leader from newly connected player
          if (_leader.isNotEmpty) {
            log('Leader is requested', name: 'WebRTC $self');
            unicast(from, SetLeaderMessage(id: _leader));
          }
        case 'setLeader':
          //define the leader (comes from the leader or other player)
          leaderRequestTimer?.cancel();
          final id = message['id'];
          if (id != self) {
            log('Leader is set to $id', name: 'WebRTC $self');
            _leader = id;
            if (!stateIsSynchronized) {
              log('Getting initial state from leader $_leader',
                  name: 'WebRTC $self');
              //send to leader initial state request
              unicast(_leader, RequestInitialStateMessage());
            }
          }
        case 'ping':
          unicast(from, PongMessage());
        case 'pong':
          pingWaitTimer[from]?.cancel();
          pingWaitTimer.remove(from);
      }
    });
    await signaling.connect();
  }
}
