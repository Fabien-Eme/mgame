import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class CityComponent extends SpriteComponent with HasGameRef {
  CityComponent({required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    priority = 110;
    anchor = Anchor.center;

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
        asset = Assets.images.buildings.city.cityS.path;
      case Directions.W:
        asset = Assets.images.buildings.city.cityW.path;
      case Directions.N:
        asset = Assets.images.buildings.city.cityN.path;
      case Directions.E:
        asset = Assets.images.buildings.city.cityE.path;
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
