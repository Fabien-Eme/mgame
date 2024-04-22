import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../buildings/garage/garage.dart';
import '../../game.dart';
import '../../level.dart';

import '../../riverpod_controllers/game_user_controller.dart';
import '../dialog_button.dart';
import '../../utils/my_text_style.dart';

class UpgradeTrucksContent extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final Vector2 boxSize;
  UpgradeTrucksContent({required this.boxSize});

  late final DialogButton upgradeNaturalGasTruck;
  late final DialogButton upgradeElectricTruck;

  bool isFetchingData = false;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    Garage thisGarage = game.currentlySelectedBuilding as Garage;

    add(TextComponent(
      text: "UPGRADE TRUCKS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    add(TextComponent(
      text: 'Natural Gas truck   2 EcoCredits\nAbility to purchase Natural Gas truck ',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 50, -boxSize.y / 2 + 180),
    ));

    if (thisGarage.gasTruckUpgrade) {
      add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
      ));
    } else {
      add(upgradeNaturalGasTruck = DialogButton(
        text: 'Buy upgrade',
        onPressed: () async {
          if (!isFetchingData) {
            isFetchingData = true;
            upgradeNaturalGasTruck.textComponent.text = "Loading";

            String upgradeText = "";

            int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
            if (ecoCredits >= 2) {
              upgradeText = 'Upgrade Bought';
              ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits - 2);

              (game.findByKeyName('level') as Level).isPurpleTruckAvailable = true;
              thisGarage.gasTruckUpgrade = true;
            } else {
              upgradeText = 'Insufficient EcoCredits';
            }
            if (upgradeNaturalGasTruck.isMounted) {
              remove(upgradeNaturalGasTruck);
            }
            add(TextComponent(
              text: upgradeText,
              textRenderer: MyTextStyle.text,
              anchor: Anchor.center,
              position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
            ));
            isFetchingData = false;
          }
        },
        buttonSize: Vector2(200, 50),
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
      ));
    }

    add(TextComponent(
      text: 'Electric truck   5 EcoCredits\nAbility to purchase Electric truck ',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 50, -boxSize.y / 2 + 280),
    ));

    if (thisGarage.electricTruckUpgrade) {
      add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
      ));
    } else {
      add(upgradeElectricTruck = DialogButton(
        text: 'Buy upgrade',
        onPressed: () async {
          if (!isFetchingData) {
            isFetchingData = true;
            String upgradeText = "";

            int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
            if (ecoCredits >= 5) {
              upgradeText = 'Upgrade Bought';
              ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits - 5);
              (game.findByKeyName('level') as Level).isBlueTruckAvailable = true;
              thisGarage.electricTruckUpgrade = true;
            } else {
              upgradeText = 'Insufficient EcoCredits';
            }
            if (upgradeElectricTruck.isMounted) {
              remove(upgradeElectricTruck);
            }
            add(TextComponent(
              text: upgradeText,
              textRenderer: MyTextStyle.text,
              anchor: Anchor.center,
              position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
            ));
            isFetchingData = false;
          }
        },
        buttonSize: Vector2(200, 50),
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
      ));
    }
  }
}
