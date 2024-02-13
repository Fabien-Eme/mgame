import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/rotation_controller.dart';

import 'game.dart';
import 'tile_helper.dart';
import 'utils/convert_coordinates.dart';
import 'utils/convert_rotations.dart';

class Tile extends SpriteComponent with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  TileType tileType;
  Point<int> dimetricCoordinates;
  Point<int> gridCoordinates;
  bool isDebugMode;
  Tile({required this.tileType, required this.dimetricCoordinates, required this.gridCoordinates, this.isDebugMode = false, required super.position, super.size});

  bool isTileConstructible = true;
  bool isTileDestructible = false;
  bool isBuildingConstructible = true;
  bool isBuildingDestructible = false;
  ColorEffect? colorEffect;
  TileType? previousTileType;
  TileType? projectedTileType;
  TileType? beforeProjectionTileType;
  Rotation rotation = Rotation.zero;

  late Point<int> shownDimetricGridCoordinates;
  late TileType shownTileType;

  List<Directions> listConnectionRestriction = [];

  @override
  FutureOr<void> onLoad() {
    shownTileType = tileType;
    shownDimetricGridCoordinates = dimetricCoordinates;
    updateSprite();
    paint = Paint()..filterQuality = FilterQuality.low;
    if (isDebugMode) add(TextBoxComponent(text: '[${dimetricCoordinates.x}, ${dimetricCoordinates.y}]', scale: Vector2.all(0.6), position: Vector2(25, 12)));
    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          rotation = value;
          updatePosition();
          updateSprite();
        }));

    super.onMount();
  }

  void setPosition(Vector2 newPosition) {
    dimetricCoordinates = convertVectorToPoint(newPosition);
    updatePosition();
  }

  void setTileType(TileType newTileType) {
    tileType = newTileType;
    updateSprite();
  }

  void updatePosition() {
    shownDimetricGridCoordinates = game.convertRotations.rotateCoordinates(dimetricCoordinates);
    priority = convertDimetricPointToGridPoint(shownDimetricGridCoordinates).x;
    position = convertDimetricVectorToWorldCoordinates(Vector2(shownDimetricGridCoordinates.x.toDouble(), shownDimetricGridCoordinates.y.toDouble()));
  }

  void updateSprite() {
    shownTileType = getShownTileType(tileType, rotation);
    sprite = Sprite(game.images.fromCache(shownTileType.path));
  }

  void updateSpriteTemporarly(TileType temporaryTileType) {
    shownTileType = getShownTileType(temporaryTileType, rotation);
    sprite = Sprite(game.images.fromCache(shownTileType.path));
  }

  ///
  ///
  /// Manage Tile
  ///
  void projectTileConstruction(TileType? projectedTileType) {
    if (isTileConstructible && projectedTileType != null) {
      beforeProjectionTileType = tileType;
      projectedTileType = determineMyRoadType();
      setTileType(projectedTileType);

      world.tileCursor.highlightGreen();
    } else {
      world.tileCursor.highlightDefault();
    }
  }

  void projectTileChange() {
    if (tileType.canConnect) {
      previousTileType = tileType;
      setTileType(determineMyRoadType());
    }
  }

  void propagateTileChange() {
    setTileType(projectedTileType ?? tileType);
    projectedTileType = null;
    previousTileType = null;
  }

  void cancelProjectedTileChange() {
    if (previousTileType != null) setTileType(previousTileType!);
  }

  void constructTile({required TileType tileType, bool isMouseDragging = false}) {
    if (isTileConstructible) {
      if (tileType == TileType.road) {
        tileType = determineMyRoadType();
      }
      setTileType(tileType);
      isTileConstructible = false;
      isTileDestructible = true;
      isBuildingConstructible = false;
      projectedTileType = null;
      beforeProjectionTileType = null;
      world.tileCursor.highlightDefault();
    }
  }

  void changeTileToWantToDestroy() {
    if (!isTileConstructible && isTileDestructible) {
      world.tileCursor.highlightRed();
    } else {
      world.tileCursor.highlightDefault();
    }
  }

  void destroyTile({bool isMouseDragging = false}) {
    if (!isTileConstructible && isTileDestructible) {
      isTileConstructible = true;
      isTileDestructible = false;
      isBuildingConstructible = true;

      setTileType(TileType.grass);
      previousTileType = TileType.grass;

      world.tileCursor.highlightDefault();
    }
  }

  void resetTileAfterProjection() {
    setTileType(beforeProjectionTileType ?? tileType);
    beforeProjectionTileType = null;
    projectedTileType = null;
  }

  bool canTileConnectWithMe(Tile? neighborTile) {
    if (neighborTile == null) return false;
    Directions? neighborDirection = game.gridController.getNeigbhorTileDirection(this, neighborTile);
    if (neighborTile.tileType.canConnect &&
        neighborDirection != null &&
        !listConnectionRestriction.contains(neighborDirection) &&
        !neighborTile.listConnectionRestriction.contains(neighborDirection.mirror)) {
      return true;
    } else {
      return false;
    }
  }

  TileType determineMyRoadType() {
    Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(this);

    int numberOfConnections = 0;
    for (Tile? neighborTile in mapNeighbors.values) {
      if (neighborTile != null && canTileConnectWithMe(neighborTile)) numberOfConnections++;
    }

    if (numberOfConnections == 4) {
      return TileType.roadSWNE;
    }
    if (numberOfConnections == 3) {
      if (!canTileConnectWithMe(mapNeighbors[Directions.S])) return TileType.roadWNE;
      if (!canTileConnectWithMe(mapNeighbors[Directions.W])) return TileType.roadNES;
      if (!canTileConnectWithMe(mapNeighbors[Directions.N])) return TileType.roadESW;
      if (!canTileConnectWithMe(mapNeighbors[Directions.E])) return TileType.roadSWN;
    }
    if (numberOfConnections == 2) {
      if (canTileConnectWithMe(mapNeighbors[Directions.S])) {
        if (canTileConnectWithMe(mapNeighbors[Directions.W])) return TileType.roadSW;
        if (canTileConnectWithMe(mapNeighbors[Directions.N])) return TileType.roadSN;
        if (canTileConnectWithMe(mapNeighbors[Directions.E])) return TileType.roadSE;
      }
      if (canTileConnectWithMe(mapNeighbors[Directions.W])) {
        if (canTileConnectWithMe(mapNeighbors[Directions.N])) return TileType.roadWN;
        if (canTileConnectWithMe(mapNeighbors[Directions.E])) return TileType.roadWE;
      }
      if (canTileConnectWithMe(mapNeighbors[Directions.N])) {
        if (canTileConnectWithMe(mapNeighbors[Directions.E])) return TileType.roadNE;
      }
    }
    if (numberOfConnections == 1) {
      if (canTileConnectWithMe(mapNeighbors[Directions.S])) return TileType.roadS;
      if (canTileConnectWithMe(mapNeighbors[Directions.W])) return TileType.roadW;
      if (canTileConnectWithMe(mapNeighbors[Directions.N])) return TileType.roadN;
      if (canTileConnectWithMe(mapNeighbors[Directions.E])) return TileType.roadE;
    }

    return TileType.road;
  }

  void markAsBuilt() {
    isTileConstructible = false;
    isTileDestructible = false;
    isBuildingConstructible = false;
    isBuildingDestructible = true;
  }

  void markAsBuiltButStillConstructible() {
    isBuildingConstructible = false;
    isBuildingDestructible = true;
  }

  Point<int> getDimetricCoordinates() {
    return dimetricCoordinates;
  }
}
