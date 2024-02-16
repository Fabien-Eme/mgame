import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';

import '../../game.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';
import 'garage_back.dart';
import 'garage_door.dart';
import 'garage_front.dart';

class Garage extends Building {
  Garage({super.direction, super.position, required super.anchorTile});

  late final GarageFront garageFront;
  late final GarageBack garageBack;
  late final GarageDoor garageDoor;
  late final Vector2 offset;

  @override
  FutureOr<void> onLoad() {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(3, 1)) + Vector2(0, 2);

    garageFront = GarageFront(direction: direction, position: position + offset);
    garageBack = GarageBack(direction: direction, position: position + offset);
    garageDoor = GarageDoor(direction: direction, position: position + offset);

    world.addAll([
      garageFront,
      garageBack,
      garageDoor,
    ]);

    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) {
    garageFront.position = updatedPosition + offset;
    garageBack.position = updatedPosition + offset;
    garageDoor.position = updatedPosition + offset;
  }

  @override
  void updateDirection(Directions updatedDirection) {
    garageFront.updateDirection(updatedDirection);
    garageBack.updateDirection(updatedDirection);
    garageDoor.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    final int offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    garageFront.priority = 110 + offsetPriority;
    garageBack.priority = 90 + offsetPriority;
    garageDoor.priority = 110 + offsetPriority;
  }

  @override
  void renderAboveAll() {
    garageFront.priority = 510;
    garageBack.priority = 490;
    garageDoor.priority = 511;
  }

  @override
  BuildingType get buildingType => BuildingType.garage;

  @override
  int get sizeInTile => 3;

  @override
  void changeColor(Color color) {
    garageFront.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    garageBack.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    garageDoor.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    garageFront.paint.colorFilter = null;
    garageBack.paint.colorFilter = null;
    garageDoor.paint.colorFilter = null;
    super.resetColor();
  }

  @override
  void makeTransparent() {
    garageFront.opacity = 0.8;
    garageBack.opacity = 0.8;
    garageDoor.opacity = 0.8;
  }

  @override
  void onRemove() {
    world.remove(garageFront);
    world.remove(garageBack);
    world.remove(garageDoor);
    super.onRemove();
  }
}