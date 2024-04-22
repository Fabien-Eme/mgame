import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/controller/waste_controller.dart';

import '../buildings/city/city.dart';
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

    City thisCity = game.currentlySelectedBuilding as City;

    ///
    ///
    /// TITLE
    world.add(TextComponent(
      text: thisCity.cityType.cityTitle,
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: '${thisCity.cityType.cityText}\nIf a waste stack goes over 60, the city will start generating pollution.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    ///
    ///
    /// UPGRADES
    world.add(TextComponent(
      text: 'Give advice about eco-consumption   3K\$\nReduce the rate of waste production by 25%',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 180),
    ));

    if (thisCity.reductionRateUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
      ));
    } else {
      world.add(upgradeComposters = DialogButton(
        text: 'Buy upgrade',
        onPressed: () {
          if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(3000)) {
            (game.findByKeyName('level') as Level).money.addValue(-3000);
            thisCity.upgradeReductionRate();

            WasteController wasteController = (game.findByKeyName('level') as Level).levelWorld.wasteController;
            for (String wasteStackId in thisCity.listWasteStackId) {
              wasteController.updateWasteStackWasteRate(wasteStackId: wasteStackId, wasteRate: thisCity.reductionRate * thisCity.cityType.wasteRate(wasteController.getWasteStackType(wasteStackId)));
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
    }

    ///

    world.add(TextComponent(
      text: 'Plant trees in the city   5K\$\nReduce the current pollution by 1K',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 280),
    ));

    if (thisCity.reductionPollutionUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
      ));
    } else {
      world.add(upgradePlantTrees = DialogButton(
        text: 'Buy upgrade',
        onPressed: () {
          if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(5000)) {
            (game.findByKeyName('level') as Level).money.addValue(-5000);
            (game.findByKeyName('pollutionBar') as PollutionBar).addValue(-1000);
            thisCity.reductionPollutionUpgrade = true;

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
    }

    ///

    world.add(TextComponent(
      text: "Organize events to clean waste in the city   5 EcoCredits\nThe waste stack won't generate additionnal pollution",
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 380),
    ));

    if (thisCity.stopPollutionGenerationUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 380),
      ));
    } else {
      world.add(upgradeStopPollutionGeneration = DialogButton(
        text: 'Buy upgrade',
        onPressed: () async {
          if (!isFetchingData) {
            isFetchingData = true;
            upgradeStopPollutionGeneration.textComponent.text = "Loading";
            String upgradeText = "";

            int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
            if (ecoCredits >= 5) {
              upgradeText = 'Upgrade Bought';
              ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits - 5);
              WasteController wasteController = (game.findByKeyName('level') as Level).levelWorld.wasteController;
              for (String wasteStackId in thisCity.listWasteStackId) {
                wasteController.stopPollutionGeneration(wasteStackId: wasteStackId);
              }
              thisCity.stopPollutionGenerationUpgrade = true;
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
}
