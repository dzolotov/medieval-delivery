import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:async' as async;

import '../component/decorated_window.dart';
import '../game_widget.dart';
import '../model/action_description.dart';

void showFoodWindow(DeliveryGame game) async {
  game.world.currentPlayer?.isModal = true;

  final spritesheet = SpriteSheet(
    image: await game.images.load('borders.png'),
    srcSize: Vector2(64, 64),
  );
  late DecoratedWindow dw;
  dw = DecoratedWindow(
    widthFactor: 0.8,
    heightFactor: 0.6,
    borderNo: 0,
    spriteSheet: spritesheet,
    lines: [
      'Welcome to our tavern, wandrere!',
      'Would you like to eat and rest?'
    ],
    actions: [
      ActionDescription(
        action: 'Yes, of course',
        onTap: () async {
          dw.removeFromParent();
          await game.world.backgroundMusic?.stop();
          game.world.backgroundMusic =
              await FlameAudio.playLongAudio('intavern.mp3');
          game.world.currentPlayer!.isResting = true;
          double cost = 16.0;
          DecoratedWindow? dwInside;
          async.Timer? timer;

          Future<void> stopResting() async {
            timer?.cancel();
            FlameAudio.play('coins.mp3');
            dwInside?.removeFromParent();
            game.world.currentPlayer!.money -= cost.toInt();
            game.world.currentPlayer!.isResting = false;
            await game.world.backgroundMusic?.stop();
            game.world.currentPlayer?.isModal = false;

            game.world.backgroundMusic =
                await FlameAudio.loopLongAudio('greensleeves.mp3');
          }

          timer = async.Timer.periodic(
            const Duration(seconds: 1),
            (a) {
              cost += 2.0;
              if (cost >= game.world.currentPlayer!.money) {
                stopResting();
                game.world.currentPlayer!.money = 0;
              }
              game.world.currentPlayer!.mood += 0.8;
              if (dwInside != null) {
                dwInside?.removeFromParent();
              }
              dwInside = DecoratedWindow(
                widthFactor: 0.8,
                heightFactor: 0.6,
                borderNo: 1,
                spriteSheet: spritesheet,
                lines: ['Total cost: ${cost.toStringAsFixed(0)}'],
                actions: [
                  ActionDescription(
                    action: 'Stop resting',
                    onTap: stopResting,
                  )
                ],
              )
                ..position = Vector2.zero()
                ..size = game.viewportResolution;
              game.camera.viewport.add(dwInside!);
            },
          );
          //show cost
        },
      ),
      ActionDescription(
        action: 'No, next time',
        onTap: () {
          dw.removeFromParent();
          game.world.currentPlayer?.isModal = false;

        },
      )
    ],
  )
    ..position = Vector2.zero()
    ..size = game.viewportResolution;

  game.camera.viewport.add(dw);
}
