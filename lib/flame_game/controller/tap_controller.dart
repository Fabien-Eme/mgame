import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../game.dart';

class TapController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  ///
  ///
  /// PRIMARY TAP
  void onTapDown(TapDownInfo info) {
    if (!game.isMouseHoveringUI) {
      final constructionState = ref.read(constructionModeControllerProvider);

      if (constructionState.status == ConstructionMode.construct) {
        if (constructionState.tileType != null) {
          world.constructionController.construct(posDimetric: world.currentMouseTilePos, tileType: constructionState.tileType!);
          world.cursorController.hasConstructed = true;
        }
        if (constructionState.buildingType != null) {
          world.buildingController.tryToBuildCurrentBuilding();
        }
      } else if (constructionState.status == ConstructionMode.destruct) {
        if (world.gridController.isTileBuildingDestructible(world.currentMouseTilePos)) {
          world.constructionController.destroyBuilding(posDimetric: world.currentMouseTilePos);
        }
        if (world.gridController.isTileDestructible(world.currentMouseTilePos)) {
          world.constructionController.destroy(posDimetric: world.currentMouseTilePos);
        }
      }
    }

    /// Show menu if click on building
    if (game.isMouseHoveringBuilding) {
      game.isMouseHoveringBuilding = false;
      game.myMouseCursor.hoverExitButton();
      game.router.pushNamed('menuGarage');
    }
  }

  ///
  ///
  /// SECONDARY TAP
  void onSecondaryTapUp(TapUpInfo info) {
    if (ref.read(constructionModeControllerProvider).status == ConstructionMode.destruct) {
      world.gridController.getBuildingOnTile(world.currentMouseTilePos)?.resetColor();
    }
    ref.read(activeUIButtonControllerProvider.notifier).onSecondaryTapUp();
  }

  ///
  ///
  /// TERTIARY TAP
  void onTertiaryTapDown(TapDownInfo info) {
    if (ref.read(constructionModeControllerProvider).buildingType != null) {
      ref.read(constructionModeControllerProvider.notifier).rotateBuilding();
    }
  }
}
