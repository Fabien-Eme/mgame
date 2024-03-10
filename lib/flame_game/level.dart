import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/ui/garbage_bar.dart';
import 'package:mgame/flame_game/ui/money.dart';
import 'package:mgame/flame_game/ui/pollution_bar.dart';
import 'package:mgame/flame_game/ui/top_drawer.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import 'game.dart';
import 'ui/settings_button.dart';
import 'ui/ui_bottom_bar.dart';
import 'ui/ui_rotate.dart';

class Level extends PositionComponent with HasGameReference<MGame> {
  final int level;
  Level({required this.level, super.key});

  late final LevelWorld levelWorld = LevelWorld(level: level);
  late final CameraComponent cameraComponent;

  late final UIBottomBar uiBottomBar;
  late final UIRotate uiRotate;
  late final SettingsButton settingsButton;

  late final PollutionBar pollutionBar;
  late final GarbageBar garbageBar;

  late final Money money;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

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
      TextComponent(
        text: mapLevel[level.toString()]!["levelTitle"]! as String,
        textRenderer: MyTextStyle.levelTitleBorder,
        anchor: Anchor.center,
        position: Vector2(1000, MGame.gameHeight - 30),
      ),
      TextComponent(
        text: mapLevel[level.toString()]!["levelTitle"]! as String,
        textRenderer: MyTextStyle.levelTitle,
        anchor: Anchor.center,
        position: Vector2(1000, MGame.gameHeight - 30),
      ),
    ]);

    ///
    ///
    /// ADD TOP UI
    cameraComponent.viewport.addAll([
      TopDrawer(),
      pollutionBar = PollutionBar(
        title: 'POLLUTION',
        totalBarValue: mapLevel[level.toString()]!["pollutionLimit"]! as double,
      ),
      money = Money(
        startingAmount: mapLevel[level.toString()]!["startingMoney"]! as double,
      ),
      garbageBar = GarbageBar(
        title: 'GARBAGE PROCESSED',
        totalBarValue: mapLevel[level.toString()]!["garbageTarget"]! as double,
        onComplete: () => game.router.pushNamed('levelWon'),
      ),
    ]);

    ///
    ///
    /// If level 1 it's tutorial
    if (level == 1) {
      game.router.pushNamed('tutorial');
    }
  }
}

Map<String, Map<String, dynamic>> mapLevel = {
  "1": {
    "levelTitle": "Level 1 - Tutorial",
    "pollutionLimit": 10000.0,
    "garbageTarget": 50.0,
    "startingMoney": 65000.0,
  },
  "2": {
    "levelTitle": "Level 2 - Two cities",
    "pollutionLimit": 30000.0,
    "garbageTarget": 600.0,
    "startingMoney": 65000.0,
  },
};
