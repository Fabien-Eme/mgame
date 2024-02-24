import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_back.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';

import '../../game.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';

class GarbageLoader extends Building {
  GarbageLoaderFlow garbageLoaderFlow;
  GarbageLoader({super.direction, required this.garbageLoaderFlow, super.position, required super.anchorTile});

  final Vector2 offset = convertDimetricVectorToWorldCoordinates(Vector2(2, 0)) + Vector2(10, 5);

  late final GarbageLoaderFront garbageLoaderFront;
  late final GarbageLoaderBack garbageLoaderBack;

  @override
  FutureOr<void> onLoad() async {
    garbageLoaderFront = GarbageLoaderFront(direction: direction, garbageLoaderFlow: garbageLoaderFlow, position: position + offset);
    garbageLoaderBack = GarbageLoaderBack(direction: direction, position: position + offset);
    await world.addAll([
      garbageLoaderFront,
      garbageLoaderBack,
    ]);

    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) {
    garbageLoaderFront.position = updatedPosition + offset;
    garbageLoaderBack.position = updatedPosition + offset;
  }

  @override
  void updateDirection(Directions updatedDirection) {
    garbageLoaderFront.updateDirection(updatedDirection);
    garbageLoaderBack.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    final int offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    garbageLoaderFront.priority = 110 + offsetPriority;
    garbageLoaderBack.priority = 90 + offsetPriority;
  }

  @override
  void renderAboveAll() {
    garbageLoaderFront.priority = 510;
    garbageLoaderBack.priority = 490;
  }

  @override
  BuildingType get buildingType => BuildingType.garbageLoader;

  @override
  int get sizeInTile => 1;

  @override
  void changeColor(Color color) {
    garbageLoaderFront.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    garbageLoaderBack.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    garbageLoaderFront.paint.colorFilter = null;
    garbageLoaderBack.paint.colorFilter = null;
  }

  @override
  void makeTransparent() {
    garbageLoaderFront.opacity = 0.8;
    garbageLoaderBack.opacity = 0.8;
  }

  @override
  void initialize() {
    garbageLoaderFront.animationTicker!.paused = true;
    garbageLoaderFront.animationTicker!.setToLast();
  }

  @override
  void closeDoor() {
    if (garbageLoaderFront.isAnimationReversed) {
      int currentIndex = garbageLoaderFront.animationTicker!.currentIndex;
      garbageLoaderFront.animation = garbageLoaderFront.animation!.reversed();
      garbageLoaderFront.animationTicker!.currentIndex = garbageLoaderFront.spriteAmount - 1 - currentIndex;
      garbageLoaderFront.animationTicker!.paused = false;
      garbageLoaderFront.isAnimationReversed = false;
    } else {
      garbageLoaderFront.animationTicker!.paused = false;
    }
  }

  @override
  void openDoor() {
    if (garbageLoaderFront.isAnimationReversed) {
      garbageLoaderFront.animationTicker!.paused = false;
    } else {
      int currentIndex = garbageLoaderFront.animationTicker!.currentIndex;
      garbageLoaderFront.animation = garbageLoaderFront.animation!.reversed();
      garbageLoaderFront.animationTicker!.currentIndex = garbageLoaderFront.spriteAmount - 1 - currentIndex;
      garbageLoaderFront.animationTicker!.paused = false;
      garbageLoaderFront.isAnimationReversed = true;
    }
  }

  @override
  void onRemove() {
    world.remove(garbageLoaderFront);
    world.remove(garbageLoaderBack);
    super.onRemove();
  }
}
