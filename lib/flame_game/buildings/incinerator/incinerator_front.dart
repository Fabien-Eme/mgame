import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class IncineratorFront extends SpriteComponent with HasGameRef {
  IncineratorFront({required this.direction, super.position});
  final Directions direction;

  @override
  FutureOr<void> onLoad() {
    String asset;
    if (direction == Directions.E) {
      asset = Assets.images.buildings.incinerator.incineratorEFront.path;
    } else {
      asset = Assets.images.buildings.incinerator.incineratorSFront.path;
    }

    size = Vector2(300, 312);
    priority = 110;
    anchor = Anchor.bottomRight;

    sprite = Sprite(game.images.fromCache(asset));
    paint = Paint()..filterQuality = FilterQuality.low;
    // paint.color = paint.color.withAlpha(100);

    return super.onLoad();
  }
}
