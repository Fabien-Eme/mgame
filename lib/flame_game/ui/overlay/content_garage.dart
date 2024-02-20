import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import '../../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'truck_selector.dart';

enum TabGarageType { buySell, allTrucks }

class ContentGarage extends PositionComponent {
  Vector2 boxSize;
  ContentGarage({required this.boxSize, super.position});

  TabGarageType tabGarageType = TabGarageType.values[0];

  TextBoxComponent? textBoxComponentDescriptionTruck;
  TextBoxComponent? textBoxComponentTitleTruck;

  void tabSelected(TabGarageType newTabGarageType) {
    if (tabGarageType != newTabGarageType) {
      tabGarageType = newTabGarageType;
      addContent();
    }
  }

  @override
  FutureOr<void> onLoad() {
    addContent();
    return super.onLoad();
  }

  void addContent() async {
    removeAll(children);
    List<Future<void>> listRemoved = [];
    for (Component component in children) {
      listRemoved.add(component.removed);
    }

    await Future.wait(listRemoved);
    textBoxComponentDescriptionTruck = null;
    textBoxComponentTitleTruck = null;
    addContentOfTab();
  }

  addContentOfTab() {
    switch (tabGarageType) {
      case TabGarageType.buySell:
        addBuySell();
      case TabGarageType.allTrucks:
      // TODO: Handle this case.
    }
  }

  addBuySell() async {
    final title = TextComponent(
      text: "GARAGE",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    add(title);

    final buttonBuy = DialogButton(
      text: 'Buy Truck',
      onPressed: () {
        print("Truck bought");
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 5, boxSize.y / 2 - 50),
    );
    add(buttonBuy);
    (parent as OverlayDialog).listButtons.add({'coordinates': buttonBuy.position, 'size': buttonBuy.buttonSize});

    final buttonSell = DialogButton(
      text: 'Sell Truck',
      onPressed: () {
        print("Truck sold");
      },
      textStyle: MyTextStyle.buttonRed,
      buttonSize: Vector2(200, 50),
      position: Vector2(-boxSize.x / 5, boxSize.y / 2 - 50),
    );
    add(buttonSell);
    (parent as OverlayDialog).listButtons.add({'coordinates': buttonSell.position, 'size': buttonSell.buttonSize});

    add(TruckSelector(position: Vector2(-boxSize.x / 4, -20)));
  }

  void changeTruckType(TruckType truckType) async {
    if (textBoxComponentDescriptionTruck != null && textBoxComponentTitleTruck != null) {
      await textBoxComponentTitleTruck!.mounted;
      await textBoxComponentDescriptionTruck!.mounted;

      remove(textBoxComponentTitleTruck!);
      remove(textBoxComponentDescriptionTruck!);

      await Future.wait([
        textBoxComponentTitleTruck!.removed,
        textBoxComponentDescriptionTruck!.removed,
      ]);
    }
    textBoxComponentTitleTruck = TextBoxComponent(
      text: getTruckTitleText(truckType),
      textRenderer: MyTextStyle.header,
      boxConfig: TextBoxConfig(maxWidth: 300),
      position: Vector2(0, -boxSize.y / 2 + 100),
    );
    textBoxComponentDescriptionTruck = TextBoxComponent(
      text: getTruckDescriptionText(truckType),
      textRenderer: MyTextStyle.text,
      boxConfig: TextBoxConfig(maxWidth: 300, timePerChar: 0.01),
      position: Vector2(0, -boxSize.y / 2 + 150),
    );
    add(textBoxComponentTitleTruck!);
    add(textBoxComponentDescriptionTruck!);
  }

  String getTruckDescriptionText(TruckType truckType) {
    TruckModel currenTruck = truckType.model;

    return "Price: ${currenTruck.buyCost}\$\nCost per road section: ${currenTruck.costPerTick}\$\n\nFabrication pollution: ${currenTruck.buyPollution}\nPollution per road section: ${currenTruck.pollutionPerTick}\n\nOwned: 0";
  }

  String getTruckTitleText(TruckType truckType) {
    TruckModel currenTruck = truckType.model;

    return currenTruck.name;
  }
}
