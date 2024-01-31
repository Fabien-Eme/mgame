import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../gen/assets.gen.dart';
import 'game.dart';

class MyMouseCursor extends SpriteComponent with HasGameRef<MGame> {
  MyMouseCursor({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    priority = 1000;
    scale = Vector2.all(2);
    sprite = Sprite(game.images.fromCache(Assets.images.ui.cursor.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}
