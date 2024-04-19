import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/game_user_controller.dart';

import '../level.dart';
import '../utils/my_text_style.dart';

import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuIncinerator extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuIncinerator() : super(boxSize: Vector2(700, 450));

  late final DialogButton upgradeComposters;
  late final DialogButton upgradePlantTrees;
  late final DialogButton upgradeStopPollutionGeneration;

  bool isFetchingData = false;

  @override
  void onLoad() {
    super.onLoad();

    ///
    ///
    /// TITLE
    world.add(TextComponent(
      text: "INCINERATOR",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: 'This factory burns garbage. It generates pollution.\nGarbage is processed this way and you earn money.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    ///
    ///
    /// UPGRADES
    world.add(TextComponent(
      text: 'Install pollution filter   5K\$\nReduce pollution generated by 25%',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 180),
    ));
    world.add(upgradeComposters = DialogButton(
      text: 'Buy upgrade',
      onPressed: () {
        if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(5000)) {
          (game.findByKeyName('level') as Level).money.addValue(-5000);
          game.currentIncinerator!.pollutionReduction = game.currentIncinerator!.pollutionReduction * 0.75;
          if (upgradeComposters.isMounted) {
            world.remove(upgradeComposters);
            world.add(TextComponent(
              text: 'Upgrade Bought',
              textRenderer: MyTextStyle.text,
              anchor: Anchor.center,
              position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
            ));
          }
        }
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
    ));

    ///

    world.add(TextComponent(
      text: 'Generate BioMass   8K\$\nIncrease money earned by 25%',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 280),
    ));

    world.add(upgradePlantTrees = DialogButton(
      text: 'Buy upgrade',
      onPressed: () {
        if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(8000)) {
          (game.findByKeyName('level') as Level).money.addValue(-8000);
          game.currentIncinerator!.moneyBonus = game.currentIncinerator!.moneyBonus * 1.25;

          if (upgradePlantTrees.isMounted) {
            world.remove(upgradePlantTrees);
            world.add(TextComponent(
              text: 'Upgrade Bought',
              textRenderer: MyTextStyle.text,
              anchor: Anchor.center,
              position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
            ));
          }
        }
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
    ));

    ///

    world.add(TextComponent(
      text: "Convert into a recycler   5 EcoCredits\nNo more pollution generated by processing garbage",
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 380),
    ));

    world.add(upgradeStopPollutionGeneration = DialogButton(
      text: 'Buy upgrade',
      onPressed: () async {
        if (!isFetchingData) {
          isFetchingData = true;
          String upgradeText = "";

          int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
          if (ecoCredits >= 5) {
            upgradeText = 'Upgrade Bought';
            ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits - 5);
            game.currentIncinerator!.upgradeToRecycler();
          } else {
            upgradeText = 'Insufficient EcoCredits';
          }
          if (upgradeStopPollutionGeneration.isMounted) {
            world.remove(upgradeStopPollutionGeneration);
          }
          world.add(TextComponent(
            text: upgradeText,
            textRenderer: MyTextStyle.text,
            anchor: Anchor.center,
            position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 380),
          ));
          isFetchingData = false;
        }
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 380),
    ));
  }
}
