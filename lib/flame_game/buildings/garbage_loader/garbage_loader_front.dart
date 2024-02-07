import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class GarbageLoaderFront extends SpriteAnimationComponent with HasGameRef {
  GarbageLoaderFront({required this.direction, required this.garbageLoaderFlow, super.position});
  final Directions direction;
  final GarbageLoaderFlow garbageLoaderFlow;

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (direction == Directions.E) {
      if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
        asset = Assets.images.buildings.garbageLoader.garbageLoaderEINSpritesheet.path;
      } else {
        asset = Assets.images.buildings.garbageLoader.garbageLoaderEOUTSpritesheet.path;
      }
    } else {
      if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
        asset = Assets.images.buildings.garbageLoader.garbageLoaderSINSpritesheet.path;
      } else {
        asset = Assets.images.buildings.garbageLoader.garbageLoaderSOUTSpritesheet.path;
      }
    }

    size = Vector2(120, 129);
    priority = 110;
    anchor = Anchor.bottomRight;

    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2(120, 129),
      loop: true,
    );

    final closeDoorAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(asset),
      data,
    );

    animation = closeDoorAnimation.reversed();

    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}

enum GarbageLoaderFlow { flowIn, flowOut }
