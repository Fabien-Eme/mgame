import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import '../game.dart';
import '../riverpod_controllers/rotation_controller.dart';
import '../utils/convert_rotations.dart';

abstract class Building extends PositionComponent with HasGameReference<MGame>, HasWorldReference, RiverpodComponentMixin {
  Directions direction;
  Point<int> anchorTile;
  Point<int> dimetricCoordinates = const Point<int>(0, 0);
  Rotation rotation = Rotation.zero;

  Building({this.direction = Directions.E, required this.anchorTile, super.position});

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          rotation = value;
          Point<int> offsetSizeInTile = game.convertRotations.rotateOffsetSizeInTile(sizeInTile);
          Vector2 updatedPosition = convertDimetricPointToWorldCoordinates(game.convertRotations.rotateCoordinates(dimetricCoordinates - offsetSizeInTile));
          updatePosition(updatedPosition);
          Directions updatedDirection = game.convertRotations.rotateDirections(direction);
          updateDirection(updatedDirection);
          updatePriority(updatedPosition);
        }));

    super.onMount();
  }

  void setPosition(Point<int> newPosition) {
    Point<int> initialOffsetSizeInTile = game.convertRotations.rotateOffsetSizeInTile(sizeInTile);
    dimetricCoordinates = newPosition + initialOffsetSizeInTile;

    Point<int> offsetSizeInTile = game.convertRotations.rotateOffsetSizeInTile(sizeInTile);
    Vector2 updatedPosition = convertDimetricPointToWorldCoordinates(game.convertRotations.rotateCoordinates(dimetricCoordinates - offsetSizeInTile));
    updatePosition(updatedPosition);
    updatePriority(updatedPosition);
  }

  void setDirection(Directions newDirection) {
    direction = game.convertRotations.unRotateDirections(newDirection);
    updateDirection(newDirection);
  }

  @mustBeOverridden
  BuildingType get buildingType;

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
  void makeTransparent() {}

  @mustBeOverridden
  @override
  void onRemove() {
    super.onRemove();
  }
}

Building createBuilding({required BuildingType buildingType, Directions? direction, Point<int>? anchorTile}) {
  anchorTile ??= const Point(0, 0);
  direction ??= Directions.E;
  return switch (buildingType) {
    BuildingType.garbageLoader => GarbageLoader(direction: direction, garbageLoaderFlow: GarbageLoaderFlow.flowIn, anchorTile: anchorTile),
    BuildingType.recycler => Incinerator(direction: direction, anchorTile: anchorTile),
    BuildingType.incinerator => Incinerator(direction: direction, anchorTile: anchorTile),
  };
}

enum BuildingType {
  garbageLoader,
  recycler,
  incinerator;
}
