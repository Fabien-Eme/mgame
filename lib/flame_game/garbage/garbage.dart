import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/level_world.dart';

import '../buildings/building.dart';
import '../game.dart';
import 'garbage_can.dart';

abstract class Garbage extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin, IgnoreEvents {
  Building anchorBuilding;
  bool hasNumber;

  Garbage({
    required this.anchorBuilding,
    this.hasNumber = false,
  });

  Point<int> dimetricCoordinates = const Point<int>(0, 0);

  @mustBeOverridden
  GarbageType get garbageType;

  @override
  @mustBeOverridden
  set position(Vector2 position) => transform.position = position;

  @mustBeOverridden
  @override
  void onRemove() {
    super.onRemove();
  }

  void changeNumber(int stackQuantity) {}
}

Garbage createGarbage({required GarbageType garbageType, required Building anchorBuilding, bool hasNumber = false}) {
  return switch (garbageType) {
    GarbageType.garbageCan => GarbageCan(anchorBuilding: anchorBuilding, hasNumber: hasNumber),
  };
}

enum GarbageType {
  garbageCan;
}
