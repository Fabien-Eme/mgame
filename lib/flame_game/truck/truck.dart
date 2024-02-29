import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mgame/flame_game/controller/task_controller.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/truck/truck_helper.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import '../buildings/building.dart';
import '../buildings/garage/garage.dart';
import '../game.dart';
import '../riverpod_controllers/rotation_controller.dart';
import '../tile.dart';
import '../utils/convert_rotations.dart';
import 'truck_model.dart';

class Truck extends SpriteComponent with HasGameReference<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  TruckType truckType;
  Directions truckDirection;

  Tile? startingTileAtCreation;
  Point<int>? startingTileCoordinatesAtCreation;

  late Tile startingTile;
  late Point<int> startingTileCoordinates;
  String id;

  Truck({required this.id, required this.truckType, required this.truckDirection, this.startingTileAtCreation, this.startingTileCoordinatesAtCreation});

  Vector2 offset = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2) + Vector2(0, -10);
  late Tile currentTile;
  Tile? destinationTile;

  double truckSpeed = 100;
  bool isTruckMoving = false;
  double acceleration = 1;

  String spriteImagePath = '';

  List<Point<int>> pathListCoordinates = [];

  Task? currentTask;
  bool isCompletingTask = false;
  int priorityForTask = 0;
  LoadType? loadType;
  int loadQuantity = 0;
  VehiculeType vehiculeType = VehiculeType.truck;
  late int maxLoad;

  late Timer timerGoToDepot;

  Vector2 realPosition = Vector2(0, 0);

  bool isGoingToDepot = false;

  ///
  ///
  /// Load Component
  @override
  FutureOr<void> onLoad() {
    startingTileAtCreation ??= game.gridController.getRealTileAtDimetricCoordinates(startingTileCoordinatesAtCreation!)!;
    startingTileCoordinatesAtCreation ??= startingTileAtCreation!.dimetricCoordinates;

    startingTile = startingTileAtCreation!;
    startingTileCoordinates = startingTileCoordinatesAtCreation!;

    currentTile = startingTile;
    currentTile.listTrucksOnTile.add(this);

    maxLoad = truckType.model.maxLoad;

    priority = 100;
    anchor = Anchor.center;
    scale = Vector2.all(0.6);
    spriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: truckDirection.angle);
    sprite = Sprite(game.images.fromCache(spriteImagePath));
    setPosition(startingTile.dimetricCoordinates.convertDimetricPointToWorldCoordinates());
    updateTruckSprite(truckDirection.angle);
    paint = Paint()..filterQuality = FilterQuality.low;

    timerGoToDepot = Timer(1, autoStart: false, onTick: () => goToDepot());
    return super.onLoad();
  }

  ///
  ///
  /// Mount Component
  /// Initialize rotation listener
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          // if (value == Rotation.pi || value == Rotation.piAndHalf) {
          //   offset = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2) + Vector2(0, 10);
          //   position = position + Vector2(0, 10);
          // } else {
          //   offset = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2) + Vector2(0, -10);
          // }

          updatePosition(realPosition);

          updateTruckSprite(truckDirection.angle);
        }));

    super.onMount();
  }

  void setPosition(Vector2 newPosition) {
    realPosition = newPosition;

    position = game.convertRotations.rotateVector(newPosition + offset);
  }

  void updatePosition(Vector2 newPosition) {
    realPosition = newPosition;

    position = game.convertRotations.rotateVector(newPosition);
  }

  ///
  ///
  /// Go to Depot
  void goToDepot() {
    goToTile(finishTile: game.gridController.getRealTileAtDimetricCoordinates(world.buildings.whereType<Garage>().first.spawnPointDimetric)!, toDepot: true);
  }

  ///
  ///
  /// Go to designed [Tile]
  bool goToTile({required Tile finishTile, bool toDepot = false}) {
    isGoingToDepot = toDepot;
    // print('start: ${currentTile.dimetricCoordinates} , finish: ${finishTile.dimetricCoordinates}');
    pathListCoordinates = game.aStarController.findPathAStar(currentTile.dimetricCoordinates, finishTile.dimetricCoordinates);
    // print(pathListCoordinates);
    if (pathListCoordinates.isNotEmpty) {
      currentTile = game.gridController.getRealTileAtDimetricCoordinates(pathListCoordinates[0])!;
      startMove();
      return true;
    }
    return false;
  }

  ///
  ///
  /// Update truck sprite according to rotation
  void updateTruckSprite(double angle) {
    String newSpriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: game.convertRotations.rotateAngle(angle));

    if (spriteImagePath != newSpriteImagePath) {
      spriteImagePath = newSpriteImagePath;
      sprite = Sprite(game.images.fromCache(spriteImagePath));
    }
  }

  ///
  ///
  /// Initiate move to a tile
  void startMove() {
    if (pathListCoordinates.isEmpty) {
      stopMovement();
    } else {
      pathListCoordinates.removeAt(0);
      if (pathListCoordinates.isNotEmpty) {
        destinationTile = game.gridController.getRealTileAtDimetricCoordinates(pathListCoordinates[0])!;
        Directions destinationTileDirection = game.gridController.getNeigbhorTileDirection(me: currentTile, neighbor: destinationTile!)!;

        if (destinationTileDirection != truckDirection) {
          truckDirection = destinationTileDirection;
          updateTruckSprite(truckDirection.angle);
        }

        isTruckMoving = true;
      } else {
        endMovement();
      }
    }
  }

  ///
  ///
  /// Complete moving to a tile
  void completeMove() {
    isTruckMoving = false;
    currentTile = destinationTile!;
    destinationTile = null;

    startMove();
  }

  ///
  ///
  /// End the whole movement
  void endMovement() {
    startingTile = currentTile;
    if (currentTask != null && !isCompletingTask) {
      isCompletingTask = true;
      game.truckController.completeTask(truck: this, task: currentTask!);
    }
  }

  stopMovement() {
    isTruckMoving = false;
    startingTile = currentTile;
  }

  ///
  ///
  /// Affect [Task] to truck
  void affectTask(Task task) {
    currentTask = task;
  }

  ///
  ///
  /// Update every game tick
  @override
  void update(double dt) {
    super.update(dt);
    timerGoToDepot.update(dt);

    if (!isTruckMoving) {
      if (currentTask != null) {
        if (goToTile(finishTile: game.gridController.getRealTileAtDimetricCoordinates(currentTask!.taskCoordinate)!)) {
          timerGoToDepot.stop();
        }
      } else {
        if (!timerGoToDepot.finished) timerGoToDepot.resume();
      }
    }

    if (isTruckMoving) {
      if (!isGoingToDepot && currentTask == null) {
        timerGoToDepot.stop();
        goToDepot();
      } else {
        timerGoToDepot.stop();
        bool canMove = true;

        List<Building> listBuilding = world.buildings.where((building) => building.listTilesWithDoor.isNotEmpty).toList();
        for (Building building in listBuilding) {
          if (building.listTilesWithDoor.contains(currentTile.dimetricCoordinates) && building.listTilesWithDoor.contains(destinationTile!.dimetricCoordinates)) {
            if (building.isDoorClosed) {
              canMove = false;
              building.openDoor();
            }
          }
        }

        if (canMove) {
          Vector2 destinationPosition = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset;
          Vector2 movementVector = destinationPosition - realPosition;
          // movementVector = game.convertRotations.rotateVector(movementVector);
          if (movementVector.length > truckSpeed * dt) {
            moveStraight(movementVector: movementVector, dt: dt);
          } else {
            updatePosition(destinationPosition);
            completeMove();
          }
        }
      }
    }
  }

  void moveStraight({required Vector2 movementVector, required double dt}) {
    movementVector.normalize();
    double truckSpeedCorrected = (startingTile == currentTile || acceleration != 5) ? truckSpeed * acceleration / 5 : truckSpeed;
    updatePosition(realPosition + movementVector * truckSpeedCorrected * dt);
    priority = 100 + ((position.y + offset.y) / MGame.gameHeight * 100).toInt();
    acceleration = (acceleration + acceleration * dt).clamp(0, 5);
  }
}
