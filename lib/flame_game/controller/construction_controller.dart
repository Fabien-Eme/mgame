import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/manage_coordinates.dart';

class ConstructionController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  void construct({required Vector2 posDimetric, required TileType tileType, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridPoint(posDimetric);
    if (game.gridController.checkIfWithinGridBoundaries(posGrid)) {
      world.grid[posGrid.x][posGrid.y].constructTile(tileType: tileType, isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(posDimetric));

      for (Tile? tile in mapNeighbors.values) {
        tile?.propagateTileChange();
      }
    }
  }

  void destroy({required Vector2 posDimetric, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridPoint(posDimetric);
    if (game.gridController.checkIfWithinGridBoundaries(posGrid)) {
      world.grid[posGrid.x][posGrid.y].destroyTile(isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(posDimetric));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
        tile?.propagateTileChange();
      }
    }
  }

  ///
  ///
  /// Project construction on current Tile and Current Neighbors
  ///
  void projectConstructionOnTile(Point<int> posGrid) {
    world.grid[posGrid.x][posGrid.y].projectTileConstruction(ref.read(constructionModeControllerProvider).tileType);
  }

  void projectDestructionOnTile(Point<int> posGrid) {
    world.grid[posGrid.x][posGrid.y].changeTileToWantToDestroy();
  }

  void resetTile(Vector2 posDimetric) {
    Point<int> posGrid = convertDimetricToGridPoint(posDimetric);
    if (game.gridController.checkIfWithinGridBoundaries(posGrid)) {
      world.grid[posGrid.x][posGrid.y].resetTileAfterProjection();
    }
  }

  void projectConstructionOnTileAndNeighbors(Vector2 dimetricTilePos) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct) {
      projectConstructionOnTile(convertDimetricToGridPoint(dimetricTilePos));
    } else if (constructionState.status == ConstructionMode.destruct) {
      projectDestructionOnTile(convertDimetricToGridPoint(dimetricTilePos));
    }

    if (constructionState.status == ConstructionMode.construct || constructionState.status == ConstructionMode.destruct) {
      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(dimetricTilePos));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
      }
    }
  }
}
