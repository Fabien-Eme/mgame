import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../gen/assets.gen.dart';

class Truck extends PositionComponent with HasGameReference {
  double stackAngle = 0;
  late SpriteBatch spriteBatch;

  @override
  FutureOr<void> onLoad() {
    final spriteSheet = game.images.fromCache(Assets.images.truck.path);
    spriteBatch = SpriteBatch(spriteSheet);
    angle = pi / 2;

    // const double spriteWidth = 17; //hardcode width of sprite sheet cells
    // const double spriteHeight = 33; //hardcode height of sprite sheet cells
    // const sliceCount = 17;

    // for (int i = 0; i < sliceCount; i++) {
    //   spriteBatch.add(
    //     source: Rect.fromLTWH(0, spriteHeight * (sliceCount - i), spriteWidth, spriteHeight),
    //     offset: Vector2(-i.toDouble(), 0),
    //     anchor: Vector2(16.5, 8.5),
    //     rotation: stackAngle * radians2Degrees,
    //   );
    // }

    addSprites();
    SpriteBatchComponent spriteBatchComponent = SpriteBatchComponent(spriteBatch: spriteBatch);
    add(spriteBatchComponent);
    return super.onLoad();
  }

  void addSprites() {
    const double spriteWidth = 17; //hardcode width of sprite sheet cells
    const double spriteHeight = 33; //hardcode height of sprite sheet cells
    const sliceCount = 17;
    spriteBatch.clear();

    for (int i = 0; i < sliceCount; i++) {
      spriteBatch.add(
        source: Rect.fromLTWH(0, spriteHeight * (sliceCount - i), spriteWidth, spriteHeight),
        offset: Vector2(-i.toDouble(), 0),
        anchor: Vector2(8.5, 16.5),
        rotation: stackAngle * radians2Degrees,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    stackAngle += 0.0002;
    addSprites();
  }
}
