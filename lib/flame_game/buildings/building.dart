import 'dart:ui';

import 'package:flame/components.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/utils/manage_coordinates.dart';

abstract class Building extends PositionComponent with HasWorldReference {
  Directions direction;
  Vector2 anchorTile;

  Building({this.direction = Directions.E, required this.anchorTile, super.position});

  @mustBeOverridden
  BuildingType get buildingType;

  @mustBeOverridden
  int get sizeInTile;

  @mustBeOverridden
  void changePosition(Vector2 newPosition) {}

  @mustBeOverridden
  void renderAboveAll() {}

  @mustBeOverridden
  void changeColor(Color color) {}

  @mustBeOverridden
  void makeTransparent() {}

  @mustBeOverridden
  @override
  void onRemove() {}
}

Building createBuilding({required BuildingType buildingType, Directions? direction, Vector2? anchorTile}) {
  anchorTile ??= Vector2.zero();
  return switch (buildingType) {
    BuildingType.garbageLoader => (direction == Directions.E)
        ? GarbageLoader(direction: Directions.E, garbageLoaderFlow: GarbageLoaderFlow.flowIn, anchorTile: anchorTile)
        : GarbageLoader(direction: Directions.S, garbageLoaderFlow: GarbageLoaderFlow.flowIn, anchorTile: anchorTile),
    BuildingType.recycler => (direction == Directions.E) ? Incinerator(direction: Directions.E, anchorTile: anchorTile) : Incinerator(direction: Directions.S, anchorTile: anchorTile),
    BuildingType.incinerator => (direction == Directions.E) ? Incinerator(direction: Directions.E, anchorTile: anchorTile) : Incinerator(direction: Directions.S, anchorTile: anchorTile),
  };
}

enum BuildingType {
  garbageLoader,
  recycler,
  incinerator;
}
