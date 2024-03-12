import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class MyMouseCursor extends SpriteComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  MyMouseCursor({this.mouseCursorType = MouseCursorType.base, super.position, super.size});

  MouseCursorType mouseCursorType;
  ConstructionState? constructionState;

  Vector2 offset = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(mouseCursorType.path));
    priority = 1000;
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, newConstructionState) {
          constructionState = newConstructionState;
          if (!game.isMobile) _handleNewConstructionState();
        }));
    super.onMount();
  }

  void _handleNewConstructionState() {
    MouseCursorType? newMouseCursorType;

    switch (constructionState?.status) {
      case ConstructionMode.initial:
        newMouseCursorType = MouseCursorType.base;
        break;
      case ConstructionMode.construct:
        newMouseCursorType = MouseCursorType.add;
        break;
      case ConstructionMode.destruct:
        newMouseCursorType = MouseCursorType.trash;
        break;
      case ConstructionMode.idle:
        newMouseCursorType = MouseCursorType.base;
        break;
      case null:
        newMouseCursorType = MouseCursorType.base;
        break;
    }
    if (mouseCursorType != newMouseCursorType) {
      mouseCursorType = newMouseCursorType;
      sprite = Sprite(game.images.fromCache(mouseCursorType.path));
    }
  }

  void changeMouseCursorType(MouseCursorType newMouseCursorType) {
    if (mouseCursorType != newMouseCursorType) {
      mouseCursorType = newMouseCursorType;
      sprite = Sprite(game.images.fromCache(mouseCursorType.path));

      if (mouseCursorType == MouseCursorType.hand) {
        offset = Vector2(-5, 0);
        updatePosition(position);
      } else {
        updatePosition(position - offset * 2);
        offset = Vector2.zero();
      }
    }
  }

  void hoverEnterButton() {
    if (!game.isMobile) changeMouseCursorType(MouseCursorType.hand);
  }

  void hoverExitButton() {
    if (!game.isMobile) changeMouseCursorType(MouseCursorType.base);
  }

  void resetMouseCursor() {
    if (!game.isMobile) _handleNewConstructionState();
  }

  void updatePosition(Vector2 newPosition) {
    if (!game.isMobile) position = newPosition + offset;
  }
}

enum MouseCursorType {
  base,
  add,
  trash,
  hand;

  String get path {
    return switch (this) {
      MouseCursorType.base => Assets.images.ui.mouseCursor.path,
      MouseCursorType.add => Assets.images.ui.mouseCursorAdd.path,
      MouseCursorType.trash => Assets.images.ui.mouseCursorTrash.path,
      MouseCursorType.hand => Assets.images.ui.mouseCursorHand.path,
    };
  }
}
