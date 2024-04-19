import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../game.dart';
import '../tile/tile.dart';
import '../utils/convert_coordinates.dart';
import '../utils/convert_rotations.dart';

class CursorController extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  bool hasConstructed = false;
  bool hasbuild = false;

  void cursorIsMovingOnNewTile(Point<int> newMouseTilePos) {
    ConstructionState constructionState = ref.read(constructionModeControllerProvider);

    /// Reset previous Tile if construction mode
    if (constructionState.status == ConstructionMode.construct) {
      world.constructionController.resetTile(world.currentMouseTilePos);
    }
    if (constructionState.status == ConstructionMode.destruct) {
      world.gridController.getBuildingOnTile(world.currentMouseTilePos)?.resetColor();
    }

    /// If Player as constructed a road, keep neighbors change, otherwise discard change
    _keepOrDiscardNeighborsChanges();

    /// Trigger only if cursor is on World grid
    if (world.gridController.checkIfWithinGridBoundaries(newMouseTilePos)) {
      /// Change mouse cursor appearance
      if (world.gridController.getTileAtDimetricCoordinates(newMouseTilePos)?.buildingOnTile != null) {
        if (constructionState.status != ConstructionMode.construct && constructionState.status != ConstructionMode.destruct) {
          game.isMouseHoveringBuilding = world.gridController.getTileAtDimetricCoordinates(newMouseTilePos)?.buildingOnTile;
          game.myMouseCursor.hoverEnterButton();
        } else {
          game.isMouseHoveringBuilding = null;
          game.myMouseCursor.resetMouseCursor();
        }
      } else {
        game.isMouseHoveringBuilding = null;
        game.myMouseCursor.resetMouseCursor();
      }

      /// Move Cursor to current Tile
      world.tileCursor.changePosition(convertDimetricPointToWorldCoordinates(newMouseTilePos));

      /// Handle Road construction by dragging
      _handleRoadConstructionByDragging();

      /// Handle building
      world.buildingController.projectBuildingOnTile(newMouseTilePos);

      /// Project construction on current Tile and Current Neighbors
      world.constructionController.projectConstructionOnTileAndNeighbors(newMouseTilePos);
    }

    /// Store current Tile to access it next move
    world.currentMouseTilePos = newMouseTilePos;
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
      Map<Directions, Tile?> mapPrecedentNeighbors = world.gridController.getAllNeigbhorsTile(world.gridController.getTileAtDimetricCoordinates(world.currentMouseTilePos));
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
          world.constructionController.construct(posDimetric: world.currentMouseTilePos, tileType: constructionState.tileType!, isMouseDragging: true);
          Map<Directions, Tile?> mapNeighbors = world.gridController.getAllNeigbhorsTile(world.gridController.getTileAtDimetricCoordinates(world.currentMouseTilePos));
          for (Tile? tile in mapNeighbors.values) {
            tile?.projectTileChange();
            tile?.propagateTileChange();
          }
          hasConstructed = true;
        }
      } else if (constructionState.status == ConstructionMode.destruct && world.gridController.isTileDestructible(world.currentMouseTilePos)) {
        world.constructionController.destroy(posDimetric: world.currentMouseTilePos, isMouseDragging: true);
      }
    }
  }
}
