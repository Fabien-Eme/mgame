import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/dialog_button.dart';

import '../utils/my_text_style.dart';

import 'menu_without_tabs.dart';

class MenuGameWon extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuGameWon() : super(boxSize: Vector2(600, 350), isCloseButtonShown: false);

  late final TextComponent title;
  late final TextComponent text;
  late final DialogButton buttonMenu;

  @override
  void onLoad() {
    super.onLoad();

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
      text: "You've won the game!\nWell, this demo only!\nMore levels and features to come soon.\nIn the meantime, you can organize events in real life.\nThanks for playing!",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );

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
      position: Vector2(0, boxSize.y / 2 - 50),
    );

    world.add(title);
    world.add(text);
    world.add(buttonMenu);
  }
}
