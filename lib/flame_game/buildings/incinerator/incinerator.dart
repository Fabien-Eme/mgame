import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_back.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_front.dart';

import '../../utils/manage_coordinates.dart';
import 'incinerator_door.dart';

class Incinerator extends Building {
  Incinerator({super.direction, super.position, required super.anchorTile});

  late final IncineratorFront incineratorFront;
  late final IncineratorBack incineratorBack;
  late final IncineratorDoor incineratorDoor;
  late final Vector2 offset;

  @override
  FutureOr<void> onLoad() {
    offset = convertDimetricToWorldCoordinates(Vector2(3, 1)) + Vector2(0, 2);

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

  @override
  void renderAboveAll() {
    incineratorFront.priority = 510;
    incineratorBack.priority = 490;
    incineratorDoor.priority = 511;
  }

  @override
  BuildingType get buildingType => BuildingType.incinerator;

  @override
  int get sizeInTile => 3;

  @override
  void changeColor(Color color) {
    incineratorFront.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    incineratorBack.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    incineratorDoor.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void makeTransparent() {
    incineratorFront.opacity = 0.8;
    incineratorBack.opacity = 0.8;
    incineratorDoor.opacity = 0.8;
  }

  @override
  void onRemove() {
    world.remove(incineratorFront);
    world.remove(incineratorBack);
    world.remove(incineratorDoor);
    super.onRemove();
  }
}
