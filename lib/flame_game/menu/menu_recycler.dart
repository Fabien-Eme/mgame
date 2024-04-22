import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/addon_toggle_accept_waste.dart';

import '../buildings/incinerator/incinerator.dart';
import '../level.dart';
import '../utils/my_text_style.dart';

import 'dialog_button.dart';
import 'menu_without_tabs.dart';

class MenuRecycler extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuRecycler() : super(boxSize: Vector2(700, 300));

  late final DialogButton upgradeMoneyBonus;

  bool isFetchingData = false;

  @override
  void onLoad() {
    super.onLoad();

    Incinerator thisRecycler = game.currentlySelectedBuilding as Incinerator;

    world.add(AddonToggleAcceptWaste(position: Vector2(0, boxSize.y / 2)));

    ///
    ///
    /// TITLE
    world.add(TextComponent(
      text: "RECYCLER",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    ///
    ///
    /// TEXT
    world.add(TextComponent(
      text: 'This factory recycle recyclable waste. It does not generates pollution.\nGarbage processed this way earn you money.',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 80),
    ));

    ///
    ///
    /// UPGRADES

    world.add(TextComponent(
      text: 'Upcycle!   5K\$\nIncrease money earned by 50%',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 20, -boxSize.y / 2 + 200),
    ));

    if (thisRecycler.moneyBonusUpgrade) {
      world.add(TextComponent(
        text: 'Upgrade Bought',
        textRenderer: MyTextStyle.text,
        anchor: Anchor.center,
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 200),
      ));
    } else {
      world.add(upgradeMoneyBonus = DialogButton(
        text: 'Buy upgrade',
        onPressed: () {
          if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(8000)) {
            (game.findByKeyName('level') as Level).money.addValue(-8000);
            thisRecycler.upgradeMoneyBonus(1.5);

            if (upgradeMoneyBonus.isMounted) {
              world.remove(upgradeMoneyBonus);
              world.add(TextComponent(
                text: 'Upgrade Bought',
                textRenderer: MyTextStyle.text,
                anchor: Anchor.center,
                position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 200),
              ));
            }
          }
        },
        buttonSize: Vector2(200, 50),
        position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 200),
      ));
    }

    ///
  }
}
