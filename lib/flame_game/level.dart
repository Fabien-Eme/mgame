import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/dialog/tutorial.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/ui/garbage_bar.dart';
import 'package:mgame/flame_game/ui/money.dart';
import 'package:mgame/flame_game/ui/pollution_bar.dart';
import 'package:mgame/flame_game/ui/top_drawer.dart';

import 'dialog/dialog_bdd.dart';
import 'dialog/dialog_window.dart';
import 'game.dart';
import 'ui/settings_button.dart';
import 'ui/ui_bottom_bar.dart';
import 'ui/ui_rotate.dart';

class Level extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  int level;
  Level({required this.level, required super.key});

  final LevelWorld levelWorld = LevelWorld();
  late final CameraComponent cameraComponent;

  late final UIBottomBar uiBottomBar;
  late final UIRotate uiRotate;
  late final SettingsButton settingsButton;

  late final PollutionBar pollutionBar;
  late final GarbageBar garbageBar;

  late final Money money;

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

    ///
    ///
    /// ADD BOTTOM UI
    cameraComponent.viewport.addAll([
      uiBottomBar = UIBottomBar(),
      uiRotate = UIRotate(),
      settingsButton = SettingsButton(),
    ]);

    ///
    ///
    /// ADD TOP UI
    cameraComponent.viewport.addAll([
      TopDrawer(),
      pollutionBar = PollutionBar(
        title: 'POLLUTION',
        totalBarValue: 30000,
      ),
      money = Money(startingAmount: 65000),
      garbageBar = GarbageBar(
        title: 'GARBAGE PROCESSED',
        totalBarValue: 10,
        onComplete: () => game.router.pushNamed('levelWon'),
      ),
    ]);

    game.router.pushNamed('tutorial');

    return super.onLoad();
  }
}
