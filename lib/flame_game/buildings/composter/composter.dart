import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';

import '../../game.dart';
import '../../truck/truck.dart';
import '../../ui/show_garbage_processed_tick.dart';
import '../../ui/show_money_gained_tick.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';
import 'composter_component.dart';
import 'composter_outline.dart';

class Composter extends Building {
  Point<int> unLoadTileCoordinate;
  Composter({super.direction, super.position, required super.anchorTile, required this.unLoadTileCoordinate});

  late final ComposterComponent composterComponent;
  late final ComposterOutlineComponent composterOutlineComponent;
  late Vector2 offset;

  Point<int> deliveryPointDimetric = const Point<int>(0, 0);

  int offsetPriority = 0;

  double reductionRate = 1;

  Vector2 currentPosition = Vector2(0, 0);

  Vector2 showTickPosition = Vector2.zero();

  bool isComposterFull = false;
  double timer = 0;

  double moneyBonus = 1;

  @override
  FutureOr<void> onLoad() async {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(0, 1)) + Vector2(0, 15);

    composterComponent = ComposterComponent(direction: direction, position: position + offset, fillCapacity: 30, fillAmount: 0);
    composterOutlineComponent = ComposterOutlineComponent(direction: direction, position: position + offset);
    updatePosition(position + offset);

    world.add(composterComponent);
    world.add(composterOutlineComponent);
    composterOutlineComponent.opacity = 0;

    return super.onLoad();
  }

  ///
  ///
  /// Add waste to the buryer.
  /// Return the amount of excedent waste
  int updateFillAmount(int fillAmount) {
    int fillCapacityLeft = composterComponent.fillCapacity - composterComponent.fillAmount;
    int fillAmountAccepted = min(fillAmount, fillCapacityLeft);

    composterComponent.fillAmount = composterComponent.fillAmount + fillAmountAccepted;

    int quantityRefused = fillAmount - fillAmountAccepted;

    if (quantityRefused > 0) isComposterFull = true;

    return quantityRefused;
  }

  @override
  void updatePosition(Vector2 updatedPosition) async {
    currentPosition = updatedPosition;
    composterComponent.position = updatedPosition + offset;
    composterOutlineComponent.position = updatedPosition + offset;

    showTickPosition = updatedPosition + Vector2(0, -50);
  }

  @override
  void updateDirection(Directions updatedDirection) {}

  @override
  void updatePriority(Vector2 updatedPosition) {
    offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    composterComponent.priority = 115 + offsetPriority;
    composterOutlineComponent.priority = 114 + offsetPriority;
  }

  @override
  void select() {
    composterOutlineComponent.opacity = 1;
  }

  @override
  void deselect() {
    composterOutlineComponent.opacity = 0;
  }

  @override
  void renderAboveAll() {
    composterComponent.priority = 490;
  }

  @override
  BuildingType get buildingType => BuildingType.composter;

  @override
  Point<int> get sizeInTile => const Point<int>(1, 2);

  @override
  void changeColor(Color color) {
    composterComponent.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    composterComponent.paint.colorFilter = null;
    super.resetColor();
  }

  @override
  void makeTransparent() {
    composterComponent.opacity = 0.8;
  }

  @override
  void closeDoor() {}

  @override
  void initialize() {}

  @override
  void openDoor() {}

  @override
  void onRemove() {
    if (composterComponent.ancestors().isNotEmpty) {
      world.remove(composterComponent);
      world.remove(composterOutlineComponent);
      world.gridController.getRealTileAtDimetricCoordinates(getComposterUnLoadTileCoordinate(anchorTile: anchorTile, direction: direction))?.resetTile();
    }
    super.onRemove();
  }

  void showGarbageProcessedTick({required int quantity}) {
    world.add(ShowGarbageProcessedTick(quantity: quantity)
      ..position = showTickPosition
      ..priority = 1000);
  }

  void showMoneyGainedTick({required int quantity}) {
    world.add(ShowMoneyGainedTick(quantity: quantity)
      ..position = showTickPosition
      ..priority = 1000);
  }

  @override
  double get buildingCost => 10000;

  @override
  Truck? isOccupiedByTruck() {
    return null;
  }

  @override
  bool get isRefundable => false;

  @override
  void update(double dt) {
    timer += dt;

    if (timer >= 5) {
      timer = 0;
      composterComponent.fillAmount -= 1;
    }

    if (composterComponent.fillAmount == composterComponent.fillCapacity) {
      isComposterFull = true;
    } else {
      isComposterFull = false;
    }

    super.update(dt);
  }
}

Point<int> getComposterUnLoadTileCoordinate({required Point<int> anchorTile, required Directions direction}) {
  switch (direction) {
    case Directions.S:
      return anchorTile + const Point<int>(0, -1);
    case Directions.W:
      return anchorTile + const Point<int>(-1, 0);
    case Directions.N:
      return anchorTile + const Point<int>(0, 1);
    case Directions.E:
      return anchorTile + const Point<int>(1, 0);
  }
}
