import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/ui/garbage_bar.dart';
import 'package:mgame/flame_game/ui/mini_top_drawer.dart';
import 'package:mgame/flame_game/ui/money.dart';
import 'package:mgame/flame_game/ui/pollution_bar.dart';
import 'package:mgame/flame_game/ui/top_drawer.dart';
import 'package:mgame/flame_game/ui/ui_rotate_building.dart';
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
  late final UIRotateBuilding uiRotateBuilding;
  late final SettingsButton settingsButton;

  late final PollutionBar pollutionBar;
  late final GarbageBar garbageBar;

  late final Money money;

  bool isPurpleTruckAvailable = false;
  bool isBlueTruckAvailable = false;

  @override
  void onLoad() {
    super.onLoad();

    Map<String, Map<String, dynamic>> mapLevel = getMapLevel(game.globalAirQualityValue);

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
    if (level != 0) {
      cameraComponent.viewport.addAll([
        uiBottomBar = UIBottomBar(),
        uiRotate = UIRotate(),
        uiRotateBuilding = UIRotateBuilding(),
        settingsButton = SettingsButton(position: Vector2(MGame.gameWidth - 20, 15)),
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
        MiniTopDrawer(),
        TopDrawer(),
        pollutionBar = PollutionBar(
            title: 'POLLUTION',
            totalBarValue: mapLevel[level.toString()]!["pollutionLimit"]! as double,
            onComplete: () {
              if (level != 0) game.router.pushNamed('levelLost');
            }),
        money = Money(
          startingAmount: mapLevel[level.toString()]!["startingMoney"]! as double,
        ),
        garbageBar = GarbageBar(
          title: 'GARBAGE PROCESSED',
          totalBarValue: mapLevel[level.toString()]!["garbageTarget"]! as double,
          onComplete: () {
            if (game.lastLevelCompleted == 2) {
              game.router.pushNamed('gameWon');
            } else if (level != 0) {
              game.router.pushNamed('levelWon');
            }
          },
        ),
      ]);
    } else {
      cameraComponent.viewport.addAll([
        pollutionBar = PollutionBar(
          title: 'POLLUTION',
          totalBarValue: mapLevel[level.toString()]!["pollutionLimit"]! as double,
          onComplete: () {},
          isHidden: true,
        ),
        money = Money(
          startingAmount: mapLevel[level.toString()]!["startingMoney"]! as double,
          isHidden: true,
        ),
        garbageBar = GarbageBar(
          title: 'GARBAGE PROCESSED',
          totalBarValue: mapLevel[level.toString()]!["garbageTarget"]! as double,
          onComplete: () {},
          isHidden: true,
        ),
      ]);
    }

    ///
    ///
    /// If level 0 it's for menu background
    /// If level 1 it's tutorial
    if (level == 1) {
      game.router.pushNamed('tutorial');
    } else if (level != 0) {
      game.router.pushNamed('briefing');
    }
  }

  static int totalNumberOfLevel = 8;

  // static Map<String, Map<String, dynamic>> getMapLevel([double globalAirQualityValue = 0]) {
  //   return {
  //     "0": {
  //       "levelTitle": "Level 0 - Init",
  //       "pollutionLimit": 0.0,
  //       "garbageTarget": 0.0,
  //       "startingMoney": 1000000.0,
  //     },
  //     "1": {
  //       "levelTitle": "Level 1 - Tutorial",
  //       "pollutionLimit": 10000.0 - (1 - globalAirQualityValue / 100) * 2000,
  //       "garbageTarget": 0.0,
  //       "startingMoney": 65000.0,
  //     },
  //     // Testing Level
  //     "2": {
  //       "levelTitle": "Level 2 - Two cities",
  //       "pollutionLimit": 200000.0 - (1 - globalAirQualityValue / 100) * 5000,
  //       "garbageTarget": 2000.0,
  //       "startingMoney": 650000.0,
  //     },
  //     "3": {
  //       "levelTitle": "Level 3 - Mission: Impossible",
  //       "pollutionLimit": 45000.0 - (1 - globalAirQualityValue / 100) * 5000,
  //       "garbageTarget": 400.0,
  //       "startingMoney": 75000.0,
  //     },
  //   };
  // }
  static Map<String, Map<String, dynamic>> getMapLevel([double globalAirQualityValue = 0]) {
    return {
      "0": {
        "levelTitle": "Level 0 - Init",
        "pollutionLimit": 0.0,
        "garbageTarget": 0.0,
        "startingMoney": 1000000.0,
      },
      "1": {
        "levelTitle": "Level 1 - Tutorial",
        "pollutionLimit": 12000.0 - (1 - globalAirQualityValue / 100) * 2000,
        "garbageTarget": 30.0,
        "startingMoney": 65000.0,
      },
      "2": {
        "levelTitle": "Level 2 - Two cities",
        "pollutionLimit": 25000.0 - (1 - globalAirQualityValue / 100) * 5000,
        "garbageTarget": 200.0,
        "startingMoney": 65000.0,
      },
      "3": {
        "levelTitle": "Level 3 - Mission: Impossible",
        "pollutionLimit": 45000.0 - (1 - globalAirQualityValue / 100) * 5000,
        "garbageTarget": 400.0,
        "startingMoney": 75000.0,
      },
    };
  }
}
