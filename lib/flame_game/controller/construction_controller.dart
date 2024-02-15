import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../game.dart';
import '../tile.dart';
import '../tile_helper.dart';
import '../utils/convert_rotations.dart';

class ConstructionController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  void construct({required Point<int> posDimetric, required TileType tileType, bool isMouseDragging = false}) {
    if (game.gridController.checkIfWithinGridBoundaries(posDimetric)) {
      game.gridController.getTileAtDimetricCoordinates(posDimetric)?.constructTile(tileType: tileType, isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(game.gridController.getTileAtDimetricCoordinates(posDimetric));

      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
        tile?.propagateTileChange();
      }
    }
  }

  void destroy({required Point<int> posDimetric, bool isMouseDragging = false}) {
    Tile? tile = game.gridController.getTileAtDimetricCoordinates(posDimetric);

    /// Destroy tile
    tile?.destroyTile();

    Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(game.gridController.getTileAtDimetricCoordinates(posDimetric));
    for (Tile? tile in mapNeighbors.values) {
      tile?.projectTileChange();
      tile?.propagateTileChange();
    }

    /// Destroy building on tile

    if (tile?.buildingOnTile != null) {
      world.remove(tile!.buildingOnTile!);
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
    game.gridController.getTileAtDimetricCoordinates(posDimetric)?.resetTileAfterProjection();
  }

  void projectConstructionOnTileAndNeighbors(Point<int> dimetricTilePos) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct) {
      game.gridController.getTileAtDimetricCoordinates(dimetricTilePos)?.projectTileConstruction(ref.read(constructionModeControllerProvider).tileType);
    } else if (constructionState.status == ConstructionMode.destruct) {
      game.gridController.getTileAtDimetricCoordinates(dimetricTilePos)?.changeTileToWantToDestroy();
    }

    if (constructionState.status == ConstructionMode.construct || constructionState.status == ConstructionMode.destruct) {
      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(game.gridController.getTileAtDimetricCoordinates(dimetricTilePos));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
      }
    }
  }
}
