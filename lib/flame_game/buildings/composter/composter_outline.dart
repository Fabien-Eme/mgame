import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../utils/convert_rotations.dart';

class ComposterOutlineComponent extends SpriteComponent with HasGameReference<MGame> {
  ComposterOutlineComponent({required this.direction, super.position});
  Directions direction;

  @override
  FutureOr<void> onLoad() {
    priority = 109;
    anchor = Anchor.center;
    scale = Vector2(0.26, 0.26);

    sprite = Sprite(game.images.fromCache(Assets.images.buildings.composter.composterOutline.path));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
