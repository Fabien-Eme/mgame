import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../game.dart';
import '../../level.dart';
import '../../riverpod_controllers/all_trucks_controller.dart';
import '../../truck/truck.dart';
import '../../truck/truck_model.dart';
import '../dialog_button.dart';
import 'truck_selector.dart';
import '../../utils/my_text_style.dart';

class BuySellContent extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final Vector2 boxSize;
  BuySellContent({required this.boxSize});

  TextBoxComponent? textBoxComponentDescriptionTruck;
  TextBoxComponent? textBoxComponentTitleTruck;

  late final DialogButton buyTruckButton;

  TruckType? currentTruckType;
  int numberOfCurrentTruckOwned = 0;

  @override
  FutureOr<void> onLoad() {
    add(TextComponent(
      text: "GARAGE",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    add(TextComponent(
      text: "Need upgrade first",
      textRenderer: MyTextStyle.text,
      anchor: Anchor.center,
      position: Vector2(0, boxSize.y / 2 - 50),
    ));

    add(buyTruckButton = DialogButton(
      text: 'Buy Truck',
      onPressed: () {
        (game.findByKeyName('level') as Level).levelWorld.truckController.buyTruck(currentTruckType!);
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(0, boxSize.y / 2 - 50),
    ));

    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(allTrucksControllerProvider, (previous, AllTrucks allTrucks) {
          textBoxComponentDescriptionTruck?.text = getTruckDescriptionText();
        }));
    super.onMount();
    add(TruckSelector(
      changeTruckType: changeTruckType,
      position: Vector2(-boxSize.x / 4, -20),
    ));
  }

  void changeTruckType(TruckType truckType) async {
    currentTruckType = truckType;

    if (currentTruckType == TruckType.yellow) {
      if (buyTruckButton.isRemoved) add(buyTruckButton);
    }

    if (currentTruckType == TruckType.purple) {
      if ((game.findByKeyName('level') as Level).isPurpleTruckAvailable) {
        if (buyTruckButton.isRemoved) add(buyTruckButton);
      } else {
        if (buyTruckButton.isMounted) remove(buyTruckButton);
      }
    }

    if (currentTruckType == TruckType.blue) {
      if ((game.findByKeyName('level') as Level).isBlueTruckAvailable) {
        if (buyTruckButton.isRemoved) add(buyTruckButton);
      } else {
        if (buyTruckButton.isMounted) remove(buyTruckButton);
      }
    }

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

    return "Price: ${((currenTruck.buyCost) / 1000).toStringAsFixed(2)} K\$\nCost per road section: ${currenTruck.costPerTick}\$\n\nFabrication pollution: ${currenTruck.buyPollution}\nPollution per road section: ${currenTruck.pollutionPerTile}\n\nMax Load: ${currenTruck.maxLoad}\n\nOwned: $quantityOfCurrentTruckOwned";
  }

  String getTruckTitleText() {
    TruckModel currenTruck = currentTruckType!.model;

    return currenTruck.name;
  }
}
