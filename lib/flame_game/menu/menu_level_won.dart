import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../riverpod_controllers/user_controller.dart';
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

    await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).update({
      "lastLevelCompleted": game.currentLevel,
      "achievements": FieldValue.arrayUnion(listAchievementsToAdd),
      "EcoCredits": FieldValue.increment(5),
    });

    for (String achievement in listAchievementsToAdd) {
      await FirebaseFirestore.instance.collection('achievements').doc(achievement).update({
        "citizen": FieldValue.increment(1),
      });
    }
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
      onPressed: () {
        game.router.popUntilNamed('mainMenu');
        game.router.pushReplacementNamed('level${game.currentLevel}');
      },
      buttonSize: Vector2(175, 50),
      position: Vector2(boxSize.x / 5, boxSize.y / 2 - 50),
    );
    world.add(buttonConfirm);

    final buttonMenu = DialogButton(
      text: 'Main Menu',
      onPressed: () {
        game.router.popUntilNamed('mainMenu');
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
