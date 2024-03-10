import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../game.dart';
import '../tile/tile.dart';
import '../tile/tile_helper.dart';
import '../utils/convert_rotations.dart';

class ConstructionController extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  void construct({required Point<int> posDimetric, required TileType tileType, bool isMouseDragging = false, bool isIndestructible = false, bool isLoader = false, bool hideMoney = false}) {
    if (world.gridController.checkIfWithinGridBoundaries(posDimetric)) {
      world.gridController
          .getTileAtDimetricCoordinates(posDimetric)
          ?.constructTile(tileType: tileType, isMouseDragging: isMouseDragging, isIndestructible: isIndestructible, isLoader: isLoader, hideMoney: hideMoney);

      Map<Directions, Tile?> mapNeighbors = world.gridController.getAllNeigbhorsTile(world.gridController.getTileAtDimetricCoordinates(posDimetric));

      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
        tile?.propagateTileChange();
      }
    }
  }

  void destroy({required Point<int> posDimetric, bool isMouseDragging = false}) {
    Tile? tile = world.gridController.getTileAtDimetricCoordinates(posDimetric);

    /// Destroy tile
    tile?.destroyTile();

    Map<Directions, Tile?> mapNeighbors = world.gridController.getAllNeigbhorsTile(tile);
    for (Tile? tile in mapNeighbors.values) {
      tile?.projectTileChange();
      tile?.propagateTileChange();
    }
  }

  void destroyBuilding({required Point<int> posDimetric, bool isMouseDragging = false}) {
    Tile? tile = world.gridController.getTileAtDimetricCoordinates(posDimetric);

    /// Destroy building on tile
    if (tile?.buildingOnTile != null) {
      world.taskController.buildingDestroyed(tile!.buildingOnTile!);

      world.remove(tile.buildingOnTile!);
      world.buildings.remove(tile.buildingOnTile);
      for (Tile? element in tile.buildingOnTile!.tilesIAmOn) {
        element?.destroyBuilding();
        element?.resetTileRestriction();
      }
    }
  }

  ///
  ///
  /// Project construction on current Tile and Current Neighbors
  ///

  void resetTile(Point<int> posDimetric) {
    world.gridController.getTileAtDimetricCoordinates(posDimetric)?.resetTileAfterProjection();
  }

  void projectConstructionOnTileAndNeighbors(Point<int> dimetricTilePos) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct) {
      world.gridController.getTileAtDimetricCoordinates(dimetricTilePos)?.projectTileConstruction(ref.read(constructionModeControllerProvider).tileType);
    } else if (constructionState.status == ConstructionMode.destruct) {
      world.gridController.getTileAtDimetricCoordinates(dimetricTilePos)?.changeTileToWantToDestroy();
    }

    if (constructionState.status == ConstructionMode.construct || constructionState.status == ConstructionMode.destruct) {
      Map<Directions, Tile?> mapNeighbors = world.gridController.getAllNeigbhorsTile(world.gridController.getTileAtDimetricCoordinates(dimetricTilePos));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
      }
    }
  }
}
