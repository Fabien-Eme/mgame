import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/controller/waste_controller.dart';

import '../level.dart';
import '../riverpod_controllers/game_user_controller.dart';
import '../ui/pollution_bar.dart';
import '../utils/my_text_style.dart';

import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuCity extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuCity() : super(boxSize: Vector2(900, 450));

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
      text: game.currentCity!.cityType.cityTitle,
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: '${game.currentCity!.cityType.cityText}\nIf the waste stack goes over 60, the city will start generating pollution.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    ///
    ///
    /// UPGRADES
    world.add(TextComponent(
      text: 'Install composters   3K\$\nReduce the rate of waste production by 25%',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 180),
    ));
    world.add(upgradeComposters = DialogButton(
      text: 'Buy upgrade',
      onPressed: () {
        if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(3000)) {
          (game.findByKeyName('level') as Level).money.addValue(-3000);
          game.currentCity!.reductionRate = game.currentCity!.reductionRate * 0.75;

          WasteController wasteController = (game.findByKeyName('level') as Level).levelWorld.wasteController;
          for (String wasteStackId in game.currentCity!.listWasteStackId) {
            wasteController.updateWasteStackWasteRate(
                wasteStackId: wasteStackId, wasteRate: game.currentCity!.reductionRate * game.currentCity!.cityType.wasteRate(wasteController.getWasteStackType(wasteStackId)));
          }
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
      text: 'Plant trees in the city   5K\$\nReduce the total pollution by 1K',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 280),
    ));

    world.add(upgradePlantTrees = DialogButton(
      text: 'Buy upgrade',
      onPressed: () {
        if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(5000)) {
          (game.findByKeyName('level') as Level).money.addValue(-5000);
          (game.findByKeyName('pollutionBar') as PollutionBar).addValue(-1000);

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
      text: "Organize events to clean waste in the city   5 EcoCredits\nThe waste stack won't generate additionnal pollution",
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
            WasteController wasteController = (game.findByKeyName('level') as Level).levelWorld.wasteController;
            for (String wasteStackId in game.currentCity!.listWasteStackId) {
              wasteController.stopPollutionGeneration(wasteStackId: wasteStackId);
            }
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
