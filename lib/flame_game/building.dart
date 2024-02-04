import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/garbage_conveyor/garbage_conveyor_back.dart';
import 'package:mgame/flame_game/buildings/garbage_conveyor/garbage_conveyor_front.dart';

class Building extends SpriteComponent with HasGameRef {
  final BuildingType buildingType;

  Building({required this.buildingType, super.position});

  @override
  FutureOr<void> onLoad() {
    addAll(buildingType.components);

    return super.onLoad();
  }
}

enum BuildingType {
  garbageLoader;

  List<Component> get components {
    return switch (this) {
      BuildingType.garbageLoader => [GarbageConveyorFront(), GarbageConveyorBack()],
    };
  }
}
