import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';
import 'package:mgame/flame_game/game_assets.dart';
import 'package:mgame/flame_game/ui/ui_bottom_bar.dart';

import 'game_world.dart';
import 'mouse_cursor.dart';

class MGame extends FlameGame<GameWorld> with MouseMovementDetector, ScrollDetector, MultiTouchDragDetector, TapDetector, SecondaryTapDetector {
  static const double gameWidth = 2000;
  static const double gameHeight = 900;
  final Vector2 viewfinderInitialPosition = Vector2(gameWidth / 2, gameHeight / 2);
  static const double tileWidth = 100;
  static const double tileHeight = 50;
  static const double maxZoom = 3;
  static const double minZoom = 1;

  final bool isMobile;
  final bool isDesktop;
  final GameBloc gameBloc;
  MGame({
    required this.isMobile,
    required this.isDesktop,
    required this.gameBloc,
  }) : super(
          world: GameWorld(gameBloc: gameBloc),
          camera: CameraComponent.withFixedResolution(width: gameWidth, height: gameHeight, viewfinder: Viewfinder()..position = Vector2(gameWidth / 2, gameHeight / 2)),
        );

  Vector2? currentHighlightedTilePos;
  Vector2? mousePosition;
  late MyMouseCursor myMouseCursor;
  bool hasConstructed = false;

  @override
  FutureOr<void> onLoad() async {
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);

    mouseCursor = SystemMouseCursors.none;

    return super.onLoad();
  }

  @override
  void onMount() async {
    UIBottomBar uiComponent = UIBottomBar();
    myMouseCursor = MyMouseCursor();

    await camera.viewport.addAll(
      [uiComponent, myMouseCursor],
    );
    super.onMount();
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  @override
  Color backgroundColor() {
    return const Color(0x0ff00000);
    // return const Color(0xFFa9da6a);
  }

  @override
  void onSecondaryTapUp(TapUpInfo info) {
    gameBloc.add(const ConstructionModeExited());
    super.onSecondaryTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    world.primaryTapDown();
    super.onTapDown(info);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    Vector2 mouseCursorXY = camera.globalToLocal(info.eventPosition.global);
    mousePosition = mouseCursorXY;

    myMouseCursor.position = camera.globalToLocal(info.eventPosition.global) * camera.viewfinder.zoom + (viewfinderInitialPosition - camera.viewfinder.position * camera.viewfinder.zoom);

    double cursorX = mouseCursorXY.x;
    double cursorY = mouseCursorXY.y;

    if (mouseCursorXY.x >= 0 && mouseCursorXY.x <= gameWidth && mouseCursorXY.y >= 0 && mouseCursorXY.y <= gameHeight) {
      double dimetricX = (cursorX + 2 * cursorY) / tileWidth - 0.5;
      double dimetricY = (cursorX - 2 * cursorY) / tileWidth + 0.5;

      int tileX = dimetricX.floor();
      int tileY = dimetricY.floor();
      Vector2 currentTilePos = Vector2(tileX.toDouble(), tileY.toDouble());
      if (currentHighlightedTilePos == null || currentHighlightedTilePos != currentTilePos) {
        if (hasConstructed) {
          hasConstructed = false;
          world.removeHighlight(currentHighlightedTilePos);
        } else {
          world.resetTile(currentHighlightedTilePos);
        }
        world.moveTileCursor(currentTilePos);

        currentHighlightedTilePos = currentTilePos;
      }
    }
    super.onMouseMove(info);
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// Handle Zoom

  @override
  void onScroll(PointerScrollInfo info) {
    super.onScroll(info);
    if (info.scrollDelta.global.y < 0) {
      if (camera.viewfinder.zoom < maxZoom) {
        zoomWithMouse(0.5);
      }
    } else {
      if (camera.viewfinder.zoom > minZoom) {
        zoomWithMouse(-0.5);
      }
    }
  }

  void zoomWithMouse(double amount) {
    camera.viewfinder.zoom += amount;
    if (camera.viewfinder.zoom <= minZoom) {
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      if (mousePosition!.x < viewfinderInitialPosition.x / camera.viewfinder.zoom) {
        mousePosition = Vector2(viewfinderInitialPosition.x / camera.viewfinder.zoom, mousePosition!.y);
      }
      if (mousePosition!.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom)) {
        mousePosition = Vector2(gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom, mousePosition!.y);
      }
      if (mousePosition!.y < viewfinderInitialPosition.y / camera.viewfinder.zoom) {
        mousePosition = Vector2(mousePosition!.x, viewfinderInitialPosition.y / camera.viewfinder.zoom);
      }
      if (mousePosition!.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom)) {
        mousePosition = Vector2(mousePosition!.x, gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom);
      }

      camera.viewfinder.position = mousePosition!;
    }
  }

  void zoomWithFingers(double amount) {
    List<DragInfo> dragPoints = _drags.values.toList();
    Vector2 middlePointPosition = Vector2((dragPoints[0].startPosition.x + dragPoints[1].startPosition.x), (dragPoints[0].startPosition.y + dragPoints[1].startPosition.y));
    camera.viewfinder.zoom += amount;
    if (camera.viewfinder.zoom <= minZoom) {
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      if (middlePointPosition.x < viewfinderInitialPosition.x / camera.viewfinder.zoom) {
        middlePointPosition = Vector2(viewfinderInitialPosition.x / camera.viewfinder.zoom, middlePointPosition.y);
      }
      if (middlePointPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom)) {
        middlePointPosition = Vector2(gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom, middlePointPosition.y);
      }
      if (middlePointPosition.y < viewfinderInitialPosition.y / camera.viewfinder.zoom) {
        middlePointPosition = Vector2(middlePointPosition.x, viewfinderInitialPosition.y / camera.viewfinder.zoom);
      }
      if (middlePointPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom)) {
        middlePointPosition = Vector2(middlePointPosition.x, gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom);
      }

      camera.viewfinder.position = middlePointPosition;
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// Handle Drag

  final Map<int, DragInfo> _drags = {};
  double? _lastDistance;

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    _drags[pointerId] = DragInfo(startPosition: info.eventPosition.global);
    _updateGesture();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    myMouseCursor.position =
        camera.globalToLocal(info.eventPosition.global) * camera.viewfinder.zoom + (viewfinderInitialPosition / camera.viewfinder.zoom - camera.viewfinder.position) * camera.viewfinder.zoom;
    _drags[pointerId]?.updatePosition(info.eventPosition.global);
    _updateGesture();
    if (_drags.length == 1 && !isDesktop) {
      Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(info.delta.global.x / camera.viewfinder.zoom, info.delta.global.y / camera.viewfinder.zoom);
      if (projectedViewfinderPosition.x < viewfinderInitialPosition.x / camera.viewfinder.zoom ||
          projectedViewfinderPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom) ||
          projectedViewfinderPosition.y < viewfinderInitialPosition.y / camera.viewfinder.zoom ||
          projectedViewfinderPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom)) {
      } else {
        camera.viewfinder.position = projectedViewfinderPosition;
      }
    }
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    myMouseCursor.position = camera.globalToLocal(Vector2(details.localPosition.dx, details.localPosition.dy)) * camera.viewfinder.zoom +
        (viewfinderInitialPosition / camera.viewfinder.zoom - camera.viewfinder.position) * camera.viewfinder.zoom;

    Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(details.delta.dx / camera.viewfinder.zoom, details.delta.dy / camera.viewfinder.zoom);
    if (projectedViewfinderPosition.x < viewfinderInitialPosition.x / camera.viewfinder.zoom ||
        projectedViewfinderPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom) ||
        projectedViewfinderPosition.y < viewfinderInitialPosition.y / camera.viewfinder.zoom ||
        projectedViewfinderPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom)) {
    } else {
      camera.viewfinder.position = projectedViewfinderPosition;
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    _drags.remove(pointerId);
    _updateGesture();
  }

  @override
  void onDragCancel(int pointerId) {
    _drags.remove(pointerId);
    _updateGesture();
  }

  void _updateGesture() {
    if (_drags.length == 2) {
      List<DragInfo> dragPoints = _drags.values.toList();
      double currentDistance = (dragPoints[0].currentPosition - dragPoints[1].currentPosition).length;

      if (_lastDistance != null) {
        if (currentDistance > _lastDistance!) {
          if (camera.viewfinder.zoom < maxZoom) {
            zoomWithFingers(0.007);
          }
        } else if (currentDistance < _lastDistance!) {
          if (camera.viewfinder.zoom > minZoom) {
            zoomWithFingers(-0.007);
          }
        }
      }

      _lastDistance = currentDistance;
    } else {
      _lastDistance = null;
    }
  }
}

class DragInfo {
  Vector2 startPosition;
  Vector2 currentPosition;

  DragInfo({required this.startPosition}) : currentPosition = startPosition;

  void updatePosition(Vector2 newPosition) {
    currentPosition = newPosition;
  }
}
