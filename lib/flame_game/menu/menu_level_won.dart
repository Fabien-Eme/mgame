import 'package:flame/components.dart';

import '../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuLevelWon extends MenuWithoutTabs {
  MenuLevelWon() : super(boxSize: Vector2(600, 350), isCloseButtonShown: false);

  @override
  void onLoad() {
    super.onLoad();

    ///
    ///
    /// TITLE
    final title = TextComponent(
      text: "CONGRATULATIONS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    world.add(title);

    ///
    ///
    /// TEXT
    final text = TextComponent(
      text: "You have completed Level 1.",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );
    world.add(text);

    final subText = TextComponent(
      text: "Get ready for Level 2 !",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 200),
    );
    world.add(subText);

    ///
    ///
    /// BUTTONS
    final buttonConfirm = DialogButton(
      text: 'Next Level',
      onPressed: () {
        game.router.pop();
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
}
