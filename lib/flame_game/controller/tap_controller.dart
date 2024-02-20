import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../game.dart';
import '../ui/mouse_cursor.dart';
import '../ui/overlay/overlay_dialog.dart';

class TapController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  void onTapDown(TapDownInfo info) {
    if (!ref.read(overlayControllerProvider).isVisible) {
      if (!game.isMouseHoveringUI) {
        final constructionState = ref.read(constructionModeControllerProvider);

        if (constructionState.status == ConstructionMode.construct) {
          if (constructionState.tileType != null) {
            game.constructionController.construct(posDimetric: game.currentMouseTilePos, tileType: constructionState.tileType!);
            game.cursorController.hasConstructed = true;
          }
          if (constructionState.buildingType != null) {
            game.buildingController.tryToBuildCurrentBuilding();
          }
        } else if (constructionState.status == ConstructionMode.destruct) {
          game.constructionController.destroy(posDimetric: game.currentMouseTilePos);
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
    if (ref.read(constructionModeControllerProvider).status == ConstructionMode.destruct) {
      game.gridController.getBuildingOnTile(game.currentMouseTilePos)?.resetColor();
    }
    ref.read(activeUIButtonControllerProvider.notifier).onSecondaryTapUp();
  }

  void onTertiaryTapDown(TapDownInfo info) {
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
