import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../utils/convert_rotations.dart';

class BuryerComponent extends SpriteComponent with HasGameReference<MGame> {
  int fillCapacity;
  int fillAmount;

  BuryerComponent({required this.direction, required this.fillCapacity, required this.fillAmount, super.position});
  Directions direction;
  late String asset;

  @override
  FutureOr<void> onLoad() {
    priority = 110;
    anchor = Anchor.center;
    scale = Vector2(0.25, 0.25);

    updateSprite();
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  void updateDirection(Directions updatedDirection) {
    direction = updatedDirection;
    updateSprite();
  }

  void updateFillAmount(int newFillAmount) {
    fillAmount = newFillAmount;
    updateSprite();
  }

  void updateSprite() {
    double fillRatio = fillAmount / fillCapacity;
    int fillPercentage = 0;

    if (fillRatio < 0.25) {
      fillPercentage = 0;
    } else if (fillRatio < 0.5) {
      fillPercentage = 25;
    } else if (fillRatio < 0.75) {
      fillPercentage = 50;
    } else if (fillRatio < 1) {
      fillPercentage = 75;
    } else {
      fillPercentage = 100;
    }

    switch (direction) {
      case Directions.S:
        switch (fillPercentage) {
          case 0:
            asset = Assets.images.buildings.buryer.buryer0S.path;
            break;
          case 25:
            asset = Assets.images.buildings.buryer.buryer25S.path;
            break;
          case 50:
            asset = Assets.images.buildings.buryer.buryer50S.path;
            break;
          case 75:
            asset = Assets.images.buildings.buryer.buryer75S.path;
            break;
          case 100:
            asset = Assets.images.buildings.buryer.buryer100S.path;
            break;
        }
      case Directions.W:
        switch (fillPercentage) {
          case 0:
            asset = Assets.images.buildings.buryer.buryer0W.path;
            break;
          case 25:
            asset = Assets.images.buildings.buryer.buryer25W.path;
            break;
          case 50:
            asset = Assets.images.buildings.buryer.buryer50W.path;
            break;
          case 75:
            asset = Assets.images.buildings.buryer.buryer75W.path;
            break;
          case 100:
            asset = Assets.images.buildings.buryer.buryer100W.path;
            break;
        }
      case Directions.N:
        switch (fillPercentage) {
          case 0:
            asset = Assets.images.buildings.buryer.buryer0N.path;
            break;
          case 25:
            asset = Assets.images.buildings.buryer.buryer25N.path;
            break;
          case 50:
            asset = Assets.images.buildings.buryer.buryer50N.path;
            break;
          case 75:
            asset = Assets.images.buildings.buryer.buryer75N.path;
            break;
          case 100:
            asset = Assets.images.buildings.buryer.buryer100N.path;
            break;
        }
      case Directions.E:
        switch (fillPercentage) {
          case 0:
            asset = Assets.images.buildings.buryer.buryer0E.path;
            break;
          case 25:
            asset = Assets.images.buildings.buryer.buryer25E.path;
            break;
          case 50:
            asset = Assets.images.buildings.buryer.buryer50E.path;
            break;
          case 75:
            asset = Assets.images.buildings.buryer.buryer75E.path;
            break;
          case 100:
            asset = Assets.images.buildings.buryer.buryer100E.path;
            break;
        }
    }

    sprite = Sprite(game.images.fromCache(asset));
  }
}
