import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mgame/flame_game/menu/menu_without_tabs.dart';

import 'dialog_button.dart';
import 'slider_component.dart';
import '../utils/my_text_style.dart';

class MenuAchievement extends MenuWithoutTabs {
  MenuAchievement() : super(boxSize: Vector2(600, 500));

  late SliderComponent musicSlider;
  late SliderComponent soundSlider;

  SliderComponent? sliderCurrentlyDragged;

  @override
  void onLoad() {
    super.onLoad();

    ///
    ///
    /// TITLE
    final title = TextComponent(
      text: "ACHIEVEMENTS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    world.add(title);

    ///
    ///
    /// BUTTONS
    final buttonConfirm = DialogButton(
      text: 'Confirm',
      onPressed: () {
        FlameAudio.bgm.audioPlayer.setVolume(game.musicVolume);
        game.router.pop();
      },
      buttonSize: Vector2(150, 50),
      position: Vector2((game.router.previousRoute?.name == "mainMenu") ? 0 : boxSize.x / 5, boxSize.y / 2 - 50),
    );
    world.add(buttonConfirm);

    if (game.router.previousRoute?.name != "mainMenu") {
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
}
