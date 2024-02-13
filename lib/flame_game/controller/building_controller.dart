import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../buildings/building.dart';
import '../game.dart';
import '../palette.dart';
import '../riverpod_controllers/construction_mode_controller.dart';

class BuildingController extends Component with HasGameReference<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, value) {
          if (world.temporaryBuilding != null) {
            world.temporaryBuilding!.setDirection(value.buildingDirection!);
          }
        }));
    super.onMount();
  }

  ///
  ///
  /// Project selected building on Tile while mouving mouse
  ///
  Future<void> projectBuildingOnTile(Point<int> dimetricTilePos) async {
    final constructionState = ref.read(constructionModeControllerProvider);

    ///Project the building
    if (constructionState.status == ConstructionMode.construct && constructionState.buildingType != null) {
      if (world.temporaryBuilding == null) {
        _addTemporaryBuildingOnWorld(constructionState, game.convertRotations.unRotateCoordinates(dimetricTilePos));
      } else if (world.temporaryBuilding!.buildingType != constructionState.buildingType!) {
        await removeTemporaryBuilding();
        _addTemporaryBuildingOnWorld(constructionState, game.convertRotations.unRotateCoordinates(dimetricTilePos));
      } else {
        world.temporaryBuilding!.setPosition(game.convertRotations.unRotateCoordinates(dimetricTilePos));
      }

      /// Color the building if destination is buildable

      if (isBuildingBuildable(dimetricTilePos, createBuilding(buildingType: constructionState.buildingType!))) {
        world.temporaryBuilding?.changeColor(Palette.greenTransparent);
      } else {
        world.temporaryBuilding?.changeColor(Palette.redTransparent);
      }
    }

    /// Give Building Transparency
    world.temporaryBuilding?.makeTransparent();
  }

  void _addTemporaryBuildingOnWorld(ConstructionState constructionState, Point<int> dimetricTilePos) {
    world.temporaryBuilding = createBuilding(buildingType: constructionState.buildingType!, direction: constructionState.buildingDirection);
    world.add(world.temporaryBuilding!);
    world.temporaryBuilding!.setPosition(dimetricTilePos);
    // world.temporaryBuilding!.renderAboveAll();
  }

  Future<void> removeTemporaryBuilding() async {
    if (world.temporaryBuilding?.isMounted ?? false) {
      world.remove(world.temporaryBuilding!);
      await world.temporaryBuilding!.removed;
      world.temporaryBuilding = null;
    }
  }

  bool isBuildingBuildable(Point<int> dimetricTilePos, Building building) {
    int buildingSizeInTile = building.sizeInTile;
    bool isBuildable = true;
    for (int i = 0; i < buildingSizeInTile; i++) {
      for (int j = 0; j < buildingSizeInTile; j++) {
        if (!game.gridController.isTileBuildable(dimetricTilePos + Point<int>(-i, j))) isBuildable = false;
      }
    }
    return isBuildable;
  }

  void tryToBuildCurrentBuilding() async {
    final constructionState = ref.read(constructionModeControllerProvider);
    if (isBuildingBuildable(game.currentMouseTilePos, createBuilding(buildingType: constructionState.buildingType!))) {
      await game.gridController.buildOnTile(game.convertRotations.unRotateCoordinates(game.currentMouseTilePos), constructionState);
      ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
      ref.read(activeUIButtonControllerProvider.notifier).resetButtons();
    }
  }
}
