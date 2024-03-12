import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/gestures.dart';

import '../game.dart';
import '../level.dart';
import '../level_world.dart';
import '../ui/mouse_cursor.dart';

class DragZoomController extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
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
    myMouseCursor = game.myMouseCursor;
    isDesktop = game.isDesktop;
    camera = (world.parent as Level).cameraComponent;
    viewfinderInitialPosition = Vector2.zero();
    return super.onLoad();
  }

  ///
  ///
  /// Handle Mouse [onScroll]
  ///
  void onScroll(PointerScrollInfo info) {
    if (info.scrollDelta.global.y < 0) {
      if (camera.viewfinder.zoom < maxZoom) {
        zoomWithMouse(0.1 + camera.viewfinder.zoom * 0.2);
      }
    } else {
      if (camera.viewfinder.zoom > minZoom) {
        zoomWithMouse(-0.1 - camera.viewfinder.zoom * 0.2);
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
      camera.viewfinder.zoom = minZoom;
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      Vector2 newViewfinderPosition = (amount >= 0)
          ? mousePosition - mousePosition / camera.viewfinder.zoom
          : camera.viewfinder.position -
              (Vector2(MGame.gameWidth - MGame.gameWidth / camera.viewfinder.zoom, MGame.gameHeight - MGame.gameHeight / camera.viewfinder.zoom) -
                      Vector2(MGame.gameWidth - MGame.gameWidth / (camera.viewfinder.zoom + amount), MGame.gameHeight - MGame.gameHeight / (camera.viewfinder.zoom + amount))) /
                  (2 * camera.viewfinder.zoom);
      newViewfinderPosition.clamp(Vector2(0, 0), Vector2(MGame.gameWidth, MGame.gameHeight) - Vector2(MGame.gameWidth, MGame.gameHeight) / (camera.viewfinder.zoom));
      camera.viewfinder.position = newViewfinderPosition;
    }
  }

  void zoomWithFingers(double amount) {
    List<DragInfo> dragPoints = _drags.values.toList();
    Vector2 middlePointPosition = Vector2((dragPoints[0].startPosition.x + dragPoints[1].startPosition.x), (dragPoints[0].startPosition.y + dragPoints[1].startPosition.y));
    camera.viewfinder.zoom += amount;
    if (camera.viewfinder.zoom <= minZoom) {
      camera.viewfinder.zoom = minZoom;
      camera.viewfinder.position = viewfinderInitialPosition;
    } else {
      Vector2 newViewfinderPosition = (amount >= 0)
          ? middlePointPosition - middlePointPosition / camera.viewfinder.zoom
          : camera.viewfinder.position -
              (Vector2(MGame.gameWidth - MGame.gameWidth / camera.viewfinder.zoom, MGame.gameHeight - MGame.gameHeight / camera.viewfinder.zoom) -
                      Vector2(MGame.gameWidth - MGame.gameWidth / (camera.viewfinder.zoom + amount), MGame.gameHeight - MGame.gameHeight / (camera.viewfinder.zoom + amount))) /
                  (2 * camera.viewfinder.zoom);
      newViewfinderPosition.clamp(Vector2(0, 0), Vector2(MGame.gameWidth, MGame.gameHeight) - Vector2(MGame.gameWidth, MGame.gameHeight) / (camera.viewfinder.zoom));
      camera.viewfinder.position = newViewfinderPosition;
    }
  }

  ///
  ///
  /// Handle Drag
  ///
  void onDragStart(int pointerId, DragStartInfo info) {
    _drags[pointerId] = DragInfo(startPosition: info.eventPosition.global);
    _updateGesture();
  }

  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (!game.isMobile) myMouseCursor.position = camera.globalToLocal(info.eventPosition.global) * camera.viewfinder.zoom - camera.viewfinder.position * camera.viewfinder.zoom;
    _drags[pointerId]?.updatePosition(info.eventPosition.global);

    _updateGesture();
    if (_drags.length == 1) {
      if (!isDesktop) {
        Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(info.delta.global.x, info.delta.global.y);
        if (projectedViewfinderPosition.x < 0 ||
            projectedViewfinderPosition.x > gameWidth - gameWidth / camera.viewfinder.zoom ||
            projectedViewfinderPosition.y < 0 ||
            projectedViewfinderPosition.y > gameHeight - gameHeight / camera.viewfinder.zoom ||
            camera.viewfinder.zoom == minZoom) {
        } else {
          camera.viewfinder.position = projectedViewfinderPosition;
        }
      } else {
        game.isMouseDragging = true;

        double cursorX = camera.globalToLocal(info.eventPosition.global).x;
        double cursorY = camera.globalToLocal(info.eventPosition.global).y;

        if (cursorX >= 0 && cursorX <= gameWidth && cursorY >= 0 && cursorY <= gameHeight) {
          double dimetricX = (cursorX + 2 * cursorY) / tileWidth - 0.5;
          double dimetricY = (cursorX - 2 * cursorY) / tileWidth + 0.5;

          int tileX = dimetricX.floor();
          int tileY = dimetricY.floor();
          Point<int> newMouseTilePos = Point(tileX, tileY);

          if (world.currentMouseTilePos != newMouseTilePos) {
            world.cursorController.cursorIsMovingOnNewTile(newMouseTilePos);
          }
        }
      }
    }
  }

  void onDragEnd(int pointerId, DragEndInfo info) {
    _drags.remove(pointerId);
    _updateGesture();
    world.cursorController.cursorIsMovingOnNewTile(world.currentMouseTilePos);
    game.isMouseDragging = false;
  }

  void onDragCancel(int pointerId) {
    _drags.remove(pointerId);
    _updateGesture();
    world.cursorController.cursorIsMovingOnNewTile(world.currentMouseTilePos);
    game.isMouseDragging = false;
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    myMouseCursor.position = camera.globalToLocal(Vector2(details.localPosition.dx, details.localPosition.dy)) * camera.viewfinder.zoom - camera.viewfinder.position * camera.viewfinder.zoom;

    Vector2 projectedViewfinderPosition = camera.viewfinder.position - Vector2(details.delta.dx, details.delta.dy);
    if (projectedViewfinderPosition.x < 0 ||
        projectedViewfinderPosition.x > gameWidth - gameWidth / camera.viewfinder.zoom ||
        projectedViewfinderPosition.y < 0 ||
        projectedViewfinderPosition.y > gameHeight - gameHeight / camera.viewfinder.zoom ||
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
