import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';

import '../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuLevelLost extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuLevelLost() : super(boxSize: Vector2(600, 350), isCloseButtonShown: false);

  late final TextComponent title;
  late final TextComponent text;
  late final TextComponent subText;

  @override
  void onLoad() {
    super.onLoad();

    ///
    ///
    /// TITLE
    title = TextComponent(
      text: "DEFEAT",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );

    ///
    ///
    /// TEXT
    text = TextComponent(
      text: "You have failed Level ${game.currentLevel}.",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );

    subText = TextComponent(
      text: "Try again !",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 150),
    );

    world.add(title);
    world.add(text);
    world.add(subText);

    ///
    ///
    /// BUTTONS
    final buttonConfirm = DialogButton(
      text: 'Try again',
      onPressed: () async {
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

  @override
  void onMount() {
    ref.read(allTrucksControllerProvider.notifier).resetTruck();
    super.onMount();
  }
}
