import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/construction_mode_controller.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class MyMouseCursor extends SpriteComponent with HasGameRef<MGame>, RiverpodComponentMixin {
  MyMouseCursor({this.mouseCursorType = MouseCursorType.base, super.position, super.size});

  MouseCursorType mouseCursorType;

  @override
  FutureOr<void> onLoad() async {
    priority = 1000;
    sprite = Sprite(game.images.fromCache(mouseCursorType.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(constructionModeControllerProvider, (previous, constructionState) {
          _handleConstructionState(constructionState);
        }));
    super.onMount();
  }

  void _handleConstructionState(ConstructionState constructionState) {
    switch (constructionState.status) {
      case ConstructionMode.initial:
        mouseCursorType = MouseCursorType.base;
        break;
      case ConstructionMode.construct:
        mouseCursorType = MouseCursorType.add;

        break;
      case ConstructionMode.destruct:
        mouseCursorType = MouseCursorType.trash;
        break;
      case ConstructionMode.idle:
        mouseCursorType = MouseCursorType.base;
        break;
    }
    sprite = Sprite(game.images.fromCache(mouseCursorType.path));
  }
}

enum MouseCursorType {
  base,
  add,
  trash;

  String get path {
    return switch (this) {
      MouseCursorType.base => Assets.images.ui.mouseCursor.path,
      MouseCursorType.add => Assets.images.ui.mouseCursorAdd.path,
      MouseCursorType.trash => Assets.images.ui.mouseCursorTrash.path,
    };
  }
}
