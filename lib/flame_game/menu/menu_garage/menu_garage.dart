import 'package:flame/components.dart';
import 'package:mgame/flame_game/menu/menu_garage/all_trucks.dart';
import 'package:mgame/flame_game/menu/menu_garage/buy_sell.dart';
import 'package:mgame/flame_game/menu/menu_with_tabs.dart';

class MenuGarage extends MenuWithTabs {
  MenuGarage()
      : super(
          boxSize: Vector2(900, 525),
          mapDialogTab: {
            "Buy / Sell": () => BuySellContent(boxSize: Vector2(900, 525)),
            "All Trucks": () => AllTrucksContent(boxSize: Vector2(900, 525)),
          },
        );
}
