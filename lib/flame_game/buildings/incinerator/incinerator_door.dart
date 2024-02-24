import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class IncineratorDoor extends SpriteAnimationComponent with HasGameRef {
  IncineratorDoor({required this.direction, super.position});
  Directions direction;
  String asset = "";

  final int spriteAmount = 8;
  bool isAnimationReversed = false;

  SpriteAnimationData spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2(300, 312),
    loop: false,
  );

  @override
  FutureOr<void> onLoad() {
    size = Vector2(300, 312);
    priority = 110;
    anchor = Anchor.bottomRight;
    updateSprite();
    paint = Paint()..filterQuality = FilterQuality.low;

    animationTicker?.currentIndex = spriteAmount - 1;
    animationTicker?.paused = true;

    return super.onLoad();
  }

  void updateDirection(Directions updatedDirection) {
    direction = updatedDirection;
    updateSprite();
  }

  void updateSprite() {
    switch (direction) {
      case Directions.S:
        asset = Assets.images.buildings.incinerator.doorSSpritesheet.path;
        opacity = 1;
      case Directions.W:
        asset = Assets.images.buildings.incinerator.doorSSpritesheet.path;
        opacity = 0;
      case Directions.N:
        asset = Assets.images.buildings.incinerator.doorSSpritesheet.path;
        opacity = 0;
      case Directions.E:
        asset = Assets.images.buildings.incinerator.doorESpritesheet.path;
        opacity = 1;
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
