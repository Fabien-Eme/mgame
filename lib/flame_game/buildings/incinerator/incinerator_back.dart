import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class IncineratorBack extends SpriteComponent with HasGameRef {
  IncineratorBack({required this.direction, super.position});
  final Directions direction;

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (direction == Directions.E) {
      asset = Assets.images.buildings.incinerator.incineratorEBack.path;
    } else {
      asset = Assets.images.buildings.incinerator.incineratorSBack.path;
    }

    size = Vector2(300, 312);
    priority = 90;
    anchor = Anchor.bottomRight;

    sprite = Sprite(game.images.fromCache(asset));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
