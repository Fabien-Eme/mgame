import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/tile/tile_helper.dart';

import '../game.dart';
import '../level.dart';
import '../level_world.dart';
import '../tile/tile.dart';
import '../utils/convert_coordinates.dart';
import '../utils/convert_rotations.dart';

class GridController extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  Map<Directions, Tile?> getAllNeigbhorsTile(Tile? tile) {
    if (tile == null) return {};
    return {
      Directions.S: getNeigbhorTile(tile, Directions.S),
      Directions.W: getNeigbhorTile(tile, Directions.W),
      Directions.N: getNeigbhorTile(tile, Directions.N),
      Directions.E: getNeigbhorTile(tile, Directions.E),
    };
  }

  Tile? getNeigbhorTile(Tile tile, Directions direction) {
    Point<int> neighborDimetricPoint = switch (direction) {
      Directions.S => Point(tile.dimetricCoordinates.x, tile.dimetricCoordinates.y - 1),
      Directions.W => Point(tile.dimetricCoordinates.x - 1, tile.dimetricCoordinates.y),
      Directions.N => Point(tile.dimetricCoordinates.x, tile.dimetricCoordinates.y + 1),
      Directions.E => Point(tile.dimetricCoordinates.x + 1, tile.dimetricCoordinates.y),
    };

    if (checkIfWithinGridBoundaries(neighborDimetricPoint)) {
      Point<int> neighborGridPoint = convertDimetricPointToGridPoint(neighborDimetricPoint);

      return world.grid[neighborGridPoint.x][neighborGridPoint.y];
    } else {
      return null;
    }
  }

  Directions? getNeigbhorTileDirection({required Tile me, required Tile neighbor}) {
    Point<int> offset = me.dimetricCoordinates - neighbor.dimetricCoordinates;
    if (offset == const Point<int>(0, 1)) {
      return Directions.S;
    }
    if (offset == const Point<int>(1, 0)) {
      return Directions.W;
    }
    if (offset == const Point<int>(0, -1)) {
      return Directions.N;
    }
    if (offset == const Point<int>(-1, 0)) {
      return Directions.E;
    }
    return null;
  }

  ///
  ///
  ///Method to check if Vector2 is within grid boundaries
  ///
  bool checkIfWithinGridBoundaries(Point<int> dimetricCoordinates) {
    Point<int> posGrid = convertDimetricPointToGridPoint(dimetricCoordinates);
    if (posGrid.x >= 0 && posGrid.x < (world.grid.length) && posGrid.y >= 0 && posGrid.y < (world.grid[posGrid.x]).length) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///
  /// Check if Tile is buildable
  ///
  bool isTileBuildable({required Point<int> dimetricTilePos, required BuildingType buildingType}) {
    Tile? tile = getTileAtDimetricCoordinates(dimetricTilePos);
    if (tile == null) return false;
    if (tile.isBuildingConstructible && (tile.listOnlyBuildingsAllowed.isEmpty || tile.listOnlyBuildingsAllowed.contains(buildingType))) {
      return true;
    } else {
      return false;
    }
  }

  bool isTileBuildingDestructible(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.isBuildingDestructible ?? false;
  }

  bool isTileDestructible(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.isTileDestructible ?? false;
  }

  bool isBuildingOnTile(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.buildingOnTile != null;
  }

  Building? getBuildingOnTile(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.buildingOnTile;
  }

  Future<void> buildOnTile(Point<int> coordinates, ConstructionState constructionState) async {
    Building building = createBuilding(buildingType: constructionState.buildingType!, direction: constructionState.buildingDirection, anchorTile: coordinates);
    (game.findByKeyName('level') as Level).money.addValue(-building.buildingCost);
    world.buildings.add(building);
    await world.add(building);
    building.setPosition(coordinates);
    building.setDirection(constructionState.buildingDirection!);
    building.initialize();
    markTilesAsBuilt(world.convertRotations.rotateCoordinates(coordinates), building);
  }

  Future<void> internalBuildOnTile(Point<int> coordinates, BuildingType buildingType, Directions direction, [bool hideMoney = false]) async {
    Building building = createBuilding(buildingType: buildingType, direction: direction, anchorTile: coordinates);
    (game.findByKeyName('level') as Level).money.addValue(-building.buildingCost, hideMoney);
    world.buildings.add(building);
    await world.add(world.buildings.last);
    world.buildings.last.setPosition(coordinates);
    world.buildings.last.setDirection(direction);
    building.initialize();
    markTilesAsBuilt(world.convertRotations.rotateCoordinates(coordinates), building);
  }

  void markTilesAsBuilt(Point<int> coordinates, Building building) {
    int buildingSizeInTile = building.sizeInTile;
    Directions buildingDirection = world.convertRotations.rotateDirections(building.direction);

    /// GARBAGE LOADER
    if (building.buildingType == BuildingType.garbageLoader) {
      if (buildingDirection == Directions.E || buildingDirection == Directions.W) {
        getTileAtDimetricCoordinates(coordinates)
          ?..markAsBuiltAndConstructible(building)
          ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.S), world.convertRotations.unRotateDirections(Directions.N)];
        world.constructionController.construct(posDimetric: coordinates, tileType: TileType.road, isLoader: true, hideMoney: true);
      } else {
        getTileAtDimetricCoordinates(coordinates)
          ?..markAsBuiltAndConstructible(building)
          ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.E), world.convertRotations.unRotateDirections(Directions.W)];
        world.constructionController.construct(posDimetric: coordinates, tileType: TileType.road, isLoader: true, hideMoney: true);
      }
      building.tilesIAmOn = [getTileAtDimetricCoordinates(coordinates)];
    }

    /// INCINERATOR
    else if (building.buildingType == BuildingType.incinerator) {
      for (int i = 0; i < buildingSizeInTile; i++) {
        for (int j = 0; j < buildingSizeInTile; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));

          if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 0)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructible(building)
              ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.E), world.convertRotations.unRotateDirections(Directions.W)];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-2, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructible(building)
              ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.N), world.convertRotations.unRotateDirections(Directions.S)];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 2)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructible(building)
              ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.E), world.convertRotations.unRotateDirections(Directions.W)];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(0, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.S),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road, hideMoney: true);
          } else {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuilt(building);
          }
        }
      }
    }

    /// GARAGE
    else if (building.buildingType == BuildingType.garage) {
      for (int i = 0; i < buildingSizeInTile; i++) {
        for (int j = 0; j < buildingSizeInTile; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));

          if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 0)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadN, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-2, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadE, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 2)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadS, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(0, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadW, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadS, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.S),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadW, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadN, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.W),
              ];
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadE, isIndestructible: true, hideMoney: true);
          } else {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuiltAndIndestructible(building);
          }
        }
      }
    }

    /// CITY
    else if (building.buildingType == BuildingType.city) {
      for (int i = 0; i < buildingSizeInTile; i++) {
        for (int j = 0; j < buildingSizeInTile; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));
          getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuiltAndIndestructible(building);
        }
      }
      switch (buildingDirection) {
        case Directions.S:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, -1))
            ?..setTileType(TileType.arrowS)
            ..defaultTyleType = TileType.arrowS
            ..marksAsLoadPoint();
        case Directions.W:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-3, 0))
            ?..setTileType(TileType.arrowW)
            ..defaultTyleType = TileType.arrowW
            ..marksAsLoadPoint();
        case Directions.N:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 3))
            ?..setTileType(TileType.arrowN)
            ..defaultTyleType = TileType.arrowN
            ..marksAsLoadPoint();
        case Directions.E:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 1))
            ?..setTileType(TileType.arrowE)
            ..defaultTyleType = TileType.arrowE
            ..marksAsLoadPoint();
      }
    }
    world.taskController.buildingBuilt(building);
  }

  ///
  ///
  /// Get the Tile at Dimetric coordinates
  ///
  Tile? getTileAtDimetricCoordinates(Point<int>? dimetricCoordinates) {
    if (dimetricCoordinates == null) return null;
    dimetricCoordinates = world.convertRotations.unRotateCoordinates(dimetricCoordinates);
    if (!checkIfWithinGridBoundaries(dimetricCoordinates)) {
      return null;
    } else {
      Point<int> posGrid = convertDimetricPointToGridPoint(dimetricCoordinates);

      return world.grid[posGrid.x][posGrid.y];
    }
  }

  ///
  ///
  /// Get the Tile at Dimetric coordinates Without Unrotating
  ///
  Tile? getRealTileAtDimetricCoordinates(Point<int>? dimetricCoordinates) {
    if (dimetricCoordinates == null) return null;
    if (!checkIfWithinGridBoundaries(dimetricCoordinates)) {
      return null;
    } else {
      Point<int> posGrid = convertDimetricPointToGridPoint(dimetricCoordinates);

      return world.grid[posGrid.x][posGrid.y];
    }
  }
}
