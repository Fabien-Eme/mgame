import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';

class TileCursor extends Component with HasWorldReference {
  TileCursorArrow tileCursorArrow = TileCursorArrow();
  TileCursorBackground tileCursorBackground = TileCursorBackground();

  @override
  FutureOr<void> onLoad() {
    world.add(tileCursorBackground);
    world.add(tileCursorArrow);

    return super.onLoad();
  }

  void changePosition(Vector2 pos) {
    tileCursorArrow.position = pos;
    tileCursorBackground.position = pos + Vector2(-0.5, 1);
  }

  void hideTileCursor() {
    tileCursorArrow.isVisible = false;
    tileCursorBackground.isVisible = false;
  }

  void showTileCursor() {
    tileCursorArrow.isVisible = true;
    tileCursorBackground.isVisible = true;
  }

  void highlightGreen() {
    tileCursorBackground.paint.colorFilter = const ColorFilter.mode(Color.fromARGB(255, 0, 255, 38), BlendMode.srcATop);
  }

  void highlightRed() {
    tileCursorBackground.paint.colorFilter = const ColorFilter.mode(Color.fromARGB(255, 250, 40, 40), BlendMode.srcATop);
  }

  void highlightDefault() {
    tileCursorBackground.paint.colorFilter = null;
  }
}

class TileCursorArrow extends SpriteComponent with HasGameRef, HasVisibility {
  @override
  FutureOr<void> onLoad() {
    priority = 1000;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.tileCursor.path));
    paint.filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}

class TileCursorBackground extends SpriteComponent with HasGameRef, HasVisibility {
  @override
  FutureOr<void> onLoad() {
    priority = 1000;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.tileCursorBackground.path));
    paint.filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
