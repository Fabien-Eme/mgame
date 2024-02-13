import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class IncineratorDoor extends SpriteAnimationComponent with HasGameRef {
  IncineratorDoor({required this.direction, super.position});
  Directions direction;
  late String asset;

  SpriteAnimationData spriteAnimationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2(300, 312),
    loop: true,
  );

  @override
  FutureOr<void> onLoad() {
    size = Vector2(300, 312);
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
        asset = Assets.images.buildings.incinerator.doorSSpritesheet.path;
        animation = SpriteAnimation.fromFrameData(game.images.fromCache(asset), spriteAnimationData);

      case Directions.W:
        animation = null;
      case Directions.N:
        animation = null;
      case Directions.E:
        asset = Assets.images.buildings.incinerator.doorESpritesheet.path;
        animation = SpriteAnimation.fromFrameData(game.images.fromCache(asset), spriteAnimationData);
    }
  }
}
