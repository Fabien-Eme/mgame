import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/game_world.dart';
import '../bloc/game_bloc.dart';
import '../game.dart';

class GameBlocConsumer extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld> {
  // @override
  // void onNewState(GameState state) {
  //   game.constructionController.resetTile(game.currentMouseTilePos);
  //   game.cursorController.cursorIsMovingOnNewTile(game.currentMouseTilePos);
  //   switch (state.status) {
  //     case GameStatus.initial:
  //       world.tileCursor.highlightDefault();
  //       break;
  //     case GameStatus.construct:
  //       break;
  //     case GameStatus.destruct:
  //       break;
  //     case GameStatus.idle:
  //       world.tileCursor.highlightDefault();

  //       /// Put temporary building away
  //       world.temporaryBuilding?.changePosition(Vector2(-1000, -1000));

  //       break;
  //   }

  //   super.onNewState(state);
  // }
}
