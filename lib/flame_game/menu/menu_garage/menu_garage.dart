import 'package:flame/components.dart';
import 'package:mgame/flame_game/menu/menu_garage/all_trucks.dart';
import 'package:mgame/flame_game/menu/menu_garage/buy_sell.dart';
import 'package:mgame/flame_game/menu/menu_garage/infos.dart';
import 'package:mgame/flame_game/menu/menu_with_tabs.dart';

import 'upgrades.dart';

class MenuGarage extends MenuWithTabs {
  MenuGarage()
      : super(
          boxSize: Vector2(900, 525),
          mapDialogTab: {
            "Buy Truck": () => BuySellContent(boxSize: Vector2(900, 525)),
            "Trucks Priorities": () => AllTrucksContent(boxSize: Vector2(900, 525)),
            "Upgrades": () => UpgradeTrucksContent(boxSize: Vector2(900, 525)),
            "Infos": () => InfosGarageContent(boxSize: Vector2(900, 525)),
          },
        );
}
