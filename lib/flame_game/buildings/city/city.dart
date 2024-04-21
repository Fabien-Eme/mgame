import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/city/city_component.dart';
import 'package:mgame/flame_game/buildings/city/city_outline_component.dart';
import 'package:mgame/flame_game/waste/waste.dart';

import '../../controller/waste_controller.dart';
import '../../game.dart';
import '../../truck/truck.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';

class City extends Building {
  Point<int> loadTileCoordinate;
  CityType cityType;
  City({super.direction, super.position, required super.anchorTile, required this.loadTileCoordinate, required this.cityType});

  Map<WasteType, Vector2> mapWastePosition = {};

  late final CityComponent cityComponent;
  late final CityOutlineComponent cityOutlineComponent;
  late final Vector2 offset;

  int offsetPriority = 0;

  double reductionRate = 1;

  @override
  FutureOr<void> onLoad() async {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(0, 1)) + Vector2(0, -3);

    cityComponent = CityComponent(direction: direction, position: position + offset);
    cityOutlineComponent = CityOutlineComponent(direction: direction, position: position + offset);
    updatePosition(position + offset);

    world.add(cityComponent);
    world.add(cityOutlineComponent);
    cityOutlineComponent.opacity = 0;

    addWasteStacks();

    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) async {
    cityComponent.position = updatedPosition + offset;
    cityOutlineComponent.position = updatedPosition + offset;

    mapWastePosition[WasteType.garbageCan] = updatedPosition + offset + const Point(-1, 1).convertDimetricPointToWorldCoordinates();
    mapWastePosition[WasteType.recyclable] = updatedPosition + offset + const Point(1, 1).convertDimetricPointToWorldCoordinates();
    mapWastePosition[WasteType.organic] = updatedPosition + offset + const Point(-1, -1).convertDimetricPointToWorldCoordinates();
    mapWastePosition[WasteType.toxic] = updatedPosition + offset + const Point(1, -1).convertDimetricPointToWorldCoordinates();

    ///
    /// Update wastes anchored to this
    for (WasteStack wasteStack in world.wasteController.mapWasteStack.values) {
      if (wasteStack.component.anchorBuilding == this) {
        wasteStack.component.position = mapWastePosition[wasteStack.wasteType]!;
      }
    }
  }

  @override
  void updateDirection(Directions updatedDirection) {
    cityComponent.updateDirection(updatedDirection);
    cityOutlineComponent.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    cityComponent.priority = 90 + offsetPriority;
    cityOutlineComponent.priority = 89 + offsetPriority;

    world.wasteController.updateWasteStackPriority(anchorBuilding: this, priority: 91 + offsetPriority);
  }

  @override
  void select() {
    super.select();
    cityOutlineComponent.opacity = 1;
  }

  @override
  void deselect() {
    super.deselect();
    cityOutlineComponent.opacity = 0;
  }

  @override
  void renderAboveAll() {
    cityComponent.priority = 490;
  }

  @override
  BuildingType get buildingType => BuildingType.city;

  @override
  Point<int> get sizeInTile => const Point<int>(3, 3);

  @override
  void changeColor(Color color) {
    cityComponent.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    cityComponent.paint.colorFilter = null;
    super.resetColor();
  }

  @override
  void makeTransparent() {
    cityComponent.opacity = 0.8;
  }

  @override
  void closeDoor() {}

  @override
  void initialize() {}

  @override
  void openDoor() {}

  @override
  void onRemove() {
    //
    super.onRemove();
  }

  @override
  bool get isRefundable => false;

  @override
  double get buildingCost => 0;

  void addWasteStacks() {
    for (WasteType wasteType in WasteType.values) {
      if (wasteType != WasteType.ultimate) {
        if (cityType.wasteRate(wasteType) > 0) {
          world.wasteController
              .createWasteStack(building: this, wasteRate: cityType.wasteRate(wasteType) * reductionRate, wasteType: wasteType, startingValue: cityType.wasteStartingValue(wasteType) ?? 0);
        }
      }
    }
  }

  @override
  Truck? isOccupiedByTruck() {
    return null;
  }
}

Point<int> getCityLoadTileCoordinate({required Point<int> anchorTile, required Directions direction}) {
  switch (direction) {
    case Directions.S:
      return anchorTile + const Point<int>(-1, -1);
    case Directions.W:
      return anchorTile + const Point<int>(-3, 1);
    case Directions.N:
      return anchorTile + const Point<int>(-1, 3);
    case Directions.E:
      return anchorTile + const Point<int>(1, 1);
  }
}

enum CityType {
  tutorial,
  normal,
  pollutingWithRecyclable,
  recycleALot,
  pollutingWithToxic,
  pollutingWithOrganic,
  classicCity;

  double wasteRate(WasteType? wasteType) {
    switch (this) {
      case CityType.tutorial:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 1.0;
          case WasteType.recyclable:
            return 0.0;
          case WasteType.organic:
            return 0.0;
          case WasteType.toxic:
            return 0.0;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }

      case CityType.normal:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 0.2;
          case WasteType.recyclable:
            return 0.5;
          case WasteType.organic:
            return 0.5;
          case WasteType.toxic:
            return 0.0;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }

      case CityType.pollutingWithRecyclable:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 1;
          case WasteType.recyclable:
            return 0.2;
          case WasteType.organic:
            return 0.0;
          case WasteType.toxic:
            return 0.0;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }
      case CityType.pollutingWithOrganic:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 0.5;
          case WasteType.recyclable:
            return 0.0;
          case WasteType.organic:
            return 0.5;
          case WasteType.toxic:
            return 0.0;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }

      case CityType.pollutingWithToxic:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 1;
          case WasteType.recyclable:
            return 0.0;
          case WasteType.organic:
            return 0.0;
          case WasteType.toxic:
            return 0.25;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }

      case CityType.recycleALot:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 0.2;
          case WasteType.recyclable:
            return 1.0;
          case WasteType.organic:
            return 0.0;
          case WasteType.toxic:
            return 0.0;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }

      case CityType.classicCity:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 0.5;
          case WasteType.recyclable:
            return 0.2;
          case WasteType.organic:
            return 0.2;
          case WasteType.toxic:
            return 0.1;
          case WasteType.ultimate:
            return 0;
          default:
            return 1;
        }
    }
  }

  String get cityTitle {
    switch (this) {
      case CityType.tutorial:
        return "TUTORIAL CITY";
      case CityType.normal:
        return "ECO-FRIENDLY CITY";
      case CityType.pollutingWithRecyclable:
        return "POLLUTING CITY";
      case CityType.recycleALot:
        return "RECYCLE CITY";
      case CityType.pollutingWithToxic:
        return "TOXIC CITY";
      case CityType.pollutingWithOrganic:
        return "GREEN CITY";
      case CityType.classicCity:
        return "CLASSIC CITY";
    }
  }

  String get cityText {
    switch (this) {
      case CityType.tutorial:
        return "This city produce only basic waste.";
      case CityType.normal:
        return "This city produce mainly organic and recyclable waste.";
      case CityType.pollutingWithRecyclable:
        return "This city produce mainly unsorted waste plus some recyclable.";
      case CityType.recycleALot:
        return "This city produce mainly recyclable waste plus some unsorted.";
      case CityType.pollutingWithToxic:
        return "This city produce mainly unsorted waste plus some toxic.";
      case CityType.pollutingWithOrganic:
        return "This city produce an equal amount of unsorted waste and organic waste.";
      case CityType.classicCity:
        return "This city produce a bit of everything.";
    }
  }

  int? wasteStartingValue(WasteType wasteType) {
    switch (this) {
      case CityType.pollutingWithToxic:
        switch (wasteType) {
          case WasteType.garbageCan:
            return 20;
          case WasteType.toxic:
            return 10;
          default:
            return null;
        }
      case CityType.classicCity:
        switch (wasteType) {
          case WasteType.toxic:
            return 10;
          default:
            return null;
        }
      default:
        return null;
    }
  }
}
