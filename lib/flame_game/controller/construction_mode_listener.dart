import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import '../game.dart';
import '../utils/manage_coordinates.dart';

class ConstructionModeListener extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, constructionState) {
          _handleNewState(constructionState);
        }));
    super.onMount();
  }

  void _handleNewState(ConstructionState constructionState) {
    game.constructionController.resetTile(game.currentMouseTilePos);
    game.cursorController.cursorIsMovingOnNewTile(game.currentMouseTilePos);
    switch (constructionState.status) {
      case ConstructionMode.initial:
        world.tileCursor.highlightDefault();
        world.tileCursor.resetScale();
        break;
      case ConstructionMode.construct:

        /// Remove Temporary building if we construct roads
        if (constructionState.buildingType == null) {
          game.buildingController.removeTemporaryBuilding();
          world.tileCursor.resetScale();
        } else {
          /// If building, size Tile cursor properly
          switch (game.buildingController.getBuildingSizeInTile(constructionState)) {
            case 3:
              world.tileCursor.scaleToThreeTile();
              break;
            default:
              world.tileCursor.resetScale();
              break;
          }
        }

        world.tileCursor.changePosition(convertDimetricToWorldCoordinates(game.currentMouseTilePos));
        break;
      case ConstructionMode.destruct:
        break;
      case ConstructionMode.idle:
        world.tileCursor.highlightDefault();

        /// Remove temporary building
        game.buildingController.removeTemporaryBuilding();

        world.tileCursor.resetScale();
        world.tileCursor.changePosition(convertDimetricToWorldCoordinates(game.currentMouseTilePos));

        break;
    }
  }
}
