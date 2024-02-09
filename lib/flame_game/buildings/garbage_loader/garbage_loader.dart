import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_back.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';

import '../../utils/manage_coordinates.dart';

class GarbageLoader extends Building {
  GarbageLoaderFlow garbageLoaderFlow;
  Directions direction;
  GarbageLoader({required this.direction, required this.garbageLoaderFlow, super.position});

  final Vector2 offset = convertDimetricToWorldCoordinates(Vector2(2, 0)) + Vector2(10, 5);

  late final GarbageLoaderFront garbageLoaderFront;
  late final GarbageLoaderBack garbageLoaderBack;

  @override
  FutureOr<void> onLoad() {
    garbageLoaderFront = GarbageLoaderFront(direction: direction, garbageLoaderFlow: garbageLoaderFlow, position: position + offset);
    garbageLoaderBack = GarbageLoaderBack(direction: direction, position: position + offset);
    world.addAll([
      garbageLoaderFront,
      garbageLoaderBack,
    ]);

    return super.onLoad();
  }

  @override
  void changePosition(Vector2 newPosition) {
    position = newPosition;
    garbageLoaderFront.position = newPosition + offset;
    garbageLoaderBack.position = newPosition + offset;
  }
}
