import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/convert_coordinates.dart';

class GarbageConveyorBack extends SpriteComponent with HasGameRef {
  GarbageConveyorBack({super.position});

  final Vector2 offset = convertDimetricVectorToWorldCoordinates(Vector2(2, 0)) + Vector2(-6, -3);

  @override
  FutureOr<void> onLoad() {
    position = position + offset;
    size = Vector2(266.66, 215.33);
    anchor = Anchor.bottomRight;
    priority = 90;

    sprite = Sprite(game.images.fromCache(Assets.images.buildings.garbageConveyor.garbageConveyorBack.path));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
