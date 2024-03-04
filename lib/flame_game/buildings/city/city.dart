import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/city/city_component.dart';

import '../../controller/garbage_controller.dart';
import '../../game.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';

class City extends Building {
  Point<int> loadTileCoordinate;
  City({super.direction, super.position, required super.anchorTile, required this.loadTileCoordinate});

  late final CityComponent cityComponent;
  late final Vector2 offset;

  @override
  FutureOr<void> onLoad() async {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(0, 1)) + Vector2(0, -3);

    cityComponent = CityComponent(direction: direction, position: position + offset);
    updatePosition(position + offset);

    world.add(
      cityComponent,
    );
    world.garbageController.createGarbageStack(building: this);
    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) async {
    cityComponent.position = updatedPosition + offset;

    finalGarbagePosition = updatedPosition + offset + const Point(-1, 1).convertDimetricPointToWorldCoordinates();
    listInitialGarbagePosition = [
      updatedPosition + offset + const Point(0, 0).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(0, 1).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(0, 2).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(-1, 0).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(-2, 0).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(-1, 1).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(-2, 1).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
      updatedPosition + offset + const Point(-1, 2).convertDimetricPointToWorldCoordinates() + Vector2(0, MGame.tileHeight),
    ];

    ///
    /// Update garbages anchored to this
    for (GarbageStack garbageStack in world.garbageController.listGarbageStack.values) {
      if (garbageStack.component.anchorBuilding == this) {
        garbageStack.component.position = finalGarbagePosition;
      }
    }
  }

  @override
  void updateDirection(Directions updatedDirection) {
    cityComponent.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    final int offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    cityComponent.priority = 90 + offsetPriority;
  }

  @override
  void renderAboveAll() {
    cityComponent.priority = 490;
  }

  @override
  BuildingType get buildingType => BuildingType.city;

  @override
  int get sizeInTile => 3;

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
}

Point<int> getCityLoadTileCoordinate({required Point<int> anchorTile, required Directions direction}) {
  switch (direction) {
    case Directions.S:
      return anchorTile + const Point<int>(-1, -1);
    case Directions.W:
      return anchorTile + const Point<int>(-3, 0);
    case Directions.N:
      return anchorTile + const Point<int>(-1, 2);
    case Directions.E:
      return anchorTile + const Point<int>(1, 1);
  }
}
