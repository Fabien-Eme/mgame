import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarbageLoaderFront extends SpriteAnimationComponent with HasGameReference {
  GarbageLoaderFront({required this.direction, required this.garbageLoaderFlow, super.position});
  Directions direction;
  final GarbageLoaderFlow garbageLoaderFlow;

  late String asset;
  final int spriteAmount = 7;
  bool isAnimationReversed = false;

  SpriteAnimationData spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 7,
    stepTime: 0.1,
    textureSize: Vector2(120, 129),
    loop: false,
  );

  @override
  FutureOr<void> onLoad() {
    size = Vector2(120, 129);
    priority = 110;
    anchor = Anchor.bottomRight;
    updateSprite();
    paint = Paint()..filterQuality = FilterQuality.low;

    animationTicker!.paused = true;
    animationTicker!.currentIndex = spriteAmount - 1;
    return super.onLoad();
  }

  void updateDirection(Directions updatedDirection) {
    direction = updatedDirection;
    updateSprite();
  }

  void updateSprite() {
    switch (direction) {
      case Directions.S:
        if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderSINSpritesheet.path;
        } else {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderSOUTSpritesheet.path;
        }
      case Directions.W:
        if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderEOUTSpritesheet.path;
        } else {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderEINSpritesheet.path;
        }
      case Directions.N:
        if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderSOUTSpritesheet.path;
        } else {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderSINSpritesheet.path;
        }
      case Directions.E:
        if (garbageLoaderFlow == GarbageLoaderFlow.flowIn) {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderEINSpritesheet.path;
        } else {
          asset = Assets.images.buildings.garbageLoader.garbageLoaderEOUTSpritesheet.path;
        }
    }

    bool hasPreviousAnimation = false;
    bool isPaused = false;
    int currentIndex = spriteAmount - 1;

    if (animationTicker != null) {
      hasPreviousAnimation = true;
      isPaused = animationTicker!.isPaused;
      currentIndex = animationTicker!.currentIndex;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(asset),
      spriteAnimationData,
    );

    if (hasPreviousAnimation) {
      animationTicker!.paused = isPaused;
      animationTicker!.currentIndex = currentIndex;
    }
  }
}

enum GarbageLoaderFlow { flowIn, flowOut }
