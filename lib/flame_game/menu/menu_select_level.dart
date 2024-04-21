import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/dialog_level_button.dart';
import 'package:mgame/flame_game/menu/menu_without_tabs.dart';
import 'package:mgame/flame_game/riverpod_controllers/game_user_controller.dart';

import '../level.dart';
import '../riverpod_controllers/all_trucks_controller.dart';
import '../riverpod_controllers/score_controller.dart';
import '../utils/my_text_style.dart';

class MenuSelectLevel extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuSelectLevel() : super(boxSize: Vector2(1100, 750));

  @override
  void onLoad() {
    super.onLoad();

    ///
    ///
    /// TITLE
    final title = TextComponent(
      text: "SELECT LEVEL",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    world.add(title);
  }

  @override
  void onMount() {
    Map<String, dynamic> userMapLevel = ref.read(gameUserControllerProvider.notifier).getUserMapLevel();

    ///
    ///
    /// BUTTONS

    Map<String, Map<String, dynamic>> mapLevel = Level.getMapLevel();

    for (String buttonLevel in mapLevel.keys) {
      if (buttonLevel == "0") continue;
      String title = mapLevel[buttonLevel]?['levelTitle'] as String? ?? "";
      title = title.split(' - ')[1];

      world.add(
        DialogLevelButton(
          title: title,
          isCompleted: userMapLevel[buttonLevel]?['isCompleted'] as bool? ?? false,
          isAvailable: userMapLevel[buttonLevel]?['isAvailable'] as bool? ?? false,
          score: userMapLevel[buttonLevel]?['score'] as int? ?? -1,
          level: buttonLevel,
          onPressed: () {
            ref.read(allTrucksControllerProvider.notifier).resetTruck();
            ref.read(scoreControllerProvider.notifier).reInitializeScore();
            game.currentLevel = int.parse(buttonLevel);
            game.router.popUntilNamed('root');
            game.router.pushNamed('level$buttonLevel');
          },
          position: Vector2(-boxSize.x / 2 + 150 + ((int.parse(buttonLevel) - 1) % 5 * 200), -boxSize.y / 2 + 200 + (((int.parse(buttonLevel) - 1) / 5).floor() * 200)),
        ),
      );
    }

    super.onMount();
  }
}
