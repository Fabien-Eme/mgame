import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class GarbageLoaderBack extends SpriteComponent with HasGameRef {
  GarbageLoaderBack({required this.direction, super.position});
  final Directions direction;

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (direction == Directions.E) {
      asset = Assets.images.buildings.garbageLoader.garbageLoaderEBack.path;
    } else {
      asset = Assets.images.buildings.garbageLoader.garbageLoaderSBack.path;
    }

    size = Vector2(120, 129);
    priority = 90;
    anchor = Anchor.bottomRight;

    sprite = Sprite(game.images.fromCache(asset));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
