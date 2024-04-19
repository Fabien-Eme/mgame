import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarageFront extends SpriteComponent with HasGameRef {
  GarageFront({required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(300, 262);
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
        asset = Assets.images.buildings.garage.garageSFront.path;
      case Directions.W:
        asset = Assets.images.buildings.garage.garageWFront.path;
      case Directions.N:
        asset = Assets.images.buildings.garage.garageNFront.path;
      case Directions.E:
        asset = Assets.images.buildings.garage.garageEFront.path;
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
