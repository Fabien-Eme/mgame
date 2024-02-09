import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import '../game.dart';

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
        break;
      case ConstructionMode.construct:
        break;
      case ConstructionMode.destruct:
        break;
      case ConstructionMode.idle:
        world.tileCursor.highlightDefault();

        /// Put temporary building away
        world.temporaryBuilding?.changePosition(Vector2(-1000, -1000));

        break;
    }
  }
}
