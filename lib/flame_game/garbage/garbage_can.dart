import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/garbage/garbage.dart';
import 'package:mgame/flame_game/garbage/number_display.dart';

import '../../gen/assets.gen.dart';
import 'circle_background.dart';

class GarbageCan extends Garbage {
  GarbageCan({required super.anchorBuilding, super.hasNumber});

  late final GarbageCanComponent garbageCanComponent;
  late final CircleBackground circleBackground;
  NumberDisplay? numberDisplay;

  @override
  FutureOr<void> onLoad() {
    circleBackground = CircleBackground(radius: 35);
    world.add(
      circleBackground,
    );

    garbageCanComponent = GarbageCanComponent();
    world.add(
      garbageCanComponent,
    );

    if (hasNumber) {
      numberDisplay = NumberDisplay(radius: 20);
      world.add(numberDisplay!);
    }

    return super.onLoad();
  }

  @override
  GarbageType get garbageType => GarbageType.garbageCan;

  @override
  void onRemove() {
    if (garbageCanComponent.ancestors().isNotEmpty) {
      world.remove(garbageCanComponent);
      world.remove(circleBackground);
      if (hasNumber) world.remove(numberDisplay!);
    }
    super.onRemove();
  }

  @override
  set position(Vector2 updatedPosition) {
    super.position = updatedPosition;
    garbageCanComponent.position = updatedPosition;
    circleBackground.position = updatedPosition;
    numberDisplay?.position = updatedPosition + Vector2(30, -30);
  }

  @override
  void changeNumber(int stackQuantity) {
    super.changeNumber(stackQuantity);
    if (hasNumber) numberDisplay!.changeNumber(stackQuantity);
  }

  @override
  void stopPollutionGeneration() {
    if (hasNumber) numberDisplay!.stopPollutionGeneration();
  }
}

class GarbageCanComponent extends SpriteComponent with HasGameReference {
  GarbageCanComponent();

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(36, 50);
    priority = 200;
    sprite = Sprite(game.images.fromCache(Assets.images.garbage.garbageCanSmall.path));

    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }
}
