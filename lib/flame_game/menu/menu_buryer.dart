import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/addon_toggle_accept_waste.dart';

import '../buildings/buryer/buryer.dart';
import '../riverpod_controllers/game_user_controller.dart';
import '../utils/my_text_style.dart';

import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuBuryer extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuBuryer() : super(boxSize: Vector2(700, 250));

  late final DialogButton upgradeCapacity;

  bool isFetchingData = false;

  @override
  void onLoad() {
    super.onLoad();

    Buryer thisBuryer = game.currentlySelectedBuilding as Buryer;

    world.add(AddonToggleAcceptWaste(position: Vector2(0, boxSize.y / 2)));

    ///
    ///
    /// TITLE
    world.add(TextComponent(
      text: "BURYER",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: 'This factory bury the waste. It does not generates pollution.\nGarbage processed this way earn you no money.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    world.add(TextComponent(
      text: "Dig deeper   3 EcoCredits\nDouble capacity",
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 180),
    ));

    if (thisBuryer.capacityUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
      ));
    } else {
      world.add(upgradeCapacity = DialogButton(
        text: 'Buy upgrade',
        onPressed: () async {
          if (!isFetchingData) {
            isFetchingData = true;
            upgradeCapacity.textComponent.text = "Loading";
            String upgradeText = "";

            int ecoCredits = ref.read(gameUserControllerProvider.notifier).getUserEcoCredits();
            if (ecoCredits >= 3) {
              upgradeText = 'Upgrade Bought';
              ref.read(gameUserControllerProvider.notifier).updateGameUser(ecoCredits: ecoCredits - 3);
              thisBuryer.upgradeCapacity();
            } else {
              upgradeText = 'Insufficient EcoCredits';
            }
            if (upgradeCapacity.isMounted) {
              upgradeCapacity.removeFromParent();
            }
            world.add(TextComponent(
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
  }
}
