import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import '../../gen/assets.gen.dart';
import '../utils/palette.dart';

class TileCursor extends Component with HasWorldReference {
  TileCursorArrow tileCursorArrow = TileCursorArrow();
  TileCursorBackground tileCursorBackground = TileCursorBackground();

  Vector2 offset = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    world.add(tileCursorBackground);
    world.add(tileCursorArrow);

    return super.onLoad();
  }

  void scaleToThreeTile() {
    tileCursorArrow.scale = Vector2.all(3);
    tileCursorBackground.scale = Vector2.all(3);
    offset = convertDimetricVectorToWorldCoordinates(Vector2(-3, 1));
  }

  void resetScale() {
    tileCursorArrow.scale = Vector2.all(1);
    tileCursorBackground.scale = Vector2.all(1);
    offset = Vector2.zero();
  }

  void changePosition(Vector2 pos) {
    tileCursorArrow.position = pos + offset;
    tileCursorBackground.position = pos + Vector2(-0.5, 1) + offset;
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
    tileCursorBackground.paint.colorFilter = const ColorFilter.mode(Palette.green, BlendMode.srcATop);
  }

  void highlightRed() {
    tileCursorBackground.paint.colorFilter = const ColorFilter.mode(Palette.red, BlendMode.srcATop);
  }

  void highlightDefault() {
    tileCursorBackground.paint.colorFilter = null;
  }
}

class TileCursorArrow extends SpriteComponent with HasGameRef, HasVisibility {
  @override
  FutureOr<void> onLoad() {
    priority = 400;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.tileCursor.path));
    paint.filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}

class TileCursorBackground extends SpriteComponent with HasGameRef, HasVisibility {
  @override
  FutureOr<void> onLoad() {
    priority = 400;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.tileCursorBackground.path));
    paint.filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
