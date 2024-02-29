import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/ui/mouse_cursor.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/convert_coordinates.dart';
import '../utils/convert_rotations.dart';

class CursorController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  bool hasConstructed = false;
  bool hasbuild = false;

  void cursorIsMovingOnNewTile(Point<int> newMouseTilePos) {
    ConstructionState constructionState = ref.read(constructionModeControllerProvider);

    /// Reset previous Tile if construction mode
    if (constructionState.status == ConstructionMode.construct) {
      game.constructionController.resetTile(game.currentMouseTilePos);
    }
    if (constructionState.status == ConstructionMode.destruct) {
      game.gridController.getBuildingOnTile(game.currentMouseTilePos)?.resetColor();
    }

    /// If Player as constructed a road, keep neighbors change, otherwise discard change
    _keepOrDiscardNeighborsChanges();

    /// Trigger only if cursor is on World grid
    if (game.gridController.checkIfWithinGridBoundaries(newMouseTilePos)) {
      /// Change mouse cursor appearance
      if (game.gridController.getTileAtDimetricCoordinates(newMouseTilePos)?.buildingOnTile != null) {
        if (constructionState.status != ConstructionMode.construct && constructionState.status != ConstructionMode.destruct) {
          game.isMouseHoveringBuilding = true;
          game.myMouseCursor.changeMouseCursorType(MouseCursorType.hand);
          world.tileCursor.hideTileCursor();
        } else {
          game.isMouseHoveringBuilding = false;
          game.myMouseCursor.resetMouseCursor();
          world.tileCursor.showTileCursor();
        }
      } else {
        game.isMouseHoveringBuilding = false;
        game.myMouseCursor.resetMouseCursor();
        world.tileCursor.showTileCursor();
      }

      /// Move Cursor to current Tile
      world.tileCursor.changePosition(convertDimetricPointToWorldCoordinates(newMouseTilePos));

      /// Handle Road construction by dragging
      _handleRoadConstructionByDragging();

      /// Handle building
      game.buildingController.projectBuildingOnTile(newMouseTilePos);

      /// Project construction on current Tile and Current Neighbors
      game.constructionController.projectConstructionOnTileAndNeighbors(newMouseTilePos);
    }

    /// Store current Tile to access it next move
    game.currentMouseTilePos = newMouseTilePos;
  }

  ///
  ///
  ///
  ///

  ///
  ///
  /// If Player as constructed a road, keep neighbors change, otherwise discard change
  ///
  void _keepOrDiscardNeighborsChanges() {
    if (hasConstructed) {
      hasConstructed = false;
    } else {
      Map<Directions, Tile?> mapPrecedentNeighbors = game.gridController.getAllNeigbhorsTile(game.gridController.getTileAtDimetricCoordinates(game.currentMouseTilePos));
      for (Tile? tile in mapPrecedentNeighbors.values) {
        tile?.cancelProjectedTileChange();
      }
    }
  }

  ///
  ///
  /// Handle Road construction by dragging
  ///
  void _handleRoadConstructionByDragging() {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (game.isMouseDragging) {
      if (constructionState.status == ConstructionMode.construct) {
        if (constructionState.tileType != null) {
          game.constructionController.construct(posDimetric: game.currentMouseTilePos, tileType: constructionState.tileType!, isMouseDragging: true);
          Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(game.gridController.getTileAtDimetricCoordinates(game.currentMouseTilePos));
          for (Tile? tile in mapNeighbors.values) {
            tile?.projectTileChange();
            tile?.propagateTileChange();
          }
          hasConstructed = true;
        }
      } else if (constructionState.status == ConstructionMode.destruct && game.gridController.isTileDestructible(game.currentMouseTilePos)) {
        game.constructionController.destroy(posDimetric: game.currentMouseTilePos, isMouseDragging: true);
      }
    }
  }
}
