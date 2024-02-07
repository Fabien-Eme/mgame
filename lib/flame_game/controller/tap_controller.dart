import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';
import 'package:mgame/flame_game/controller/game_controller.dart' hide GameStatus;

import '../game.dart';
import '../ui/mouse_cursor.dart';

class TapController extends Component with HasGameRef<MGame>, RiverpodComponentMixin {
  final double gameWidth = MGame.gameWidth;
  final double gameHeight = MGame.gameHeight;
  final double tileWidth = MGame.tileWidth;
  late final CameraComponent camera;
  late final Vector2 viewfinderInitialPosition;
  late final MyMouseCursor myMouseCursor;
  late final bool isDesktop;
  late Vector2 mousePosition;
  late Vector2 currentMouseTilePos;
  late final GameBloc gameBloc;

  @override
  FutureOr<void> onLoad() {
    camera = game.camera;
    viewfinderInitialPosition = game.viewfinderInitialPosition;
    myMouseCursor = game.myMouseCursor;
    isDesktop = game.isDesktop;
    mousePosition = game.mousePosition;
    currentMouseTilePos = game.currentMouseTilePos;
    gameBloc = game.gameBloc;

    return super.onLoad();
  }

  void onTapDown(TapDownInfo info) {
    // print(ref.read(gameControllerProvider));
    if (gameBloc.state.status == GameStatus.construct) {
      if (gameBloc.state.tileType != null) {
        game.constructionController.construct(posDimetric: game.currentMouseTilePos, tileType: gameBloc.state.tileType!);
        game.hasConstructed = true;
      }
    } else if (gameBloc.state.status == GameStatus.destruct) {
      game.constructionController.destroy(posDimetric: game.currentMouseTilePos);
    }
  }

  void onSecondaryTapUp(TapUpInfo info) {
    switch (gameBloc.state.status) {
      case GameStatus.initial:
        gameBloc.add(const DestructionModePressed());

        break;
      case GameStatus.construct:
        gameBloc.add(const ConstructionModeExited());

        break;
      case GameStatus.destruct:
        gameBloc.add(const DestructionModeExited());

        break;
      case GameStatus.idle:
        gameBloc.add(const DestructionModePressed());

        break;
    }
  }

  void onTertiaryTapDown(TapDownInfo info) {
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
