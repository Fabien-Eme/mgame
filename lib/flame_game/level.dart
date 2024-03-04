import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';

import 'game.dart';
import 'ui/settings_button.dart';
import 'ui/ui_bottom_bar.dart';
import 'ui/ui_rotate.dart';

class Level extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  int level;
  Level(this.level);

  final LevelWorld levelWorld = LevelWorld();
  late final CameraComponent cameraComponent;

  late final UIBottomBar uiBottomBar;
  late final UIRotate uiRotate;
  late final SettingsButton settingsButton;

  @override
  FutureOr<void> onLoad() {
    add(
      cameraComponent = CameraComponent.withFixedResolution(
        width: MGame.gameWidth,
        height: MGame.gameHeight,
        viewfinder: Viewfinder()..anchor = Anchor.topLeft,
        world: levelWorld,
      ),
    );

    add(levelWorld);

    cameraComponent.viewport.addAll([
      uiBottomBar = UIBottomBar(),
      uiRotate = UIRotate(),
      settingsButton = SettingsButton(),
    ]);

    return super.onLoad();
  }
}
