import 'package:flame/components.dart';

import '../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class Briefing extends MenuWithoutTabs {
  Briefing() : super(boxSize: Vector2(800, 500), isCloseButtonShown: false);

  late final TextComponent title;
  late final TextComponent text;

  @override
  void onLoad() {
    super.boxSize = getBoxSize(game.currentLevel);
    super.onLoad();

    ///
    ///
    /// TITLE
    title = TextComponent(
      text: "Two cites : The good, The bad, ...",
      textRenderer: MyTextStyle.briefingTitle,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );

    ///
    ///
    /// TEXT
    text = TextBoxComponent(
      text:
          "This time, you'll have to manage the waste from two cities simultaneously.\n\nThe inhabitants of one of these two towns are careful about their waste and try to reduce it by prioritizing second-hand items, limiting the purchase of plastic items, avoiding non-recyclable packaging, etc.\n\nResidents of the other city consume as they please. The consequences are obvious and dramatic: a lot of waste is generated, and therefore a lot of pollution to deal with!\n\nFill up your processed waste gauge without exceeding the pollution limit!",
      textRenderer: MyTextStyle.briefingText,
      anchor: Anchor.topLeft,
      size: Vector2(boxSize.x - 20, boxSize.y - 120),
      position: Vector2(-boxSize.x / 2 + 10, -boxSize.y / 2 + 70),
    );

    ///
    ///
    /// BUTTON
    final buttonConfirm = DialogButton(
      text: 'START',
      onPressed: () {
        game.router.pop();
      },
      buttonSize: Vector2(150, 50),
      position: Vector2(0, boxSize.y / 2 - 50),
    );

    getComponentText();

    world.add(title);
    world.add(text);
    world.add(buttonConfirm);
  }

  void getComponentText() {
    switch (game.currentLevel) {}
  }

  Vector2 getBoxSize(int level) {
    switch (level) {
      case 2:
        return Vector2(800, 475);
      default:
        return Vector2(800, 500);
    }
  }
}
