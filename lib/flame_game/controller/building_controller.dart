import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../buildings/building.dart';
import '../game.dart';
import '../palette.dart';
import '../riverpod_controllers/construction_mode_controller.dart';
import '../utils/manage_coordinates.dart';

class BuildingController extends Component with HasGameReference<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  ///
  ///
  /// Project selected building on Tile while mouving mouse
  ///
  Future<void> projectBuildingOnTile(Vector2 dimetricTilePos) async {
    final constructionState = ref.read(constructionModeControllerProvider);

    ///Project the building
    if (constructionState.status == ConstructionMode.construct && constructionState.buildingType != null) {
      if (world.temporaryBuilding == null) {
        _addTemporaryBuildingOnWorld(constructionState, dimetricTilePos);
      } else if (world.temporaryBuilding!.buildingType != constructionState.buildingType! || world.temporaryBuilding!.direction != constructionState.buildingDirection) {
        await removeTemporaryBuilding();
        _addTemporaryBuildingOnWorld(constructionState, dimetricTilePos);
      } else {
        world.temporaryBuilding!.changePosition(convertDimetricToWorldCoordinates(dimetricTilePos));
      }

      /// Color the building if destination is buildable

      if (isBuildingBuildable(dimetricTilePos, getBuildingSizeInTile(constructionState))) {
        world.temporaryBuilding?.changeColor(Palette.greenTransparent);
      } else {
        world.temporaryBuilding?.changeColor(Palette.redTransparent);
      }
    }

    /// Give Building Transparency
    world.temporaryBuilding?.makeTransparent();
  }

  void _addTemporaryBuildingOnWorld(ConstructionState constructionState, Vector2 dimetricTilePos) {
    world.temporaryBuilding = createBuilding(buildingType: constructionState.buildingType!, direction: constructionState.buildingDirection);
    world.add(world.temporaryBuilding!);
    world.temporaryBuilding!.changePosition(convertDimetricToWorldCoordinates(dimetricTilePos));
    world.temporaryBuilding!.renderAboveAll();
  }

  Future<void> removeTemporaryBuilding() async {
    if (world.temporaryBuilding?.isMounted ?? false) {
      world.remove(world.temporaryBuilding!);
      await world.temporaryBuilding!.removed;
      world.temporaryBuilding = null;
    }
  }

  int getBuildingSizeInTile(ConstructionState constructionState) {
    return createBuilding(buildingType: constructionState.buildingType!).sizeInTile;
  }

  bool isBuildingBuildable(Vector2 dimetricTilePos, int buildingSizeInTile) {
    bool isBuildable = true;
    for (int i = 0; i < buildingSizeInTile; i++) {
      for (int j = 0; j < buildingSizeInTile; j++) {
        if (!game.gridController.isTileBuildable(dimetricTilePos + Vector2(-i.toDouble(), j.toDouble()))) isBuildable = false;
      }
    }
    return isBuildable;
  }

  void tryToBuildCurrentBuilding() async {
    final constructionState = ref.read(constructionModeControllerProvider);
    if (isBuildingBuildable(game.currentMouseTilePos, getBuildingSizeInTile(constructionState))) {
      await game.gridController.buildOnTile(game.currentMouseTilePos, constructionState);
      ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
      ref.read(activeUIButtonControllerProvider.notifier).resetButtons();
    }
  }
}
