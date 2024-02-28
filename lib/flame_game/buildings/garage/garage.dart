import 'dart:async';
import 'dart:math';
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

  Point<int> spawnPointDimetric = const Point<int>(0, 0);
  late Timer timer;

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

    timer = Timer(2, autoStart: false, onTick: () => closeDoor());

    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) {
    garageFront.position = updatedPosition + offset;
    garageBack.position = updatedPosition + offset;
    garageDoor.position = updatedPosition + offset;

    spawnPointDimetric = game.convertRotations.rotateCoordinates(dimetricCoordinates + const Point<int>(-1, 1));

    listTilesWithDoor = [
      ...switch (direction) {
        Directions.S => [
            dimetricCoordinates + const Point<int>(-1, 0),
            dimetricCoordinates + const Point<int>(-1, 1),
          ],
        Directions.W => [
            dimetricCoordinates + const Point<int>(-2, 1),
            dimetricCoordinates + const Point<int>(-3, 1),
          ],
        Directions.N => [
            dimetricCoordinates + const Point<int>(-1, 2),
            dimetricCoordinates + const Point<int>(-1, 3),
          ],
        Directions.E => [
            dimetricCoordinates + const Point<int>(0, 1),
            dimetricCoordinates + const Point<int>(1, 1),
          ],
      }
    ];
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
  void initialize() {
    garageDoor.animationTicker!.paused = true;
  }

  @override
  void closeDoor() {
    isDoorClosed = true;
    isDoorOpen = false;

    if (garageDoor.isAnimationReversed) {
      garageDoor.animationTicker!.paused = false;
    } else {
      int currentIndex = garageDoor.animationTicker!.currentIndex;
      garageDoor.animation = garageDoor.animation!.reversed();
      garageDoor.animationTicker!.currentIndex = garageDoor.spriteAmount - 1 - currentIndex;
      garageDoor.animationTicker!.paused = false;
      garageDoor.isAnimationReversed = true;
    }
  }

  @override
  void openDoor() {
    if (garageDoor.isAnimationReversed) {
      int currentIndex = garageDoor.animationTicker!.currentIndex;
      garageDoor.animation = garageDoor.animation!.reversed();
      garageDoor.animationTicker!.currentIndex = garageDoor.spriteAmount - 1 - currentIndex;
      garageDoor.animationTicker!.paused = false;
      garageDoor.isAnimationReversed = false;
    } else {
      garageDoor.animationTicker!.paused = false;
    }

    garageDoor.animationTicker!.completed.then((_) {
      isDoorClosed = false;
      isDoorOpen = true;
      timer.start();
    });
  }

  @override
  void onRemove() {
    world.remove(garageFront);
    world.remove(garageBack);
    world.remove(garageDoor);
    super.onRemove();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }
}
