import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../gen/assets.gen.dart';
import 'truck_model.dart';

class TruckStacked extends PositionComponent with HasGameReference {
  TruckType truckType;
  TruckStacked({this.truckType = TruckType.yellow});

  double stackAngle = 0;
  late SpriteBatch spriteBatch;
  late SpriteBatchComponent spriteBatchComponent;
  late Image spriteSheet;

  @override
  FutureOr<void> onLoad() {
    spriteSheet = getSpriteSheet();
    spriteBatch = SpriteBatch(spriteSheet);
    angle = pi / 2;

    addSprites();
    spriteBatchComponent = SpriteBatchComponent(spriteBatch: spriteBatch, paint: Paint()..filterQuality = FilterQuality.none);
    add(spriteBatchComponent);
    return super.onLoad();
  }

  void addSprites() {
    const double spriteWidth = 17;
    const double spriteHeight = 33;
    const sliceCount = 17;
    spriteBatch.clear();

    for (int i = 0; i <= sliceCount; i++) {
      spriteBatch.add(
        source: Rect.fromLTWH(0, spriteHeight * (sliceCount - i), spriteWidth, spriteHeight),
        offset: Vector2(-i.toDouble() * 0.8, 0),
        anchor: Vector2(8.5, 16.5),
        rotation: stackAngle,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    stackAngle += 0.4 * dt;
    addSprites();
  }

  Image getSpriteSheet() {
    switch (truckType) {
      case TruckType.yellow:
        return game.images.fromCache(Assets.images.trucks.stacked.truckYStacked.path);
      case TruckType.blue:
        return game.images.fromCache(Assets.images.trucks.stacked.truckBStacked.path);
      case TruckType.purple:
        return game.images.fromCache(Assets.images.trucks.stacked.truckPStacked.path);
    }
  }

  void updateTruckType(TruckType newTruckType) {
    truckType = newTruckType;
    spriteSheet = getSpriteSheet();
    spriteBatch.atlas = spriteSheet;
  }

  void nextTruckType() {
    final nextIndex = (truckType.index + 1) % TruckType.values.length;
    updateTruckType(TruckType.values[nextIndex]);
  }

  void previousTruckType() {
    final previousIndex = (truckType.index - 1) % TruckType.values.length;
    updateTruckType(TruckType.values[previousIndex]);
  }
}
