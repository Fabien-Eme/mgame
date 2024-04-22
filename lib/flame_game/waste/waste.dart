import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import '../../gen/assets.gen.dart';
import '../buildings/building.dart';
import '../game.dart';
import 'circle_background.dart';
import 'number_display.dart';

class Waste extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin, IgnoreEvents {
  Building anchorBuilding;
  NumberDisplay? numberDisplay;
  bool hasNumber;
  WasteType wasteType;
  int startingValue;

  Waste({required this.wasteType, required this.anchorBuilding, this.hasNumber = false, required this.startingValue});

  late final WasteComponent wasteComponent;

  Point<int> dimetricCoordinates = const Point<int>(0, 0);
  late final CircleBackground circleBackground;

  @override
  FutureOr<void> onLoad() {
    circleBackground = CircleBackground(radius: 30)..priority = 397;
    world.add(
      circleBackground,
    );

    wasteComponent = WasteComponent(wasteType: wasteType)..priority = 398;
    world.add(
      wasteComponent,
    );

    if (hasNumber) {
      numberDisplay = NumberDisplay(radius: 20, wasteType: wasteType)..priority = 399;
      world.add(numberDisplay!);

      changeNumber(startingValue);
    }
    return super.onLoad();
  }

  void changeNumber(int stackQuantity) {
    if (hasNumber) numberDisplay!.changeNumber(stackQuantity);
    if (hasNumber && stackQuantity > 0) {
      blink();
    }
  }

  void blink() {
    wasteComponent.add(
      ScaleEffect.to(
        Vector2.all(1.3),
        EffectController(duration: 0.1),
        onComplete: () {
          wasteComponent.add(
            ScaleEffect.to(
              Vector2.all(1.0),
              EffectController(duration: 0.1),
            ),
          );
        },
      ),
    );
  }

  @override
  void onRemove() {
    if (wasteComponent.ancestors().isNotEmpty) {
      world.remove(wasteComponent);
      world.remove(circleBackground);
      if (hasNumber && numberDisplay != null) world.remove(numberDisplay!);
    }
    super.onRemove();
  }

  @override
  set position(Vector2 updatedPosition) {
    super.position = updatedPosition;
    wasteComponent.position = updatedPosition;
    circleBackground.position = updatedPosition;
    numberDisplay?.position = updatedPosition + Vector2(30, -30);
  }

  void stopPollutionGeneration() {
    if (hasNumber) numberDisplay!.stopPollutionGeneration();
  }

  void updatePriority(int priority) {
    // wasteComponent.priority = priority + 1;
    // circleBackground.priority = priority;
    // numberDisplay?.priority = priority + 2;
  }

  void animateWasteTo({required int quantity, required Point<int> to}) async {
    for (int i = 0; i < -quantity; i++) {
      world.add(WasteComponent(wasteType: wasteType, isAnimated: true, from: position, to: convertDimetricPointToWorldCoordinates(world.convertRotations.rotateCoordinates(to)) + Vector2(25, 25))
        ..priority = 900);
      await Future.delayed(const Duration(milliseconds: 60));
    }
  }
}

class WasteComponent extends SpriteComponent with HasGameReference {
  WasteType wasteType;
  bool isAnimated;
  Vector2? from;
  Vector2? to;

  WasteComponent({required this.wasteType, this.isAnimated = false, this.from, this.to});

  double progress = 0;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    sprite = Sprite(game.images.fromCache(wasteType.asset));

    if (isAnimated) scale = Vector2.all(0.7);

    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isAnimated && progress < 1) {
      progress += 2 * dt;
      if (progress >= 1) progress = 1;
      moveWasteFromTo(from!, to!, progress);
    }

    if (progress == 1) {
      removeFromParent();
    }
    super.update(dt);
  }

  ///
  ///
  /// Interpolate movement
  void moveWasteFromTo(Vector2 startingPosition, Vector2 targetPosition, double progress) {
    Vector2 offset = Vector2(
      ((targetPosition.x - startingPosition.x) * pow(progress, 5)),
      ((targetPosition.y - startingPosition.y) * pow(progress, 5)),
    );
    position = startingPosition + offset;
  }
}

enum WasteType {
  garbageCan,
  recyclable,
  organic,
  toxic,
  ultimate;

  String get asset {
    switch (this) {
      case WasteType.garbageCan:
        return Assets.images.waste.garbageCanSmall.path;
      case WasteType.recyclable:
        return Assets.images.waste.recyclableSmall.path;
      case WasteType.organic:
        return Assets.images.waste.organicSmall.path;
      case WasteType.toxic:
        return Assets.images.waste.toxicSmall.path;
      case WasteType.ultimate:
        return Assets.images.waste.ultimateSmall.path;
    }
  }

  int get pollutionGenerated {
    switch (this) {
      case WasteType.garbageCan:
        return 50;
      case WasteType.recyclable:
        return 30;
      case WasteType.organic:
        return 20;
      case WasteType.toxic:
        return 100;
      case WasteType.ultimate:
        return 50;
    }
  }
}
