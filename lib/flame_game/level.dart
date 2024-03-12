import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/ui/garbage_bar.dart';
import 'package:mgame/flame_game/ui/money.dart';
import 'package:mgame/flame_game/ui/pollution_bar.dart';
import 'package:mgame/flame_game/ui/top_drawer.dart';
import 'package:mgame/flame_game/ui/ui_rotate_building.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import 'game.dart';
import 'ui/settings_button.dart';
import 'ui/ui_bottom_bar.dart';
import 'ui/ui_rotate.dart';

class Level extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
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
  FutureOr<void> onLoad() async {
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
    cameraComponent.viewport.addAll([
      uiBottomBar = UIBottomBar(),
      uiRotate = UIRotate(),
      uiRotateBuilding = UIRotateBuilding(),
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
        onComplete: () => game.router.pushNamed('levelLost'),
      ),
      money = Money(
        startingAmount: mapLevel[level.toString()]!["startingMoney"]! as double,
      ),
      garbageBar = GarbageBar(
        title: 'GARBAGE PROCESSED',
        totalBarValue: mapLevel[level.toString()]!["garbageTarget"]! as double,
        onComplete: () {
          if (game.lastLevelCompleted == 2) {
            game.router.pushNamed('gameWon');
          } else {
            game.router.pushNamed('levelWon');
          }
        },
      ),
    ]);

    ///
    ///
    /// If level 1 it's tutorial
    if (level == 1) {
      game.router.pushNamed('tutorial');
    } else {
      game.router.pushNamed('briefing');
    }
  }

  @override
  void onMount() {
    ref.read(allTrucksControllerProvider.notifier).resetTruck();
    super.onMount();
  }

  Map<String, Map<String, dynamic>> getMapLevel(double globalAirQualityValue) {
    return {
      "1": {
        "levelTitle": "Level 1 - Tutorial",
        "pollutionLimit": 10000.0 - (1 - globalAirQualityValue / 100) * 2000,
        "garbageTarget": 50.0,
        "startingMoney": 65000.0,
      },
      "2": {
        "levelTitle": "Level 2 - Two cities",
        "pollutionLimit": 20000.0 - (1 - globalAirQualityValue / 100) * 5000,
        "garbageTarget": 200.0,
        "startingMoney": 65000.0,
      },
      "3": {
        "levelTitle": "Level 3 - Mission: Impossible",
        "pollutionLimit": 45000.0 - (1 - globalAirQualityValue / 100) * 5000,
        "garbageTarget": 1.0,
        // "garbageTarget": 400.0,
        "startingMoney": 75000.0,
      },
    };
  }
}
