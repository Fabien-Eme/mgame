import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/manage_coordinates.dart';

class GarbageConveyorFront extends SpriteComponent with HasGameRef {
  GarbageConveyorFront({super.position});

  final Vector2 offset = convertDimetricToWorldCoordinates(Vector2(2, 0)) + Vector2(-6, -3);

  @override
  FutureOr<void> onLoad() {
    position = position + offset;
    size = Vector2(266.66, 215.33);
    anchor = Anchor.bottomRight;
    priority = 110;

    sprite = Sprite(game.images.fromCache(Assets.images.buildings.garbageConveyor.garbageConveyorFront.path));
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
