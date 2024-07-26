import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../../lib/game_widget.dart';
import '../../lib/world/world.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final view = PlatformDispatcher.instance.implicitView;
  final size = view!.display.size / view.display.devicePixelRatio;

  final world = DeliveryWorld();
  AppLifecycleListener(onHide: () {
    world.backgroundMusic?.stop();
  }, onShow: () {
    world.backgroundMusic?.resume();
  }, onRestart: () {
    world.backgroundMusic?.resume();
  }, onExitRequested: () async {
    world.backgroundMusic?.stop();
    return AppExitResponse.exit;
  });
  runApp(
    GameWidget(
      game: DeliveryGame(
        world: DeliveryWorld(),
        viewportResolution: Vector2(
          size.width,
          size.height,
        ),
      ),
    ),
  );
}
