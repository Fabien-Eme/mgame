import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';
import 'package:mgame/flame_game/tile/tile_helper.dart';

import '../buildings/city/city.dart';
import '../game.dart';

class TapController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  ///
  ///
  /// PRIMARY TAP
  void onTapDown(TapDownInfo info) {
    if (!game.isMouseHoveringUI) {
      /// Show menu if click on building
      if (game.isMouseHoveringBuilding != null) {
        game.myMouseCursor.hoverExitButton();
        game.isMouseHoveringBuilding?.select();
        switch (game.isMouseHoveringBuilding?.buildingType) {
          case BuildingType.garage:
            game.router.pushNamed('menuGarage');
            break;
          case BuildingType.city:
            game.currentCity = (game.isMouseHoveringBuilding! as City);
            game.router.pushNamed('menuCity');
            break;
          case BuildingType.incinerator:
            game.currentIncinerator = (game.isMouseHoveringBuilding! as Incinerator);
            game.router.pushNamed('menuIncinerator');
            break;
          default:
            break;
        }
        game.isMouseHoveringBuilding = null;
      } else {
        final constructionState = ref.read(constructionModeControllerProvider);

        if (constructionState.status == ConstructionMode.construct) {
          if (constructionState.tileType != null) {
            world.constructionController.construct(posDimetric: world.currentMouseTilePos, tileType: constructionState.tileType ?? TileType.road);
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
  void onTertiaryTapDown([TapDownInfo? info]) {
    if (ref.read(constructionModeControllerProvider).buildingType != null) {
      ref.read(constructionModeControllerProvider.notifier).rotateBuilding();
    }
  }
}
