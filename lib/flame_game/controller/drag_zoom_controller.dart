import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';

import '../game.dart';
import '../ui/mouse_cursor.dart';

class DragZoomController extends Component with HasGameRef<MGame>, RiverpodComponentMixin {
  final double gameWidth = MGame.gameWidth;
  final double gameHeight = MGame.gameHeight;
  final double minZoom = MGame.minZoom;
  final double maxZoom = MGame.maxZoom;
  final double tileWidth = MGame.tileWidth;
  final double tileHeight = MGame.tileHeight;
  late final CameraComponent camera;
  late final Vector2 viewfinderInitialPosition;
  late final MyMouseCursor myMouseCursor;
  late final bool isDesktop;

  final Map<int, DragInfo> _drags = {};
  double? _lastDistance;

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
  /// Handle Mouse [onScroll]
  ///
  void onScroll(PointerScrollInfo info) {
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

  ///
  ///
  /// Handle Zoom
  ///
  void zoomWithMouse(double amount) {
    Vector2 mousePosition = game.mousePosition;
    camera.viewfinder.zoom += amount;
    if (camera.viewfinder.zoom <= minZoom) {
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      camera.viewfinder.position = mousePosition;

      if (mousePosition.x < (viewfinderInitialPosition.x / camera.viewfinder.zoom + tileWidth / 2)) {
        camera.viewfinder.position = Vector2((viewfinderInitialPosition.x / camera.viewfinder.zoom + tileWidth / 2), mousePosition.y);
        mousePosition = camera.viewfinder.position;
      }
      if (mousePosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom - tileWidth / 2)) {
        camera.viewfinder.position = Vector2((gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom - tileWidth / 2), mousePosition.y);
        mousePosition = camera.viewfinder.position;
      }
      if (mousePosition.y < (viewfinderInitialPosition.y / camera.viewfinder.zoom + tileHeight / 2)) {
        camera.viewfinder.position = Vector2(mousePosition.x, (viewfinderInitialPosition.y / camera.viewfinder.zoom + tileHeight / 2));
        mousePosition = camera.viewfinder.position;
      }
      if (mousePosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom - tileHeight / 2)) {
        camera.viewfinder.position = Vector2(mousePosition.x, (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom - tileHeight / 2));
        game.mousePosition = camera.viewfinder.position;
      }
    }
  }

  void zoomWithFingers(double amount) {
    List<DragInfo> dragPoints = _drags.values.toList();
    Vector2 middlePointPosition = Vector2((dragPoints[0].startPosition.x + dragPoints[1].startPosition.x), (dragPoints[0].startPosition.y + dragPoints[1].startPosition.y));
    camera.viewfinder.zoom += amount;
    if (camera.viewfinder.zoom <= minZoom) {
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      if (middlePointPosition.x < (viewfinderInitialPosition.x / camera.viewfinder.zoom + tileWidth / 2)) {
        middlePointPosition = Vector2((viewfinderInitialPosition.x / camera.viewfinder.zoom + tileWidth / 2), middlePointPosition.y);
      }
      if (middlePointPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom - tileWidth / 2)) {
        middlePointPosition = Vector2((gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom - tileWidth / 2), middlePointPosition.y);
      }
      if (middlePointPosition.y < (viewfinderInitialPosition.y / camera.viewfinder.zoom + tileHeight / 2)) {
        middlePointPosition = Vector2(middlePointPosition.x, (viewfinderInitialPosition.y / camera.viewfinder.zoom + tileHeight / 2));
      }
      if (middlePointPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom)) {
        middlePointPosition = Vector2(middlePointPosition.x, (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom - tileHeight / 2));
      }

      camera.viewfinder.position = middlePointPosition;
    }
  }

  ///
  ///
  /// Handle Drag
  ///
  void onDragStart(int pointerId, DragStartInfo info) {
    if (!ref.read(overlayControllerProvider).isVisible) {
      _drags[pointerId] = DragInfo(startPosition: info.eventPosition.global);
      _updateGesture();
    }
  }

  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    myMouseCursor.position =
        camera.globalToLocal(info.eventPosition.global) * camera.viewfinder.zoom + (viewfinderInitialPosition / camera.viewfinder.zoom - camera.viewfinder.position) * camera.viewfinder.zoom;
    if (!ref.read(overlayControllerProvider).isVisible) {
      _drags[pointerId]?.updatePosition(info.eventPosition.global);

      _updateGesture();
      if (_drags.length == 1) {
        if (!isDesktop) {
          Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(info.delta.global.x / camera.viewfinder.zoom, info.delta.global.y / camera.viewfinder.zoom);
          if (projectedViewfinderPosition.x < (viewfinderInitialPosition.x / camera.viewfinder.zoom + tileWidth / 2) ||
              projectedViewfinderPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom - tileWidth / 2) ||
              projectedViewfinderPosition.y < (viewfinderInitialPosition.y / camera.viewfinder.zoom + tileHeight / 2) ||
              projectedViewfinderPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom - tileHeight / 2) ||
              camera.viewfinder.zoom == minZoom) {
          } else {
            camera.viewfinder.position = projectedViewfinderPosition;
          }
        } else {
          game.isMouseDragging = true;
          if (isDesktop) game.mouseController.moveMouseCursor(info.eventPosition.global);

          double cursorX = camera.globalToLocal(info.eventPosition.global).x;
          double cursorY = camera.globalToLocal(info.eventPosition.global).y;

          if (cursorX >= 0 && cursorX <= gameWidth && cursorY >= 0 && cursorY <= gameHeight) {
            double dimetricX = (cursorX + 2 * cursorY) / tileWidth - 0.5;
            double dimetricY = (cursorX - 2 * cursorY) / tileWidth + 0.5;

            int tileX = dimetricX.floor();
            int tileY = dimetricY.floor();
            Point<int> newMouseTilePos = Point(tileX, tileY);

            if (game.currentMouseTilePos != newMouseTilePos) {
              game.cursorController.cursorIsMovingOnNewTile(newMouseTilePos);
            }
          }
        }
      }
    }
  }

  void onDragEnd(int pointerId, DragEndInfo info) {
    if (!ref.read(overlayControllerProvider).isVisible) {
      _drags.remove(pointerId);
      _updateGesture();
      game.cursorController.cursorIsMovingOnNewTile(game.currentMouseTilePos);
      game.isMouseDragging = false;
    }
  }

  void onDragCancel(int pointerId) {
    if (!ref.read(overlayControllerProvider).isVisible) {
      _drags.remove(pointerId);
      _updateGesture();
      game.cursorController.cursorIsMovingOnNewTile(game.currentMouseTilePos);
      game.isMouseDragging = false;
    }
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    myMouseCursor.position = camera.globalToLocal(Vector2(details.localPosition.dx, details.localPosition.dy)) * camera.viewfinder.zoom +
        (viewfinderInitialPosition / camera.viewfinder.zoom - camera.viewfinder.position) * camera.viewfinder.zoom;

    Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(details.delta.dx / camera.viewfinder.zoom, details.delta.dy / camera.viewfinder.zoom);
    if (projectedViewfinderPosition.x < (viewfinderInitialPosition.x / camera.viewfinder.zoom) ||
        projectedViewfinderPosition.x > (gameWidth - viewfinderInitialPosition.x / camera.viewfinder.zoom) ||
        projectedViewfinderPosition.y < (viewfinderInitialPosition.y / camera.viewfinder.zoom) ||
        projectedViewfinderPosition.y > (gameHeight - viewfinderInitialPosition.y / camera.viewfinder.zoom) ||
        camera.viewfinder.zoom == minZoom) {
    } else {
      camera.viewfinder.position = projectedViewfinderPosition;
    }
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
