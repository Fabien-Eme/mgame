import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';
import 'package:mgame/flame_game/riverpod_controllers/ui_controller.dart';

import '../game.dart';
import '../ui/mouse_cursor.dart';

class TapController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final double gameWidth = MGame.gameWidth;
  final double gameHeight = MGame.gameHeight;
  final double tileWidth = MGame.tileWidth;
  late final CameraComponent camera;
  late final Vector2 viewfinderInitialPosition;
  late final MyMouseCursor myMouseCursor;
  late final bool isDesktop;
  late Vector2 mousePosition;
  late Vector2 currentMouseTilePos;

  @override
  FutureOr<void> onLoad() {
    camera = game.camera;
    viewfinderInitialPosition = game.viewfinderInitialPosition;
    myMouseCursor = game.myMouseCursor;
    isDesktop = game.isDesktop;
    mousePosition = game.mousePosition;
    currentMouseTilePos = game.currentMouseTilePos;

    return super.onLoad();
  }

  void onTapDown(TapDownInfo info) {
    final constructionState = ref.read(constructionModeControllerProvider);

    if (constructionState.status == ConstructionMode.construct) {
      if (constructionState.tileType != null) {
        game.constructionController.construct(posDimetric: game.currentMouseTilePos, tileType: constructionState.tileType!);
        game.hasConstructed = true;
      }
    } else if (constructionState.status == ConstructionMode.destruct) {
      game.constructionController.destroy(posDimetric: game.currentMouseTilePos);
    }
  }

  void onSecondaryTapUp(TapUpInfo info) {
    ref.read(activeUIButtonControllerProvider.notifier).onSecondaryTapUp();
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
