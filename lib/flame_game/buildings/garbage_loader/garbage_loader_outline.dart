import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarbageLoaderOutline extends SpriteComponent with HasGameReference {
  GarbageLoaderOutline({required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    priority = 109;
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
        asset = Assets.images.buildings.garbageLoader.garbageLoaderOutlineS.path;
      case Directions.W:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderOutlineE.path;
      case Directions.N:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderOutlineS.path;
      case Directions.E:
        asset = Assets.images.buildings.garbageLoader.garbageLoaderOutlineE.path;
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
