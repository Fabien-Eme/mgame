import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:mgame/flame_game/controller/task_controller.dart';
import 'package:mgame/flame_game/particle/truck_smoke.dart';
import 'package:mgame/flame_game/truck/truck_helper.dart';
import 'package:mgame/flame_game/ui/pollution_bar.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';
import 'package:flame/timer.dart' as flame_timer;

import '../buildings/building.dart';
import '../buildings/garage/garage.dart';
import '../game.dart';
import '../level_world.dart';
import '../riverpod_controllers/rotation_controller.dart';
import '../tile/tile.dart';
import '../utils/convert_rotations.dart';
import 'truck_model.dart';

class Truck extends SpriteComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  TruckType truckType;
  Directions truckDirection;

  Tile? startingTileAtCreation;
  Point<int>? startingTileCoordinatesAtCreation;

  late Tile startingTile;
  late Point<int> startingTileCoordinates;
  String id;

  Truck({required this.id, required this.truckType, required this.truckDirection, this.startingTileAtCreation, this.startingTileCoordinatesAtCreation});
  Vector2 offsetTile = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2);
  Vector2 offsetAdjust = Vector2(0, -10);
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

  late flame_timer.Timer timerGoToDepot;

  Vector2 realPosition = Vector2(0, 0);

  bool isGoingToDepot = false;
  late final TruckSmoke truckSmoke;

  ///
  ///
  /// Load Component
  @override
  FutureOr<void> onLoad() {
    startingTileAtCreation ??= world.gridController.getRealTileAtDimetricCoordinates(startingTileCoordinatesAtCreation!)!;
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
    add(truckSmoke = TruckSmoke(rate: truckType.model.pollutionPerTile)..position = position);

    updatePosition(startingTile.dimetricCoordinates.convertDimetricPointToWorldCoordinates());
    updateTruckSprite(truckDirection.angle);
    paint = Paint()..filterQuality = FilterQuality.low;

    timerGoToDepot = flame_timer.Timer(1, autoStart: false, onTick: () => goToDepot());

    return super.onLoad();
  }

  ///
  ///
  /// Mount Component
  /// Initialize rotation listener
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          updatePosition(realPosition);

          updateTruckSprite(truckDirection.angle);
        }));
    super.onMount();
  }

  void updatePosition(Vector2 newPosition) {
    realPosition = newPosition;

    position = world.convertRotations.rotateVector(newPosition + offsetTile) + offsetAdjust;
    truckSmoke.position = position;
  }

  ///
  ///
  /// Go to Depot
  void goToDepot() {
    goToTile(finishTile: world.gridController.getRealTileAtDimetricCoordinates(world.buildings.whereType<Garage>().first.spawnPointDimetric)!, toDepot: true);
  }

  ///
  ///
  /// Go to designed [Tile]
  bool goToTile({required Tile finishTile, bool toDepot = false}) {
    isGoingToDepot = toDepot;
    // print('start: ${currentTile.dimetricCoordinates} , finish: ${finishTile.dimetricCoordinates}');
    pathListCoordinates = world.aStarController.findPathAStar(currentTile.dimetricCoordinates, finishTile.dimetricCoordinates);
    // print(pathListCoordinates);
    if (pathListCoordinates.isNotEmpty) {
      currentTile = world.gridController.getRealTileAtDimetricCoordinates(pathListCoordinates[0])!;
      startMove();
      return true;
    }
    return false;
  }

  ///
  ///
  /// Update truck sprite according to rotation
  void updateTruckSprite(double angle) {
    String newSpriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: world.convertRotations.rotateAngle(angle));

    if (spriteImagePath != newSpriteImagePath) {
      spriteImagePath = newSpriteImagePath;
      sprite = Sprite(game.images.fromCache(spriteImagePath));
    }
  }

  ///
  ///
  /// Initiate move to a tile
  void startMove() {
    truckSmoke.resumeSmoke();
    if (pathListCoordinates.isEmpty) {
      stopMovement();
    } else {
      pathListCoordinates.removeAt(0);
      if (pathListCoordinates.isNotEmpty) {
        destinationTile = world.gridController.getRealTileAtDimetricCoordinates(pathListCoordinates[0])!;
        Directions destinationTileDirection = world.gridController.getNeigbhorTileDirection(me: currentTile, neighbor: destinationTile!)!;

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

    (game.findByKeyName('pollutionBar') as PollutionBar).addValue(truckType.model.pollutionPerTile.toDouble());

    startMove();
  }

  ///
  ///
  /// End the whole movement
  void endMovement() {
    truckSmoke.stopSmoke();
    startingTile = currentTile;
    if (currentTask != null && !isCompletingTask) {
      isCompletingTask = true;
      world.truckController.completeTask(truck: this, task: currentTask!);
    }
  }

  stopMovement() {
    truckSmoke.stopSmoke();
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
        if (goToTile(finishTile: world.gridController.getRealTileAtDimetricCoordinates(currentTask!.taskCoordinate)!)) {
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
          Vector2 destinationPosition = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates();
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
    priority = 100 + ((position.y) / MGame.gameHeight * 100).toInt();
    acceleration = (acceleration + acceleration * dt).clamp(0, 5);
  }
}
