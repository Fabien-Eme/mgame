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
  /// Move [myMouseCursor] to follow mouse
  ///
  void moveMouseCursor(Vector2 pos) {
    Vector2 futureMouseCursorPosition = camera.globalToLocal(pos) * camera.viewfinder.zoom + (viewfinderInitialPosition - camera.viewfinder.position * camera.viewfinder.zoom);
    if (futureMouseCursorPosition.x < 0) futureMouseCursorPosition.x = 0;
    if (futureMouseCursorPosition.x > gameWidth) futureMouseCursorPosition.x = gameWidth;
    if (futureMouseCursorPosition.y < 0) futureMouseCursorPosition.y = 0;
    if (futureMouseCursorPosition.y > gameHeight) futureMouseCursorPosition.y = gameHeight;

    myMouseCursor.position = futureMouseCursorPosition;
  }

  ///
  ///
  ///
  /// Handle mouse movement
  ///
  void onMouseMove(PointerHoverInfo info) {
    if (isDesktop) moveMouseCursor(info.eventPosition.global);

    game.mousePosition = camera.globalToLocal(info.eventPosition.global);

    double cursorX = game.mousePosition.x;
    double cursorY = game.mousePosition.y;

    if (cursorX >= 0 && cursorX <= gameWidth && cursorY >= 0 && cursorY <= gameHeight) {
      double dimetricX = (cursorX + 2 * cursorY) / tileWidth - 0.5;
      double dimetricY = (cursorX - 2 * cursorY) / tileWidth + 0.5;

      int tileX = dimetricX.floor();
      int tileY = dimetricY.floor();
      Point<int> newMouseTilePos = Point(tileX, tileY);
      if (game.gridController.checkIfWithinGridBoundaries(newMouseTilePos)) {
        if (game.currentMouseTilePos != newMouseTilePos) {
          game.cursorController.cursorIsMovingOnNewTile(newMouseTilePos);
        }
      }
    }
  }
}
