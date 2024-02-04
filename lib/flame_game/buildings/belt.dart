import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';

class Belt extends PositionComponent with HasGameRef {
  Belt({required this.beltType, super.position});

  final BeltType beltType;

  @override
  FutureOr<void> onLoad() {
    priority = 100;
    final Vector2 globalOffset = (beltType == BeltType.beltWE) ? Vector2(11, -4.5) : Vector2(14, 8);

    final Vector2 localOffsetFirst = (beltType == BeltType.beltWE) ? Vector2(0, 0) : Vector2(25, -12.5);
    final Vector2 localOffsetSecond = (beltType == BeltType.beltWE) ? Vector2(25, 12.5) : Vector2(0, 0);

    position = position + globalOffset;
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache(beltType.path)),
        paint: Paint()..filterQuality = FilterQuality.low,
        position: localOffsetFirst,
        size: Vector2(50, 38),
      ),
    );
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache(beltType.path)),
        paint: Paint()..filterQuality = FilterQuality.low,
        position: localOffsetSecond,
        size: Vector2(50, 38),
      ),
    );
    return super.onLoad();
  }
}

enum BeltType {
  beltSN,
  beltWE;

  String get path {
    return switch (this) {
      BeltType.beltSN => Assets.images.buildings.beltSN.path,
      BeltType.beltWE => Assets.images.buildings.beltWE.path,
    };
  }
}
