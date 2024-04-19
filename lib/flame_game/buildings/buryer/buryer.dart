import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';

import '../../game.dart';
import '../../truck/truck.dart';
import '../../ui/show_garbage_processed_tick.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';
import 'buryer_component.dart';
import 'buryer_outline.dart';

class Buryer extends Building {
  Point<int> unLoadTileCoordinate;
  Buryer({super.direction, super.position, required super.anchorTile, required this.unLoadTileCoordinate});

  late final BuryerComponent buryerComponent;
  late final BuryerOutlineComponent buryerOutlineComponent;
  late Vector2 offset;

  Point<int> deliveryPointDimetric = const Point<int>(0, 0);

  int offsetPriority = 0;

  double reductionRate = 1;

  Vector2 currentPosition = Vector2(0, 0);

  Vector2 showTickPosition = Vector2.zero();

  bool isBuryerFull = false;

  @override
  FutureOr<void> onLoad() async {
    updateOffset(direction);

    buryerComponent = BuryerComponent(direction: direction, position: position + offset, fillCapacity: 50, fillAmount: 0);
    buryerOutlineComponent = BuryerOutlineComponent(direction: direction, position: position + offset);
    updatePosition(position + offset);

    world.add(buryerComponent);
    world.add(buryerOutlineComponent);
    buryerOutlineComponent.opacity = 0;

    return super.onLoad();
  }

  ///
  ///
  /// Add waste to the buryer.
  /// Return the amount of excedent waste
  int updateFillAmount(int fillAmount) {
    int fillCapacityLeft = buryerComponent.fillCapacity - buryerComponent.fillAmount;
    int fillAmountAccepted = min(fillAmount, fillCapacityLeft);

    buryerComponent.fillAmount = buryerComponent.fillAmount + fillAmountAccepted;
    buryerComponent.updateSprite();

    int quantityRefused = fillAmount - fillAmountAccepted;

    if (quantityRefused > 0) isBuryerFull = true;

    return quantityRefused;
  }

  @override
  void updatePosition(Vector2 updatedPosition) async {
    currentPosition = updatedPosition;
    buryerComponent.position = updatedPosition + offset;
    buryerOutlineComponent.position = updatedPosition + offset;

    showTickPosition = updatedPosition + Vector2(0, -50);
  }

  @override
  void updateDirection(Directions updatedDirection) {
    updateOffset(updatedDirection);
    updatePosition(currentPosition);
    buryerComponent.updateDirection(updatedDirection);
    buryerOutlineComponent.updateDirection(updatedDirection);
  }

  void updateOffset(Directions updatedDirection) {
    switch (updatedDirection) {
      case (Directions.E):
        offset = convertDimetricVectorToWorldCoordinates(Vector2(0, 0)) + Vector2(40, 5);
        break;
      case (Directions.N):
        offset = convertDimetricVectorToWorldCoordinates(Vector2(1, 0)) + Vector2(-15, -10);
        break;
      case (Directions.W):
        offset = convertDimetricVectorToWorldCoordinates(Vector2(1, 1)) + Vector2(-35, 13);
        break;
      case (Directions.S):
        offset = convertDimetricVectorToWorldCoordinates(Vector2(1, 1)) + Vector2(-37, 6);
        break;
    }
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    buryerComponent.priority = 115 + offsetPriority;
    buryerOutlineComponent.priority = 114 + offsetPriority;
  }

  @override
  void select() {
    buryerOutlineComponent.opacity = 1;
  }

  @override
  void deselect() {
    buryerOutlineComponent.opacity = 0;
  }

  @override
  void renderAboveAll() {
    buryerComponent.priority = 490;
  }

  @override
  BuildingType get buildingType => BuildingType.buryer;

  @override
  Point<int> get sizeInTile => const Point<int>(1, 3);

  @override
  void changeColor(Color color) {
    buryerComponent.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    buryerComponent.paint.colorFilter = null;
    super.resetColor();
  }

  @override
  void makeTransparent() {
    buryerComponent.opacity = 0.8;
  }

  @override
  void closeDoor() {}

  @override
  void initialize() {}

  @override
  void openDoor() {}

  @override
  void onRemove() {
    if (buryerComponent.ancestors().isNotEmpty) {
      world.remove(buryerComponent);
      world.remove(buryerOutlineComponent);
      world.gridController.getRealTileAtDimetricCoordinates(getBuryerUnLoadTileCoordinate(anchorTile: anchorTile, direction: direction))?.resetTile();
    }
    super.onRemove();
  }

  void showGarbageProcessedTick({required int quantity}) {
    world.add(ShowGarbageProcessedTick(quantity: quantity)
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
}

Point<int> getBuryerUnLoadTileCoordinate({required Point<int> anchorTile, required Directions direction}) {
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
