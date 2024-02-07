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

  @override
  FutureOr<void> onLoad() {
    GarbageLoaderFront garbageLoaderFront = GarbageLoaderFront(direction: direction, garbageLoaderFlow: garbageLoaderFlow, position: position + offset);
    GarbageLoaderBack garbageLoaderBack = GarbageLoaderBack(direction: direction, position: position + offset);
    world.addAll([
      garbageLoaderFront,
      garbageLoaderBack,
    ]);

    return super.onLoad();
  }

  @override
  void changePosition(Vector2 newPosition) {
    // TODO: implement changePosition
  }
}
