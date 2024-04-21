import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/addon_toggle_accept_waste.dart';

import '../utils/my_text_style.dart';

import 'menu_without_tabs.dart';

class MenuComposter extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuComposter() : super(boxSize: Vector2(700, 450));

  @override
  void onLoad() {
    super.onLoad();

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
  }
}
