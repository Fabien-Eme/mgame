import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarageDoor extends SpriteAnimationComponent with HasGameRef {
  GarageDoor({required this.direction, super.position});
  Directions direction;
  late String asset;

  final int spriteAmount = 8;
  bool isAnimationReversed = false;

  SpriteAnimationData spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2(300, 262),
    loop: false,
  );

  @override
  FutureOr<void> onLoad() {
    size = Vector2(300, 262);
    priority = 110;
    anchor = Anchor.bottomRight;
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
        asset = Assets.images.buildings.garage.garageSDoorSpritesheet.path;
        opacity = 1;
      case Directions.W:
        asset = Assets.images.buildings.garage.garageSDoorSpritesheet.path;
        opacity = 0;
      case Directions.N:
        asset = Assets.images.buildings.garage.garageSDoorSpritesheet.path;
        opacity = 0;
      case Directions.E:
        asset = Assets.images.buildings.garage.garageEDoorSpritesheet.path;
        opacity = 1;
    }

    bool hasPreviousAnimation = false;
    bool isPaused = false;
    int currentIndex = 0;

    if (animationTicker != null) {
      hasPreviousAnimation = true;
      isPaused = animationTicker!.isPaused;
      currentIndex = animationTicker!.currentIndex;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(asset),
      spriteAnimationData,
    );
    if (isAnimationReversed) animation = animation!.reversed();

    if (hasPreviousAnimation) {
      animationTicker!.paused = isPaused;
      animationTicker!.currentIndex = currentIndex;
    }
  }
}
