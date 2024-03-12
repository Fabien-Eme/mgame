import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import '../game.dart';
import '../riverpod_controllers/rotation_controller.dart';
import '../tile/tile.dart';
import '../utils/convert_rotations.dart';
import 'city/city.dart';
import 'garage/garage.dart';

abstract class Building extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  Directions direction;
  Point<int> anchorTile;
  Point<int> dimetricCoordinates = const Point<int>(0, 0);
  Rotation rotation = Rotation.zero;
  List<Tile?> tilesIAmOn = [];

  Building({this.direction = Directions.E, required this.anchorTile, super.position});

  Point<int> shownDimetricCoordinates = const Point<int>(0, 0);
  List<Vector2> listInitialGarbagePosition = [];
  Vector2 finalGarbagePosition = Vector2(0, 0);

  bool isDoorOpen = false;
  bool isDoorClosed = true;
  List<Point<int>> listTilesWithDoor = [];
  String? garbageStackId;

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          rotation = value;
          Point<int> offsetSizeInTile = world.convertRotations.rotateOffsetSizeInTile(sizeInTile);
          Vector2 updatedPosition = convertDimetricPointToWorldCoordinates(world.convertRotations.rotateCoordinates(dimetricCoordinates - offsetSizeInTile));
          shownDimetricCoordinates = world.convertRotations.rotateCoordinates(dimetricCoordinates - offsetSizeInTile);

          updatePosition(updatedPosition);

          Directions updatedDirection = world.convertRotations.rotateDirections(direction);
          updateDirection(updatedDirection);
          updatePriority(updatedPosition);
        }));

    super.onMount();
  }

  void setPosition(Point<int> newPosition) {
    dimetricCoordinates = newPosition;
    shownDimetricCoordinates = dimetricCoordinates;

    Vector2 updatedPosition = convertDimetricPointToWorldCoordinates(world.convertRotations.rotateCoordinates(dimetricCoordinates));
    updatePosition(updatedPosition);
    updatePriority(updatedPosition);
  }
  // void setPosition(Point<int> newPosition) {
  //   Point<int> initialOffsetSizeInTile = world.convertRotations.rotateOffsetSizeInTile(sizeInTile);
  //   dimetricCoordinates = newPosition + initialOffsetSizeInTile;

  //   Point<int> offsetSizeInTile = world.convertRotations.rotateOffsetSizeInTile(sizeInTile);
  //   Vector2 updatedPosition = convertDimetricPointToWorldCoordinates(world.convertRotations.rotateCoordinates(dimetricCoordinates - offsetSizeInTile));
  //   updatePosition(updatedPosition);
  //   updatePriority(updatedPosition);
  // }

  void setDirection(Directions newDirection) {
    direction = world.convertRotations.unRotateDirections(newDirection);
    updateDirection(newDirection);
  }

  @mustBeOverridden
  BuildingType get buildingType;

  @mustBeOverridden
  double get buildingCost;

  @mustBeOverridden
  int get sizeInTile;

  @mustBeOverridden
  void updatePosition(Vector2 updatedPosition) {}

  @mustBeOverridden
  void updateDirection(Directions updatedDirection) {}

  @mustBeOverridden
  void updatePriority(Vector2 updatedPosition) {}

  @mustBeOverridden
  void renderAboveAll() {}

  @mustBeOverridden
  void changeColor(Color color) {}

  @mustBeOverridden
  void resetColor() {}

  @mustBeOverridden
  void makeTransparent() {}

  @mustBeOverridden
  void openDoor() {}

  @mustBeOverridden
  void closeDoor() {}

  @mustBeOverridden
  @override
  void onRemove() {
    super.onRemove();
  }

  @mustBeOverridden
  void initialize() {}
}

Building createBuilding({required BuildingType buildingType, Directions? direction = Directions.E, Point<int> anchorTile = const Point(0, 0), double cityRate = 1}) {
  direction ??= Directions.E;
  return switch (buildingType) {
    BuildingType.garbageLoader => GarbageLoader(direction: direction, garbageLoaderFlow: GarbageLoaderFlow.flowOut, anchorTile: anchorTile),
    BuildingType.recycler => Incinerator(direction: direction, anchorTile: anchorTile),
    BuildingType.incinerator => Incinerator(direction: direction, anchorTile: anchorTile),
    BuildingType.garage => Garage(direction: direction, anchorTile: anchorTile),
    BuildingType.city => City(direction: direction, anchorTile: anchorTile, loadTileCoordinate: getCityLoadTileCoordinate(anchorTile: anchorTile, direction: direction), cityRate: cityRate),
  };
}

enum BuildingType {
  city,
  garbageLoader,
  recycler,
  incinerator,
  garage;
}
