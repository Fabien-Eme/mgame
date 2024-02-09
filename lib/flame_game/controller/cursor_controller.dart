import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/manage_coordinates.dart';

class CursorController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  bool hasConstructed = false;
  bool hasbuild = false;

  void cursorIsMovingOnNewTile(Vector2 newMouseTilePos) async {
    /// Reset previous Tile if construction mode
    if (ref.read(constructionModeControllerProvider).status == ConstructionMode.construct) {
      game.constructionController.resetTile(game.currentMouseTilePos);
    }

    /// If Player as constructed a road, keep neighbors change, otherwise discard change
    _keepOrDiscardNeighborsChanges();

    /// Handle build
    if (hasbuild) {}

    /// Trigger only if cursor is on World grid
    if (game.gridController.checkIfWithinGridBoundaries(convertDimetricToGridPoint(newMouseTilePos))) {
      /// Handle building
      _handleBuilding(newMouseTilePos);

      /// Handle Road construction by dragging
      _handleRoadConstructionByDragging();

      /// Project construction on current Tile and Current Neighbors
      _projectConstructionOnTileAndNeighbors(newMouseTilePos);

      /// Move Cursor to current Tile
      world.tileCursor.changePosition(convertDimetricToWorldCoordinates(newMouseTilePos));
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
      Map<Directions, Tile?> mapPrecedentNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(game.currentMouseTilePos));
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
          Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(game.currentMouseTilePos));
          for (Tile? tile in mapNeighbors.values) {
            tile?.projectTileChange();
            tile?.propagateTileChange();
          }
          hasConstructed = true;
        }
      } else if (constructionState.status == ConstructionMode.destruct) {
        game.constructionController.destroy(posDimetric: game.currentMouseTilePos, isMouseDragging: true);
      }
    }
  }

  ///
  ///
  /// Project construction on current Tile and Current Neighbors
  ///
  void _projectConstructionOnTileAndNeighbors(Vector2 newMouseTilePos) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct) {
      game.constructionController.projectConstructionOnTile(convertDimetricToGridPoint(newMouseTilePos));
    } else if (constructionState.status == ConstructionMode.destruct) {
      game.constructionController.projectDestructionOnTile(convertDimetricToGridPoint(newMouseTilePos));
    }

    if (constructionState.status == ConstructionMode.construct || constructionState.status == ConstructionMode.destruct) {
      Map<Directions, Tile?> mapNeighbors = game.gridController.getAllNeigbhorsTile(dimetricGridPoint: convertVectorToPoint(newMouseTilePos));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
      }
    }
  }

  ///
  ///
  /// Handle Building
  ///
  void _handleBuilding(Vector2 newMouseTilePos) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct && constructionState.buildingType != null) {
      if (world.temporaryBuilding == null) {
        world.temporaryBuilding = Incinerator(direction: Directions.E, position: convertDimetricToWorldCoordinates(newMouseTilePos));
        world.add(world.temporaryBuilding!);
      } else {
        world.temporaryBuilding!.changePosition(convertDimetricToWorldCoordinates(newMouseTilePos));
      }
    }
  }
}
