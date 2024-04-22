import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/addon_toggle_accept_waste.dart';

import '../buildings/composter/composter.dart';
import '../level.dart';
import '../utils/my_text_style.dart';

import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuComposter extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuComposter() : super(boxSize: Vector2(700, 350));

  late final DialogButton upgradeCapacity;
  late final DialogButton upgradeComposting;

  @override
  void onLoad() {
    super.onLoad();

    Composter thisComposter = game.currentlySelectedBuilding as Composter;

    world.add(AddonToggleAcceptWaste(position: Vector2(0, boxSize.y / 2)));

    ///
    ///
    /// TITLE
    world.add(TextComponent(
      text: "COMPOSTER",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: 'This building compost organic waste. It does not generates pollution.\nGarbage processed this way earn you money.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    ///
    ///
    /// UPGRADES

    world.add(TextComponent(
      text: 'Build a bigger composter!   3K\$\nUpgrade capacity from 30 to 50',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 180),
    ));
    if (thisComposter.capacityUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
      ));
    } else {
      world.add(upgradeCapacity = DialogButton(
        text: 'Buy upgrade',
        onPressed: () {
          if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(3000)) {
            (game.findByKeyName('level') as Level).money.addValue(-3000);
            thisComposter.upgradeCapacity();
            if (upgradeCapacity.isMounted) {
              world.remove(upgradeCapacity);
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
      text: 'Optimize composting process   3K\$\nThe composter empty itself faster',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 280),
    ));
    if (thisComposter.compostingUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
      ));
    } else {
      world.add(upgradeComposting = DialogButton(
        text: 'Buy upgrade',
        onPressed: () {
          if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(3000)) {
            (game.findByKeyName('level') as Level).money.addValue(-3000);
            thisComposter.upgradeComposting();
            if (upgradeComposting.isMounted) {
              world.remove(upgradeComposting);
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
  }
}
