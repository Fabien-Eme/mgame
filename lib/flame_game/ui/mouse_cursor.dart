import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class MyMouseCursor extends SpriteComponent with HasGameRef<MGame> {
  MyMouseCursor({this.mouseCursorType = MouseCursorType.base, super.position, super.size});

  MouseCursorType mouseCursorType;

  @override
  FutureOr<void> onLoad() async {
    await add(
      FlameBlocListener<GameBloc, GameState>(onNewState: _handleConstructionState),
    );
    priority = 1000;
    sprite = Sprite(game.images.fromCache(mouseCursorType.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }

  void _handleConstructionState(GameState newState) {
    switch (newState.status) {
      case GameStatus.initial:
        mouseCursorType = MouseCursorType.base;
        break;
      case GameStatus.construct:
        mouseCursorType = MouseCursorType.add;

        break;
      case GameStatus.destruct:
        mouseCursorType = MouseCursorType.trash;
        break;
      case GameStatus.idle:
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
