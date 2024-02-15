import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_rotations.dart';

class GarageBack extends SpriteComponent with HasGameRef {
  GarageBack({required this.direction, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(300, 262);
    priority = 90;
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
        asset = Assets.images.buildings.garage.garageSBack.path;
      case Directions.W:
        asset = Assets.images.buildings.empty.path;
      case Directions.N:
        asset = Assets.images.buildings.empty.path;
      case Directions.E:
        asset = Assets.images.buildings.garage.garageEBack.path;
    }
    sprite = Sprite(game.images.fromCache(asset));
  }
}
