import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/truck/truck_helper.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:mgame/flame_game/ui/overlay/forward_backward_button.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../truck/truck.dart';
import '../../utils/convert_rotations.dart';
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

  int indexOffset = 0;
  int maxItems = 7;

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
        addAllTrucks();
    }
  }

  ///
  ///
  /// All Trucks Tab content
  addAllTrucks() async {
    final title = TextComponent(
      text: "ALL TRUCKS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    add(title);

    add(TextComponent(
      text: 'Truck',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 75, -boxSize.y / 2 + 100),
    ));
    add(TextComponent(
      text: 'Task affected',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 250, -boxSize.y / 2 + 100),
    ));
    add(TextComponent(
      text: 'State',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 550, -boxSize.y / 2 + 100),
    ));

    Map<String, Truck> mapAllTrucks = ref.read(allTrucksControllerProvider).trucksOwned;
    List<Truck> listTrucks = mapAllTrucks.values.toList();

    List<Component> truckTable = getTruckTable(List.from(listTrucks));
    addAll(truckTable);

    add(SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddleBar.path)),
      anchor: Anchor.center,
      angle: -pi / 2,
      size: Vector2(338, 16),
      position: Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 295),
    ));

    SpriteComponent selector = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddlePoint.path)),
      anchor: Anchor.center,
      angle: -pi / 2,
      size: Vector2(39, 48),
      position: Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems)))),
    );
    add(selector);

    add(ForwardBackwardButton(
      isForward: false,
      onPressed: () {
        if (indexOffset - 1 >= 0) {
          indexOffset--;
          truckTable = reAddTruckTable(truckTable, List.from(listTrucks));
          selector.position = Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems))));
        }
      },
      isVertical: true,
      position: Vector2(-boxSize.x / 2 + 800, -boxSize.y / 2 + 110),
    ));
    add(ForwardBackwardButton(
      isForward: true,
      onPressed: () {
        if (indexOffset + 1 <= listTrucks.length - maxItems) {
          indexOffset++;
          truckTable = reAddTruckTable(truckTable, List.from(listTrucks));
          selector.position = Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems))));
        }
      },
      isVertical: true,
      position: Vector2(-boxSize.x / 2 + 800, -boxSize.y / 2 + 480),
    ));
  }

  List<Component> reAddTruckTable(List<Component> truckTable, List<Truck> listTrucks) {
    for (Component component in truckTable) {
      remove(component);
    }
    truckTable = getTruckTable(listTrucks);
    addAll(truckTable);
    return truckTable;
  }

  List<Component> getTruckTable(List<Truck> listTrucks) {
    List<Component> listComponents = [];

    if (indexOffset > 0) {
      listTrucks.removeRange(0, indexOffset);
    }
    if (listTrucks.length > maxItems) {
      listTrucks.removeRange(maxItems, listTrucks.length);
    }

    int index = 0;
    for (Truck truck in listTrucks) {
      listComponents.add(SpriteComponent(
        sprite: Sprite(game.images.fromCache(getTruckAssetPath(truckType: truck.truckType, truckAngle: Directions.E.angle))),
        anchor: Anchor.center,
        size: Vector2(50, 50),
        position: Vector2(-boxSize.x / 2 + 80, -boxSize.y / 2 + 150 + index * 50),
      ));
      listComponents.add(TextComponent(
        text: truck.currentTask?.taskType.name ?? "No task",
        textRenderer: MyTextStyle.header,
        anchor: Anchor.center,
        position: Vector2(-boxSize.x / 2 + 250, -boxSize.y / 2 + 150 + index * 50),
      ));
      listComponents.add(TextComponent(
        text: (truck.isTruckMoving) ? "Going to task" : "Idling",
        textRenderer: MyTextStyle.header,
        anchor: Anchor.center,
        position: Vector2(-boxSize.x / 2 + 550, -boxSize.y / 2 + 150 + index * 50),
      ));

      index++;
    }
    return listComponents;
  }

  ///
  ///
  /// Buy/Sell Tab content
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

    int quantityOfCurrentTruckOwned = ref.read(allTrucksControllerProvider).trucksOwned.values.where((Truck truck) => truck.truckType == currentTruckType).length;

    return "Price: ${currenTruck.buyCost}\$\nCost per road section: ${currenTruck.costPerTick}\$\n\nFabrication pollution: ${currenTruck.buyPollution}\nPollution per road section: ${currenTruck.pollutionPerTick}\n\nMax Load: ${currenTruck.maxLoad}\n\nOwned: $quantityOfCurrentTruckOwned";
  }

  String getTruckTitleText() {
    TruckModel currenTruck = currentTruckType!.model;

    return currenTruck.name;
  }
}
