import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../game.dart';
import '../game_world.dart';
import '../ui/mouse_cursor.dart';

class MouseController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  final double gameWidth = MGame.gameWidth;
  final double gameHeight = MGame.gameHeight;
  final double tileWidth = MGame.tileWidth;
  late final CameraComponent camera;
  late final Vector2 viewfinderInitialPosition;
  late final MyMouseCursor myMouseCursor;
  late final bool isDesktop;

  @override
  FutureOr<void> onLoad() {
    camera = game.camera;
    viewfinderInitialPosition = game.viewfinderInitialPosition;
    myMouseCursor = game.myMouseCursor;
    isDesktop = game.isDesktop;

    return super.onLoad();
  }

  ///
  ///
  ///
  /// Handle mouse movement
  ///
  void onMouseMove(PointerHoverInfo info) {
    game.mousePosition = camera.globalToLocal(info.eventPosition.global);

    double cursorX = game.mousePosition.x;
    double cursorY = game.mousePosition.y;

    double globalCursorX = (game.mousePosition.x - camera.viewfinder.position.x) * camera.viewfinder.zoom + viewfinderInitialPosition.x;
    double globalCursorY = (game.mousePosition.y - camera.viewfinder.position.y) * camera.viewfinder.zoom + viewfinderInitialPosition.y;

    // if ((globalCursorY >= gameHeight - 100 && (globalCursorX < 400 || globalCursorX > MGame.gameWidth - 200)) || (globalCursorY <= 70 && globalCursorX > MGame.gameWidth - 70)) {
    if (globalCursorY >= gameHeight - 100 || (globalCursorY <= 70 && globalCursorX > MGame.gameWidth - 70)) {
      game.isMouseHoveringUI = true;
      //game.myMouseCursor.changeMouseCursorType(MouseCursorType.hand);
    } else {
      game.isMouseHoveringUI = false;
    }

    if (cursorX >= 0 && cursorX <= gameWidth && cursorY >= 0 && cursorY <= gameHeight) {
      double dimetricX = (cursorX + 2 * cursorY) / tileWidth - 0.5;
      double dimetricY = (cursorX - 2 * cursorY) / tileWidth + 0.5;

      /// Overlay navigation
      if (game.overlayDialog != null) {
        if (game.overlayDialog!.isCoordinatesOverButton(Vector2(globalCursorX, globalCursorY))) {
          game.isMouseHoveringOverlayButton = true;
          game.myMouseCursor.changeMouseCursorType(MouseCursorType.hand);
        } else {
          game.isMouseHoveringOverlayButton = false;
          game.myMouseCursor.resetMouseCursor();
        }
      } else {
        int tileX = dimetricX.floor();
        int tileY = dimetricY.floor();
        Point<int> newMouseTilePos = Point(tileX, tileY);
        if (game.gridController.checkIfWithinGridBoundaries(newMouseTilePos) && !game.isMouseHoveringUI) {
          if (game.currentMouseTilePos != newMouseTilePos) {
            game.cursorController.cursorIsMovingOnNewTile(newMouseTilePos);
          }
        }
      }
    }
  }
}
