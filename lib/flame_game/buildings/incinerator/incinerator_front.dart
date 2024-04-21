import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class IncineratorFront extends SpriteComponent with HasGameRef {
  bool isRecycler;

  IncineratorFront({required this.isRecycler, required this.direction, super.position});
  Directions direction;
  late String asset;

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
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerSFront.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorSFront.path;
        }
      case Directions.W:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerWFront.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorWFront.path;
        }
      case Directions.N:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerNFront.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorNFront.path;
        }
      case Directions.E:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerEFront.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorEFront.path;
        }
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
