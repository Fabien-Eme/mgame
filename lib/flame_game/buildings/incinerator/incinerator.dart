import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_back.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_front.dart';

import '../../utils/manage_coordinates.dart';
import 'incinerator_door.dart';

class Incinerator extends Building {
  Directions direction;
  Incinerator({required this.direction, super.position});

  late final IncineratorFront incineratorFront;
  late final IncineratorBack incineratorBack;
  late final IncineratorDoor incineratorDoor;
  late final Vector2 offset;

  @override
  FutureOr<void> onLoad() {
    if (direction == Directions.E) {
      offset = convertDimetricToWorldCoordinates(Vector2(3, 0)) + Vector2(0, 2);
    } else {
      offset = convertDimetricToWorldCoordinates(Vector2(4, 1)) + Vector2(0, 2);
    }

    incineratorFront = IncineratorFront(direction: direction, position: position + offset);
    incineratorBack = IncineratorBack(direction: direction, position: position + offset);
    incineratorDoor = IncineratorDoor(direction: direction, position: position + offset);

    world.addAll([
      incineratorFront,
      incineratorBack,
      incineratorDoor,
    ]);

    return super.onLoad();
  }

  @override
  void changePosition(Vector2 newPosition) {
    position = newPosition;
    incineratorFront.position = newPosition + offset;
    incineratorBack.position = newPosition + offset;
    incineratorDoor.position = newPosition + offset;
  }
}
