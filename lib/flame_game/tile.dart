import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:mgame/flame_game/game_world.dart';

import '../gen/assets.gen.dart';
import 'game.dart';
import 'utils/manage_coordinates.dart';

class Tile extends SpriteComponent with HasGameRef<MGame>, HasWorldReference<GameWorld> {
  TileType tileType;
  Point<int> dimetricGridCoordinates;
  Point<int> gridCoordinates;
  bool isDebugMode;
  Tile({required this.tileType, required this.dimetricGridCoordinates, required this.gridCoordinates, this.isDebugMode = false, required super.position, super.size});

  bool isConstructible = true;
  bool isDestructible = false;
  bool isBuildable = true;
  ColorEffect? colorEffect;
  TileType? previousTileType;
  TileType? projectedTileType;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    if (isDebugMode) add(TextBoxComponent(text: '[${dimetricGridCoordinates.x}, ${dimetricGridCoordinates.y}]', scale: Vector2.all(0.6), position: Vector2(25, 12)));
    return super.onLoad();
  }

  void highlight() {
    paint.colorFilter = const ColorFilter.mode(Color.fromARGB(100, 255, 255, 255), BlendMode.srcATop);
  }

  void removeHighlight() {
    paint.colorFilter = null;
  }

  void projectConstruction(TileType? tileType) {
    if (isConstructible && tileType != null) {
      if (tileType == TileType.road) {
        tileType = determineMyRoadType();
        projectedTileType = tileType;
      }

      sprite = Sprite(game.images.fromCache(tileType.path));
      paint.colorFilter = ColorFilter.mode((isConstructible) ? const Color.fromARGB(98, 0, 255, 38) : const Color.fromARGB(97, 250, 40, 40), BlendMode.srcATop);
    } else {
      highlight();
    }
  }

  void projectTileChange() {
    if (tileType.doesConnect) {
      previousTileType = tileType;
      tileType = determineMyRoadType();
      sprite = Sprite(game.images.fromCache(tileType.path));
    }
  }

  void propagateTileChange() {
    tileType = projectedTileType ?? tileType;
    sprite = Sprite(game.images.fromCache(tileType.path));
    projectedTileType = null;
    previousTileType = null;
  }

  void cancelProjectedTileChange() {
    if (previousTileType != null) tileType = previousTileType!;
    sprite = Sprite(game.images.fromCache(tileType.path));
  }

  void construct({required TileType tileType, bool isMouseDragging = false}) {
    if (isConstructible) {
      if (tileType == TileType.road) {
        tileType = determineMyRoadType();
      }
      this.tileType = tileType;
      sprite = Sprite(game.images.fromCache(tileType.path));
      isConstructible = false;
      isDestructible = true;
      if (!isMouseDragging) highlight();
      projectedTileType = null;
    }
  }

  void changeTileToWantToDestroy() {
    if (!isConstructible && isDestructible) {
      paint.colorFilter = const ColorFilter.mode(Color.fromARGB(97, 250, 40, 40), BlendMode.srcATop);
    } else {
      highlight();
    }
  }

  void destroy({bool isMouseDragging = false}) {
    if (!isConstructible && isDestructible) {
      isConstructible = true;
      isDestructible = false;
      tileType = TileType.grass;
      previousTileType = TileType.grass;
      sprite = Sprite(game.images.fromCache(tileType.path));
      if (!isMouseDragging) highlight();
    }
  }

  void resetTile() {
    projectedTileType = null;
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint.colorFilter = null;
  }

  TileType determineMyRoadType() {
    Map<Directions, TileType?> mapNeighbors = world.getAllNeigbhorsTileType(dimetricGridCoordinates: dimetricGridCoordinates);

    int numberOfConnections = 0;
    for (TileType? value in mapNeighbors.values) {
      if (value?.doesConnect ?? false) numberOfConnections++;
    }

    if (numberOfConnections == 4) {
      return TileType.roadSWNE;
    }
    if (numberOfConnections == 3) {
      if (!(mapNeighbors[Directions.S]?.doesConnect ?? false)) return TileType.roadWNE;
      if (!(mapNeighbors[Directions.W]?.doesConnect ?? false)) return TileType.roadNES;
      if (!(mapNeighbors[Directions.N]?.doesConnect ?? false)) return TileType.roadESW;
      if (!(mapNeighbors[Directions.E]?.doesConnect ?? false)) return TileType.roadSWN;
    }
    if (numberOfConnections == 2) {
      if (mapNeighbors[Directions.S]?.doesConnect ?? false) {
        if (mapNeighbors[Directions.W]?.doesConnect ?? false) return TileType.roadSW;
        if (mapNeighbors[Directions.N]?.doesConnect ?? false) return TileType.roadSN;
        if (mapNeighbors[Directions.E]?.doesConnect ?? false) return TileType.roadSE;
      }
      if (mapNeighbors[Directions.W]?.doesConnect ?? false) {
        if (mapNeighbors[Directions.N]?.doesConnect ?? false) return TileType.roadWN;
        if (mapNeighbors[Directions.E]?.doesConnect ?? false) return TileType.roadWE;
      }
      if (mapNeighbors[Directions.N]?.doesConnect ?? false) {
        if (mapNeighbors[Directions.E]?.doesConnect ?? false) return TileType.roadNE;
      }
    }
    if (numberOfConnections == 1) {
      if (mapNeighbors[Directions.S]?.doesConnect ?? false) return TileType.roadS;
      if (mapNeighbors[Directions.W]?.doesConnect ?? false) return TileType.roadW;
      if (mapNeighbors[Directions.N]?.doesConnect ?? false) return TileType.roadN;
      if (mapNeighbors[Directions.E]?.doesConnect ?? false) return TileType.roadE;
    }

    return TileType.road;
  }
}

enum TileType {
  road,
  roadS,
  roadW,
  roadN,
  roadE,
  roadNE,
  roadSE,
  roadSN,
  roadSW,
  roadWE,
  roadWN,
  roadESW,
  roadNES,
  roadSWN,
  roadWNE,
  roadSWNE,

  grass;

  String get path {
    return switch (this) {
      TileType.road => Assets.images.tiles.road.path,
      TileType.roadS => Assets.images.tiles.roadS.path,
      TileType.roadW => Assets.images.tiles.roadW.path,
      TileType.roadN => Assets.images.tiles.roadN.path,
      TileType.roadE => Assets.images.tiles.roadE.path,
      TileType.roadNE => Assets.images.tiles.roadNE.path,
      TileType.roadSE => Assets.images.tiles.roadSE.path,
      TileType.roadSN => Assets.images.tiles.roadSN.path,
      TileType.roadSW => Assets.images.tiles.roadSW.path,
      TileType.roadWE => Assets.images.tiles.roadWE.path,
      TileType.roadWN => Assets.images.tiles.roadWN.path,
      TileType.roadESW => Assets.images.tiles.roadESW.path,
      TileType.roadNES => Assets.images.tiles.roadNES.path,
      TileType.roadSWN => Assets.images.tiles.roadSWN.path,
      TileType.roadWNE => Assets.images.tiles.roadWNE.path,
      TileType.roadSWNE => Assets.images.tiles.roadSWNE.path,
      TileType.grass => Assets.images.tiles.grass.path,
    };
  }

  bool get doesConnect {
    if (name.contains('road')) {
      return true;
    } else {
      return false;
    }
  }
}
