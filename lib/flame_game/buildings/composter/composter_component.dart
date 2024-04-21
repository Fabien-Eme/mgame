import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../utils/convert_rotations.dart';

class ComposterComponent extends SpriteComponent with HasGameReference<MGame> {
  int fillCapacity;
  int fillAmount;

  ComposterComponent({required this.direction, required this.fillCapacity, required this.fillAmount, super.position});
  Directions direction;

  @override
  FutureOr<void> onLoad() {
    priority = 110;
    anchor = Anchor.center;
    scale = Vector2(0.25, 0.25);
    sprite = Sprite(game.images.fromCache(Assets.images.buildings.composter.composter.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}
