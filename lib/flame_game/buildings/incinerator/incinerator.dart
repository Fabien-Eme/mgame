import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_back.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_front.dart';

import '../../game.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';
import 'incinerator_door.dart';

class Incinerator extends Building {
  Incinerator({super.direction, super.position, required super.anchorTile});

  late final IncineratorFront incineratorFront;
  late final IncineratorBack incineratorBack;
  late final IncineratorDoor incineratorDoor;
  late final Vector2 offset;

  @override
  FutureOr<void> onLoad() {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(3, 1)) + Vector2(0, 2);

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
  void updatePosition(Vector2 updatedPosition) {
    incineratorFront.position = updatedPosition + offset;
    incineratorBack.position = updatedPosition + offset;
    incineratorDoor.position = updatedPosition + offset;
  }

  @override
  void updateDirection(Directions updatedDirection) {
    incineratorFront.updateDirection(updatedDirection);
    incineratorBack.updateDirection(updatedDirection);
    incineratorDoor.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    final int offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    incineratorFront.priority = 110 + offsetPriority;
    incineratorBack.priority = 90 + offsetPriority;
    incineratorDoor.priority = 110 + offsetPriority;
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
