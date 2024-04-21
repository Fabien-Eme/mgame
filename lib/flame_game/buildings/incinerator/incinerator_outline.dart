import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class IncineratorOutline extends SpriteComponent with HasGameReference {
  bool isRecycler;

  IncineratorOutline({required this.isRecycler, required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    priority = 109;
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
          asset = Assets.images.buildings.recycler.recyclerOutlineS.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorOutlineS.path;
        }
      case Directions.W:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerOutlineW.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorOutlineW.path;
        }
      case Directions.N:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerOutlineN.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorOutlineN.path;
        }
      case Directions.E:
        if (isRecycler) {
          asset = Assets.images.buildings.recycler.recyclerOutlineE.path;
        } else {
          asset = Assets.images.buildings.incinerator.incineratorOutlineE.path;
        }
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
