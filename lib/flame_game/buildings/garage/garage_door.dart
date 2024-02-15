import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarageDoor extends SpriteAnimationComponent with HasGameRef {
  GarageDoor({required this.direction, super.position});
  Directions direction;
  late String asset;

  SpriteAnimationData spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2(300, 262),
    loop: true,
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
        animation = SpriteAnimation.fromFrameData(game.images.fromCache(asset), spriteAnimationData);
      case Directions.W:
        animation = null;
      case Directions.N:
        animation = null;
      case Directions.E:
        asset = Assets.images.buildings.garage.garageEDoorSpritesheet.path;
        animation = SpriteAnimation.fromFrameData(game.images.fromCache(asset), spriteAnimationData);
    }
  }
}
