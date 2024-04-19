import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../utils/convert_rotations.dart';

class BuryerOutlineComponent extends SpriteComponent with HasGameReference<MGame> {
  BuryerOutlineComponent({required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    priority = 109;
    anchor = Anchor.center;
    scale = Vector2(0.26, 0.26);

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
        asset = Assets.images.buildings.buryer.buryerOutlineS.path;
      case Directions.W:
        asset = Assets.images.buildings.buryer.buryerOutlineW.path;
      case Directions.N:
        asset = Assets.images.buildings.buryer.buryerOutlineN.path;
      case Directions.E:
        asset = Assets.images.buildings.buryer.buryerOutlineE.path;
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
