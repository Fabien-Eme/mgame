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
      world.grid[posGrid.x][posGrid.y].construct(tileType: tileType, isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(posDimetric));

      for (Tile? tile in mapNeighbors.values) {
        tile?.propagateTileChange();
      }
    }
  }

  void destroy({required Vector2 posDimetric, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridPoint(posDimetric);
    if (game.gridController.checkIfWithinGridBoundaries(posGrid)) {
      world.grid[posGrid.x][posGrid.y].destroy(isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(posDimetric));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
        tile?.propagateTileChange();
      }
    }
  }

  void projectConstructionOnTile(Point<int> posGrid) {
    world.grid[posGrid.x][posGrid.y].projectConstruction(ref.read(constructionModeControllerProvider).tileType);
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
}
