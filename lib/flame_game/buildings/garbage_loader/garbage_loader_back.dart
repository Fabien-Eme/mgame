import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarbageLoaderBack extends SpriteComponent with HasGameRef {
  GarbageLoaderBack({required this.direction, super.position});
  Directions direction;

  late String asset;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(120, 129);
    priority = 90;
    anchor = Anchor.bottomRight;
    scale = Vector2(0.75, 0.75);
    updateSprite();

    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  void updateDirection(Directions updatedDirection) {
    direction = updatedDirection;
    updateSprite();
  }

  void updateSprite() {
    switch (direction) {
      case Directions.S:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderSBack.path;
      case Directions.W:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderEBack.path;
      case Directions.N:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderSBack.path;
      case Directions.E:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderEBack.path;
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
