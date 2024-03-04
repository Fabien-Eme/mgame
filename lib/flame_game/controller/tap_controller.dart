import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../game.dart';
import '../ui/overlay/overlay_dialog.dart';

class TapController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  void onTapDown(TapDownInfo info) {
    // world.buildings.last.openDoor();

    if (!ref.read(overlayControllerProvider).isVisible) {
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

      /// Show overlay if click on building
      if (game.isMouseHoveringBuilding) {
        game.isMouseHoveringBuilding = false;
        ref.read(overlayControllerProvider.notifier).overlayOpen(overlayDialogType: OverlayDialogType.garage);
      }
    }
  }

  void onSecondaryTapUp(TapUpInfo info) {
    // world.buildings.last.closeDoor();
    //print(game.aStarController.findPathAStar(const Point(7, -1), const Point(31, 1)));

    if (ref.read(constructionModeControllerProvider).status == ConstructionMode.destruct) {
      world.gridController.getBuildingOnTile(world.currentMouseTilePos)?.resetColor();
    }
    ref.read(activeUIButtonControllerProvider.notifier).onSecondaryTapUp();
  }

  void onTertiaryTapDown(TapDownInfo info) {
    // world.truck.goToTile(game.gridController.getTileAtDimetricCoordinates(const Point<int>(24, 0))!);

    if (ref.read(constructionModeControllerProvider).buildingType != null) {
      ref.read(constructionModeControllerProvider.notifier).rotateBuilding();
    }
    // if (gameBloc.state.tileType == TileType.roadSN) {
    //   gameBloc.add(const ConstructionModePressed(tileType: TileType.roadWE));
    // }
    // if (gameBloc.state.tileType == TileType.roadWE) {
    //   gameBloc.add(const ConstructionModePressed(tileType: TileType.roadSN));
    // }
    // await Future.delayed(const Duration(milliseconds: 10));
    // mouseIsMovingOnNewTile(game.currentMouseTilePos);  }
  }
}
