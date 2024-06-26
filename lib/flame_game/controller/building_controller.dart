import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../buildings/building.dart';
import '../game.dart';
import '../level.dart';
import '../utils/convert_rotations.dart';
import '../utils/palette.dart';
import '../riverpod_controllers/construction_mode_controller.dart';

class BuildingController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, value) {
          if (world.temporaryBuilding != null && value.buildingType != null) {
            world.temporaryBuilding!.setDirection(value.buildingDirection!);
          }
        }));
    super.onMount();
  }

  ///
  ///
  /// Project selected building on Tile while mouving mouse
  ///
  void projectBuildingOnTile(Point<int> dimetricTilePos) async {
    final constructionState = ref.read(constructionModeControllerProvider);

    ///Project the building
    if (constructionState.status == ConstructionMode.construct && constructionState.buildingType != null) {
      if (world.temporaryBuilding == null) {
        _addTemporaryBuildingOnWorld(constructionState, world.convertRotations.unRotateCoordinates(dimetricTilePos));
      } else if (world.temporaryBuilding!.buildingType != constructionState.buildingType!) {
        await removeTemporaryBuilding();
        _addTemporaryBuildingOnWorld(constructionState, world.convertRotations.unRotateCoordinates(dimetricTilePos));
      } else {
        world.temporaryBuilding!.setPosition(world.convertRotations.unRotateCoordinates(dimetricTilePos));
      }

      /// Color the building if destination is buildable

      if (isBuildingBuildable(dimetricTilePos, createBuilding(buildingType: constructionState.buildingType!), constructionState.buildingDirection!)) {
        world.temporaryBuilding?.changeColor(Palette.greenTransparent);
      } else {
        world.temporaryBuilding?.changeColor(Palette.redTransparent);
      }

      /// Give Building Transparency
      world.temporaryBuilding?.makeTransparent();
      world.temporaryBuilding?.renderAboveAll();
    }

    ///Project Destruction
    if (constructionState.status == ConstructionMode.destruct) {
      if (world.gridController.isBuildingOnTile(dimetricTilePos) && world.gridController.isTileBuildingDestructible(dimetricTilePos)) {
        world.gridController.getBuildingOnTile(dimetricTilePos)?.changeColor(Palette.redTransparent);
      }
    }
  }

  void _addTemporaryBuildingOnWorld(ConstructionState constructionState, Point<int> dimetricTilePos) {
    world.temporaryBuilding = createBuilding(buildingType: constructionState.buildingType!, direction: constructionState.buildingDirection, garbageLoaderFlow: constructionState.garbageLoaderFlow);
    world.add(world.temporaryBuilding!);
    world.temporaryBuilding!.setPosition(dimetricTilePos);
  }

  Future<void> removeTemporaryBuilding() async {
    if (world.temporaryBuilding != null && world.temporaryBuilding!.isMounted && !world.temporaryBuilding!.isRemoving) {
      world.remove(world.temporaryBuilding!);
      await world.temporaryBuilding!.removed;
      world.temporaryBuilding = null;
    }
  }

  bool isBuildingBuildable(Point<int> dimetricTilePos, Building building, Directions buildingDirection) {
    int buildingSizeInTileX = building.sizeInTile.x;
    int buildingSizeInTileY = building.sizeInTile.y;

    bool isBuildable = true;

    if (building.buildingType == BuildingType.buryer) {
      List<Point<int>> listPoint = [];
      (buildingDirection == Directions.N || buildingDirection == Directions.S)
          ? listPoint = [const Point<int>(0, -1), const Point<int>(0, 0), const Point<int>(0, 1)]
          : listPoint = [const Point<int>(-1, 0), const Point<int>(0, 0), const Point<int>(1, 0)];

      if (!world.gridController.isTileBuildable(dimetricTilePos: dimetricTilePos + listPoint[0], building: building) ||
          !world.gridController.isTileBuildable(dimetricTilePos: dimetricTilePos + listPoint[1], building: building) ||
          !world.gridController.isTileBuildable(dimetricTilePos: dimetricTilePos + listPoint[2], building: building)) {
        isBuildable = false;
      }
    } else {
      for (int i = 0; i < buildingSizeInTileX; i++) {
        for (int j = 0; j < buildingSizeInTileY; j++) {
          if (!world.gridController.isTileBuildable(dimetricTilePos: dimetricTilePos + Point<int>(-i, j), building: building)) {
            isBuildable = false;
          }
        }
      }
    }
    return isBuildable;
  }

  void tryToBuildCurrentBuilding() async {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (!game.isMobile) {
      if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(createBuilding(buildingType: constructionState.buildingType!).buildingCost)) {
        if (isBuildingBuildable(world.currentMouseTilePos, createBuilding(buildingType: constructionState.buildingType!), constructionState.buildingDirection!)) {
          await world.gridController.buildOnTile(world.convertRotations.unRotateCoordinates(world.currentMouseTilePos), constructionState);
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
          ref.read(activeUIButtonControllerProvider.notifier).resetButtons();
        }
      }
    } else {
      if (game.mobileTempCurrentMouseTilePos == world.currentMouseTilePos && game.mobileTempBuildingType == constructionState.buildingType!) {
        if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(createBuilding(buildingType: constructionState.buildingType!).buildingCost)) {
          if (isBuildingBuildable(world.currentMouseTilePos, createBuilding(buildingType: constructionState.buildingType!), constructionState.buildingDirection!)) {
            await world.gridController.buildOnTile(world.convertRotations.unRotateCoordinates(world.currentMouseTilePos), constructionState);
            ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
            ref.read(activeUIButtonControllerProvider.notifier).resetButtons();
          }
        }
      } else {
        game.mobileTempCurrentMouseTilePos = world.currentMouseTilePos;
        game.mobileTempBuildingType = constructionState.buildingType!;
      }
    }
  }
}
