import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class IncineratorDoor extends SpriteAnimationComponent with HasGameRef {
  IncineratorDoor({required this.direction, super.position});
  final Directions direction;

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (direction == Directions.E) {
      asset = Assets.images.buildings.incinerator.doorESpritesheet.path;
    } else {
      asset = Assets.images.buildings.incinerator.doorSSpritesheet.path;
    }

    size = Vector2(300, 312);
    priority = 110;
    anchor = Anchor.bottomRight;

    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: 8,
      stepTime: 0.1,
      textureSize: Vector2(300, 312),
      loop: true,
    );

    final closeDoorAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(asset),
      data,
    );

    animation = closeDoorAnimation;

    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
