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
      text: getComponentTitle(),
      textRenderer: MyTextStyle.briefingTitle,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );

    ///
    ///
    /// TEXT
    text = TextBoxComponent(
      text: getComponentText(),
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

  String getComponentTitle() {
    switch (game.currentLevel) {
      case 2:
        return "Two cites : the good, the bad, ...";
      case 3:
        return "Public Composters";
      case 4:
        return "Toxic waste?";
      case 5:
        return "3 Towns, 3 Processes";
      case 6:
        return "Everybody composts";
      case 7:
        return "Free play?";
      default:
        return "";
    }
  }

  String getComponentText() {
    switch (game.currentLevel) {
      case 2:
        return "This time, you'll have to manage the waste from two cities simultaneously.\n\nThe inhabitants of one of these two towns are careful and try to sort their waste as much as possible, thus creating a lot of recyclable items.\n\nResidents of the other city consume as they please. The consequences are dramatic : a lot of waste is generated, therefore a lot of pollution to deal with, and few recycling items.\n\nFill up your processed waste gauge without exceeding the pollution limit!";
      case 3:
        return "The citizens of all towns are sorting their organic wastes as there are public composters where you can bring the organic wastes. They have a maximum capacity, but do not worry they slowly empty themselves, sweet ! However if you delete a composter you do not get any money back…\n\nOh and try not to let the number of unsorted waste of a city go over 60 or you will face extra pollution and lose a star in the process…";
      case 4:
        return "What?! A city is producing toxic waste here? You have no other option but to bury all that. It is a shame though, you will not earn any money from that…\n\nBut be careful, once you have built a buryer, there is no point deleting it, you will not get a refund!";
      case 5:
        return "Well it seems that here, every town has a different way of dealing with their waste.\n\nGood luck processing all of that!";
      case 6:
        return "Managing composters is a fine skill. Build just the right amount of composters so that when one is filled up, another one is ready, otherwise you will be overwhelmed quickly!";
      case 7:
        return "High pollution limit, hig starting money, but a huge amount of garbage to process!\n\nGood luck!";
      default:
        return "";
    }
  }

  Vector2 getBoxSize(int level) {
    switch (level) {
      case 2:
        return Vector2(800, 450);
      case 3:
        return Vector2(800, 375);
      case 4:
        return Vector2(800, 325);
      case 5:
        return Vector2(800, 300);
      case 6:
        return Vector2(800, 275);
      default:
        return Vector2(800, 250);
    }
  }
}
