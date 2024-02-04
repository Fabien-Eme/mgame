import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';
import 'garbage_loader_front.dart';

class GarbageLoaderBack extends SpriteComponent with HasGameRef {
  GarbageLoaderBack({required this.garbageLoaderDirection, super.position});
  final GarbageLoaderDirections garbageLoaderDirection;

  final Vector2 offset = convertDimetricWorldCoordinates(Vector2(2, 0)) + Vector2(10, 5);

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (garbageLoaderDirection == GarbageLoaderDirections.E) {
      asset = Assets.images.buildings.garbageLoader.garbageLoaderEBack.path;
    } else {
      asset = Assets.images.buildings.garbageLoader.garbageLoaderSBack.path;
    }

    position = position + offset;
    size = Vector2(120, 129);
    priority = 90;
    anchor = Anchor.bottomRight;

    sprite = Sprite(game.images.fromCache(asset));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
