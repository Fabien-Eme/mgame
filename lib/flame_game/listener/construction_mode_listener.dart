import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import '../buildings/building.dart';
import '../game.dart';
import '../utils/convert_coordinates.dart';

class ConstructionModeListener extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, constructionState) {
          _handleNewState(constructionState);
        }));
    super.onMount();
  }

  void _handleNewState(ConstructionState constructionState) async {
    world.constructionController.resetTile(world.currentMouseTilePos);
    world.cursorController.cursorIsMovingOnNewTile(world.currentMouseTilePos);
    switch (constructionState.status) {
      case ConstructionMode.initial:
        world.tileCursor.highlightDefault();
        world.tileCursor.resetScale();
        break;
      case ConstructionMode.construct:

        /// Remove Temporary building if we construct roads
        if (constructionState.buildingType != null) {
          /// If building, size Tile cursor properly
          switch (createBuilding(buildingType: constructionState.buildingType!).sizeInTile) {
            case 3:
              world.tileCursor.scaleToThreeTile();
              break;
            default:
              world.tileCursor.resetScale();
              break;
          }
        } else {
          await world.buildingController.removeTemporaryBuilding();
          world.tileCursor.resetScale();
        }

        world.tileCursor.changePosition(convertDimetricPointToWorldCoordinates(world.currentMouseTilePos));
        break;
      case ConstructionMode.destruct:
        break;
      case ConstructionMode.idle:
        world.tileCursor.highlightDefault();

        /// Remove temporary building
        await world.buildingController.removeTemporaryBuilding();

        world.tileCursor.resetScale();
        world.tileCursor.changePosition(convertDimetricPointToWorldCoordinates(world.currentMouseTilePos));

        break;
    }
  }
}
