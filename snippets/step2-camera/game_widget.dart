import 'dart:developer';
import 'dart:math' hide log;

import 'package:deliverysim/component/game_over.dart';
import 'package:deliverysim/component/mood.dart';
import 'package:deliverysim/component/profile/2d.dart';
import 'package:deliverysim/model/player_information.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import 'theme/theme.dart';
import 'world/cellitems/cell.dart';
import 'world/world.dart';

final pickupPoints = [];

class DeliveryGame extends FlameGame<DeliveryWorld>
    with TapDetector, ScrollDetector, HasKeyboardHandlerComponents {
  final Vector2 viewportResolution;
  late final RouterComponent router;

  // @override
  // bool debugMode = true;

  DeliveryGame({
    required this.viewportResolution,
    required super.world,
  }) : super(
    camera: CameraComponent.withFixedResolution(
      viewfinder: Viewfinder(key: ComponentKey.named('viewFinder')),
      width: viewportResolution.x,
      height: viewportResolution.y,
    ),
  );

    world.placeOwnPlayer(world.currentPlayerId);
    camera.follow(
      world.updatePlayer(world.currentPlayer!, updatePosition: true)!,
      snap: true,
    );
  }

  @override
  Future<void> onLoad() async {
    world.backgroundMusic = await FlameAudio.loopLongAudio('greensleeves.mp3');
    camera.setBounds(
      Rectangle.fromRect(
        Vector2(
          -world.mapWidth / 2 * GameTheme.spriteSize * world.scaleFactor,
          -world.mapHeight * GameTheme.spriteSize * world.scaleFactor,
        ) &
        Vector2(
          world.mapWidth.toDouble() *
              GameTheme.spriteSize *
              world.scaleFactor,
          world.mapHeight.toDouble() *
              GameTheme.spriteSize *
              world.scaleFactor *
              viewportResolution.y /
              viewportResolution.x,
        ),
      ),
    );
  }
}
