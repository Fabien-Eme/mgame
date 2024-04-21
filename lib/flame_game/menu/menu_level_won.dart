import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/game_user_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/score_controller.dart';

import '../riverpod_controllers/all_trucks_controller.dart';
import '../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuLevelWon extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuLevelWon() : super(boxSize: Vector2(600, 350), isCloseButtonShown: false);

  late final TextComponent title;
  late final TextComponent text;
  late final TextComponent subText;

  late final TextComponent loading;

  @override
  void onLoad() {
    super.onLoad();

    loading = TextComponent(
      text: "Loading",
      textRenderer: MyTextStyle.bigText,
      anchor: Anchor.centerLeft,
      position: Vector2(-80, 0),
    );
    world.add(loading);

    ///
    ///
    /// TITLE
    title = TextComponent(
      text: "CONGRATULATIONS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );

    ///
    ///
    /// TEXT
    text = TextComponent(
      text: "You have completed Level ${game.currentLevel}.",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );

    subText = TextComponent(
      text: "Get ready for Level ${game.currentLevel + 1} !",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 150),
    );

    markLevelFinishedAndAddMenu();
  }

  @override
  void onMount() {
    ref.read(allTrucksControllerProvider.notifier).resetTruck();
    super.onMount();
  }

  void markLevelFinishedAndAddMenu() async {
    await markLevelFinished();
    game.currentLevel += 1;
    world.remove(loading);
    addMenu();
  }

  Future<void> markLevelFinished() async {
    List<String> listAchievementsToAdd = [];
    if (game.currentLevel == 1) {
      listAchievementsToAdd.add('cityCleaner');
      subText.text = "You received an Achievement.\nAdd it to your Google Wallet in the Main Menu";
    }
    if (game.currentLevel == 2) {
      listAchievementsToAdd.add('garbageCollector');
      subText.text = "You received an Achievement.\nAdd it to your Google Wallet in the Main Menu";
    }

    for (String achievement in listAchievementsToAdd) {
      ref.read(gameUserControllerProvider.notifier).addUserAchievements(achievement);
    }

    int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
    int previousScore = ref.read(gameUserControllerProvider.notifier).getLevelScore(game.currentLevel);
    int currentScore = ref.read(scoreControllerProvider);
    int score = max(previousScore, currentScore);

    await ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits + 5, levelToUpdate: game.currentLevel.toString(), isCompleted: true, score: score);
    await ref.read(gameUserControllerProvider.notifier).updateGameUser(levelToUpdate: (game.currentLevel + 1).toString(), isAvailable: true);
  }

  void addMenu() {
    world.add(title);
    world.add(text);
    world.add(subText);

    ///
    ///
    /// BUTTONS
    final buttonConfirm = DialogButton(
      text: 'Next Level',
      onPressed: () async {
        ref.read(scoreControllerProvider.notifier).reInitializeScore();
        ref.read(allTrucksControllerProvider.notifier).resetTruck();
        game.router.popUntilNamed('root');
        await Future.delayed(const Duration(milliseconds: 100));
        game.router.pushNamed('level${game.currentLevel}');
      },
      buttonSize: Vector2(175, 50),
      position: Vector2(boxSize.x / 5, boxSize.y / 2 - 50),
    );
    world.add(buttonConfirm);

    final buttonMenu = DialogButton(
      text: 'Main Menu',
      onPressed: () {
        game.router.popUntilNamed('root');
        game.router.pushNamed('levelBackground');
        game.router.pushNamed('mainMenu');
      },
      textStyle: MyTextStyle.buttonRed,
      buttonSize: Vector2(200, 50),
      isButtonBack: true,
      position: Vector2(-boxSize.x / 5, boxSize.y / 2 - 50),
    );

    world.add(buttonMenu);
  }

  double timeElapsed = 0.0;

  @override
  void update(double dt) {
    if (loading.isMounted) {
      timeElapsed += dt;
      if (timeElapsed >= 0.3) {
        timeElapsed = 0.0;
        if (loading.text == "Loading") {
          loading.text = "Loading.";
        } else if (loading.text == "Loading.") {
          loading.text = "Loading..";
        } else if (loading.text == "Loading..") {
          loading.text = "Loading...";
        } else if (loading.text == "Loading...") {
          loading.text = "Loading";
        }
      }
    }
    super.update(dt);
  }
}
