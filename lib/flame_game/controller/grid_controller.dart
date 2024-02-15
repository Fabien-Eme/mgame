import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/tile_helper.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/convert_coordinates.dart';
import '../utils/convert_rotations.dart';

class GridController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
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

  Directions? getNeigbhorTileDirection(Tile me, Tile neighbor) {
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
  bool isTileBuildable(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.isBuildingConstructible ?? false;
  }

  bool isBuildingOnTile(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.buildingOnTile != null;
  }

  Building? getBuildingOnTile(Point<int> dimetricTilePos) {
    return getTileAtDimetricCoordinates(dimetricTilePos)?.buildingOnTile;
  }

  Future<void> buildOnTile(Point<int> coordinates, ConstructionState constructionState) async {
    Building building = createBuilding(buildingType: constructionState.buildingType!, direction: constructionState.buildingDirection, anchorTile: coordinates);
    world.buildings.add(building);
    await world.add(world.buildings.last);
    world.buildings.last.setPosition(coordinates);
    world.buildings.last.setDirection(constructionState.buildingDirection!);
    markTilesAsBuilt(game.convertRotations.rotateCoordinates(coordinates), building);
  }

  Future<void> internalBuildOnTile(Point<int> coordinates, BuildingType buildingType, Directions direction) async {
    Building building = createBuilding(buildingType: buildingType, direction: direction, anchorTile: coordinates);
    world.buildings.add(building);
    await world.add(world.buildings.last);
    world.buildings.last.setPosition(coordinates);
    world.buildings.last.setDirection(direction);
    markTilesAsBuilt(game.convertRotations.rotateCoordinates(coordinates), building);
  }

  void markTilesAsBuilt(Point<int> coordinates, Building building) {
    int buildingSizeInTile = building.sizeInTile;
    Directions buildingDirection = game.convertRotations.rotateDirections(building.direction);

    if (building.buildingType == BuildingType.garbageLoader) {
      if (buildingDirection == Directions.E || buildingDirection == Directions.W) {
        getTileAtDimetricCoordinates(coordinates)
          ?..markAsBuiltButStillConstructible(building)
          ..listConnectionRestriction = [game.convertRotations.unRotateDirections(Directions.S), game.convertRotations.unRotateDirections(Directions.N)];
        game.constructionController.construct(posDimetric: coordinates, tileType: TileType.road);
      } else {
        getTileAtDimetricCoordinates(coordinates)
          ?..markAsBuiltButStillConstructible(building)
          ..listConnectionRestriction = [game.convertRotations.unRotateDirections(Directions.E), game.convertRotations.unRotateDirections(Directions.W)];
        game.constructionController.construct(posDimetric: coordinates, tileType: TileType.road);
      }
      building.tilesIAmOn = [getTileAtDimetricCoordinates(coordinates)];
    } else if (building.buildingType == BuildingType.incinerator) {
      for (int i = 0; i < buildingSizeInTile; i++) {
        for (int j = 0; j < buildingSizeInTile; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));

          if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 0)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W)
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-2, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.S)
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 2)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.S),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W)
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(0, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.S),
                game.convertRotations.unRotateDirections(Directions.W)
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.road);
          } else {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuilt(building);
          }
        }
      }
    } else if (building.buildingType == BuildingType.garage) {
      for (int i = 0; i < buildingSizeInTile; i++) {
        for (int j = 0; j < buildingSizeInTile; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));

          if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 0)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadN);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-2, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.S),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadE);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 2)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadS);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(0, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.S),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadW);
          } else if (buildingDirection == Directions.S && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadS);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.S),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadW);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.S),
                game.convertRotations.unRotateDirections(Directions.E),
                game.convertRotations.unRotateDirections(Directions.W),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadN);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltButStillConstructible(building)
              ..listConnectionRestriction = [
                game.convertRotations.unRotateDirections(Directions.N),
                game.convertRotations.unRotateDirections(Directions.S),
                game.convertRotations.unRotateDirections(Directions.W),
              ];
            game.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadE);
          } else {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuilt(building);
          }
        }
      }
    }
  }

  ///
  ///
  /// Get the Tile at Dimetric coordinates
  ///
  Tile? getTileAtDimetricCoordinates(Point<int> dimetricCoordinates) {
    dimetricCoordinates = game.convertRotations.unRotateCoordinates(dimetricCoordinates);
    if (!checkIfWithinGridBoundaries(dimetricCoordinates)) {
      return null;
    } else {
      Point<int> posGrid = convertDimetricPointToGridPoint(dimetricCoordinates);

      return world.grid[posGrid.x][posGrid.y];
    }
  }
}
