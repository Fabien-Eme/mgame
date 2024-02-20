import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/overlay/content_garage.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import 'dialog_tabs.dart';

class TabsGarage extends PositionComponent {
  Vector2 boxSize;
  TabsGarage({required this.boxSize});

  @override
  FutureOr<void> onLoad() {
    final tabBuySell = DialogTab(
      text: "Buy / Sell",
      onPressed: () {
        (parent as OverlayDialog).contentGarage?.tabSelected(TabGarageType.buySell);
      },
      position: Vector2(-boxSize.x / 2 - 50, -boxSize.y / 2 + 40),
    );
    add(tabBuySell);

    (parent as OverlayDialog).listButtons.add({'coordinates': tabBuySell.position, 'size': tabBuySell.size});
    (parent as OverlayDialog).listTabs.add(tabBuySell);

    final tabAllTrucks = DialogTab(
      text: "All Trucks",
      onPressed: () {
        (parent as OverlayDialog).contentGarage?.tabSelected(TabGarageType.allTrucks);
      },
      position: Vector2(-boxSize.x / 2 - 50, -boxSize.y / 2 + 90),
    );
    add(tabAllTrucks);
    (parent as OverlayDialog).listButtons.add({'coordinates': tabAllTrucks.position, 'size': tabAllTrucks.size});
    (parent as OverlayDialog).listTabs.add(tabAllTrucks);

    tabBuySell.select();

    return super.onLoad();
  }
}
