import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import '../../game.dart';
import '../../utils/my_text_style.dart';
import 'dialog_button.dart';
import 'truck_selector.dart';

enum TabGarageType { buySell, allTrucks }

class ContentGarage extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  Vector2 boxSize;
  ContentGarage({required this.boxSize, super.position});

  TabGarageType tabGarageType = TabGarageType.values[0];

  TextBoxComponent? textBoxComponentDescriptionTruck;
  TextBoxComponent? textBoxComponentTitleTruck;

  TruckType? currentTruckType;
  int numberOfCurrentTruckOwned = 0;

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

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(allTrucksControllerProvider, (previous, AllTrucks allTrucks) {
          textBoxComponentDescriptionTruck?.text = getTruckDescriptionText();
        }));
    super.onMount();
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
        game.truckController.buyTruck(currentTruckType!);
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 5, boxSize.y / 2 - 50),
    );
    add(buttonBuy);
    (parent as OverlayDialog).listButtons.add({'coordinates': buttonBuy.position, 'size': buttonBuy.buttonSize});

    final buttonSell = DialogButton(
      text: 'Sell Truck',
      onPressed: () {
        game.truckController.sellTruck(currentTruckType!);
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
    currentTruckType = truckType;

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
      text: getTruckTitleText(),
      textRenderer: MyTextStyle.header,
      boxConfig: TextBoxConfig(maxWidth: 300),
      position: Vector2(0, -boxSize.y / 2 + 100),
    );
    textBoxComponentDescriptionTruck = TextBoxComponent(
      text: getTruckDescriptionText(),
      textRenderer: MyTextStyle.text,
      boxConfig: TextBoxConfig(maxWidth: 300, timePerChar: 0.005),
      position: Vector2(0, -boxSize.y / 2 + 150),
    );
    add(textBoxComponentTitleTruck!);
    add(textBoxComponentDescriptionTruck!);
  }

  String getTruckDescriptionText() {
    TruckModel currenTruck = currentTruckType!.model;

    return "Price: ${currenTruck.buyCost}\$\nCost per road section: ${currenTruck.costPerTick}\$\n\nFabrication pollution: ${currenTruck.buyPollution}\nPollution per road section: ${currenTruck.pollutionPerTick}\n\nMax Load: ${currenTruck.maxLoad}\n\nOwned: ${ref.read(allTrucksControllerProvider).trucksOwned[currentTruckType] ?? 0}";
  }

  String getTruckTitleText() {
    TruckModel currenTruck = currentTruckType!.model;

    return currenTruck.name;
  }
}
