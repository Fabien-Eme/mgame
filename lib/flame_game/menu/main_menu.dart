import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/dialog/dialog_bdd.dart';
import 'package:mgame/flame_game/dialog/dialog_window.dart';
import 'package:mgame/flame_game/menu/dialog_button.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  late final DialogButton playButton;
  late final DialogButton settingsButton;
  late final DialogButton achievementsButton;

  @override
  FutureOr<void> onLoad() {
    add(world = World());

    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      viewfinder: Viewfinder(),
      world: world,
    ));

    world.addAll([
      playButton = DialogButton(
        text: 'Play',
        buttonSize: Vector2(100, 50),
        onPressed: () {
          game.router.pushNamed('level1');
        },
        position: Vector2(0, -50),
      ),
      settingsButton = DialogButton(
        text: 'Settings',
        onPressed: () {
          game.router.pushNamed('menuSettings');
        },
        buttonSize: Vector2(150, 50),
        position: Vector2(0, 50),
      ),
      achievementsButton = DialogButton(
        text: 'Achievements',
        onPressed: () {
          game.router.pushNamed('menuAchievements');
        },
        buttonSize: Vector2(225, 50),
        position: Vector2(0, 150),
      ),
    ]);

    return super.onLoad();
  }
}
