import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/city/city.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
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
  bool isTileBuildable({required Point<int> dimetricTilePos, required Building building}) {
    Tile? tile = getTileAtDimetricCoordinates(dimetricTilePos);
    if (tile == null) return false;
    if (tile.isBuildingConstructible && (tile.listOnlyBuildingsAllowed.isEmpty || tile.listOnlyBuildingsAllowed.contains(building.buildingType))) {
      if (building.buildingType == BuildingType.garbageLoader) {
        if (tile.isLoadPoint || tile.isUnLoadPoint) {
          Directions directionToPoint = world.convertRotations.rotateDirections(tile.loadPointDirection ?? tile.unLoadPointDirection ?? Directions.E);

          GarbageLoaderFlow garbageLoaderFlow = (tile.isLoadPoint) ? GarbageLoaderFlow.flowStandard : GarbageLoaderFlow.flowMirror;

          if (ref.read(constructionModeControllerProvider).buildingDirection != directionToPoint) {
            Future.delayed(const Duration(milliseconds: 10)).then((value) {
              ref.read(constructionModeControllerProvider.notifier).rotateBuildingToDirection(directionToPoint);
            });
          }

          if (ref.read(constructionModeControllerProvider).garbageLoaderFlow != garbageLoaderFlow) {
            Future.delayed(const Duration(milliseconds: 15)).then((value) {
              ref.read(constructionModeControllerProvider.notifier).changeFlowDirection(garbageLoaderFlow);
            });
          }

          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
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
    Building building = createBuilding(
        buildingType: constructionState.buildingType ?? BuildingType.garbageLoader,
        direction: constructionState.buildingDirection,
        anchorTile: coordinates,
        garbageLoaderFlow: constructionState.garbageLoaderFlow);
    (game.findByKeyName('level') as Level).money.addValue(-building.buildingCost);
    world.buildings.add(building);
    await world.add(building);
    building.setPosition(coordinates);
    building.setDirection(constructionState.buildingDirection ?? Directions.E);
    building.initialize();
    markTilesAsBuilt(world.convertRotations.rotateCoordinates(coordinates), building);
  }

  Future<void> internalBuildOnTile(
      {required Point<int> coordinates,
      required BuildingType buildingType,
      required Directions direction,
      bool hideMoney = false,
      CityType cityType = CityType.normal,
      GarbageLoaderFlow garbageLoaderFlow = GarbageLoaderFlow.flowStandard}) async {
    Building building = createBuilding(buildingType: buildingType, direction: direction, anchorTile: coordinates, cityType: cityType, garbageLoaderFlow: garbageLoaderFlow);
    //(game.findByKeyName('level') as Level).money.addValue(-building.buildingCost, hideMoney);
    world.buildings.add(building);
    await world.add(building);
    building.setPosition(coordinates);
    building.setDirection(direction);
    building.initialize();
    markTilesAsBuilt(world.convertRotations.rotateCoordinates(coordinates), building);
  }

  ///
  ///
  /// Register build on tile
  void markTilesAsBuilt(Point<int> coordinates, Building building) {
    int buildingSizeInTileX = building.sizeInTile.x;
    int buildingSizeInTileY = building.sizeInTile.y;
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

    /// INCINERATOR - RECYCLER
    else if (building.buildingType == BuildingType.incinerator || building.buildingType == BuildingType.recycler) {
      for (int i = 0; i < buildingSizeInTileX; i++) {
        for (int j = 0; j < buildingSizeInTileY; j++) {
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
              ..listConnectionRestriction = [world.convertRotations.unRotateDirections(Directions.N), world.convertRotations.unRotateDirections(Directions.S)];
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
      for (int i = 0; i < buildingSizeInTileX; i++) {
        for (int j = 0; j < buildingSizeInTileY; j++) {
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
              ]
              ..isGarageTile = true;
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadS, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.W && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.S),
              ]
              ..isGarageTile = true;
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadW, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.N && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.E),
                world.convertRotations.unRotateDirections(Directions.W),
              ]
              ..isGarageTile = true;
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadN, isIndestructible: true, hideMoney: true);
          } else if (buildingDirection == Directions.E && Point<int>(-i, j) == const Point<int>(-1, 1)) {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))
              ?..markAsBuiltAndConstructibleAndBuildingIndestructible(building)
              ..listConnectionRestriction = [
                world.convertRotations.unRotateDirections(Directions.N),
                world.convertRotations.unRotateDirections(Directions.S),
                world.convertRotations.unRotateDirections(Directions.W),
              ]
              ..isGarageTile = true;
            world.constructionController.construct(posDimetric: coordinates + Point<int>(-i, j), tileType: TileType.roadE, isIndestructible: true, hideMoney: true);
          } else {
            getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuiltAndIndestructible(building);
          }
        }
      }
    }

    /// CITY
    else if (building.buildingType == BuildingType.city) {
      for (int i = 0; i < buildingSizeInTileX; i++) {
        for (int j = 0; j < buildingSizeInTileY; j++) {
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j)));
          getTileAtDimetricCoordinates(coordinates + Point<int>(-i, j))?.markAsBuiltAndIndestructible(building);
        }
      }
      switch (buildingDirection) {
        case Directions.S:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, -1))
            ?..setTileType(TileType.arrowS)
            ..defaultTyleType = TileType.arrowS
            ..marksAsLoadPoint(buildingDirection);
        case Directions.W:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-3, 1))
            ?..setTileType(TileType.arrowW)
            ..defaultTyleType = TileType.arrowW
            ..marksAsLoadPoint(buildingDirection);
        case Directions.N:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 3))
            ?..setTileType(TileType.arrowN)
            ..defaultTyleType = TileType.arrowN
            ..marksAsLoadPoint(buildingDirection);
        case Directions.E:
          getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 1))
            ?..setTileType(TileType.arrowE)
            ..defaultTyleType = TileType.arrowE
            ..marksAsLoadPoint(buildingDirection);
      }
    }

    /// BURYER
    else if (building.buildingType == BuildingType.buryer) {
      building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 0)));
      getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 0))?.markAsBuilt(building);

      Tile? tileToMarkAsArrow;

      switch (buildingDirection) {
        case Directions.S:
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 1)));
          getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 1))?.markAsBuilt(building);

          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(0, -1));
          break;

        case Directions.W:
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 0)));
          getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 0))?.markAsBuilt(building);

          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 0));
          break;

        case Directions.N:
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(0, -1)));
          getTileAtDimetricCoordinates(coordinates + const Point<int>(0, -1))?.markAsBuilt(building);

          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 1));
          break;

        case Directions.E:
          building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 0)));
          getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 0))?.markAsBuilt(building);

          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 0));
          break;
      }

      Directions unRotatedBuildingDirection = world.convertRotations.unRotateDirections(buildingDirection);
      switch (unRotatedBuildingDirection) {
        case Directions.S:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowN)
            ..defaultTyleType = TileType.arrowN
            ..markAsUnloadPoint(Directions.N);
          break;

        case Directions.W:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowE)
            ..defaultTyleType = TileType.arrowE
            ..markAsUnloadPoint(Directions.E);
          break;

        case Directions.N:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowS)
            ..defaultTyleType = TileType.arrowS
            ..markAsUnloadPoint(Directions.S);
          break;

        case Directions.E:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowW)
            ..defaultTyleType = TileType.arrowW
            ..markAsUnloadPoint(Directions.W);
          break;
      }
    }

    /// COMPOSTER
    else if (building.buildingType == BuildingType.composter) {
      building.tilesIAmOn.add(getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 0)));
      getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 0))?.markAsBuilt(building);

      Tile? tileToMarkAsArrow;

      switch (buildingDirection) {
        case Directions.S:
          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(0, -1));
          break;
        case Directions.W:
          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(-1, 0));
          break;
        case Directions.N:
          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(0, 1));
          break;
        case Directions.E:
          tileToMarkAsArrow = getTileAtDimetricCoordinates(coordinates + const Point<int>(1, 0));
          break;
      }

      Directions unRotatedBuildingDirection = world.convertRotations.unRotateDirections(buildingDirection);
      switch (unRotatedBuildingDirection) {
        case Directions.S:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowN)
            ..defaultTyleType = TileType.arrowN
            ..markAsUnloadPoint(Directions.N);
          break;

        case Directions.W:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowE)
            ..defaultTyleType = TileType.arrowE
            ..markAsUnloadPoint(Directions.E);
          break;

        case Directions.N:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowS)
            ..defaultTyleType = TileType.arrowS
            ..markAsUnloadPoint(Directions.S);
          break;

        case Directions.E:
          tileToMarkAsArrow
            ?..setTileType(TileType.arrowW)
            ..defaultTyleType = TileType.arrowW
            ..markAsUnloadPoint(Directions.W);
          break;
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
