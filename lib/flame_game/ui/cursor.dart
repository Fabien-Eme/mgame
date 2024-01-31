import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';

class Cursor extends SpriteComponent with HasGameRef {
  Cursor({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(Assets.images.tiles.cursor.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}
