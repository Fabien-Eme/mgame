import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mgame/flame_game/controller/task_controller.dart';
import 'package:mgame/flame_game/truck/truck_helper.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';
import 'package:uuid/uuid.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/convert_rotations.dart';
import 'truck_model.dart';

class Truck extends SpriteComponent with HasGameReference<MGame> {
  TruckType truckType;
  Directions truckDirection;

  Tile? startingTileAtCreation;
  Point<int>? startingTileCoordinatesAtCreation;

  late Tile startingTile;
  late Point<int> startingTileCoordinates;
  late String id;

  Truck({required this.truckType, required this.truckDirection, this.startingTileAtCreation, this.startingTileCoordinatesAtCreation});

  Vector2 offset = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2) + Vector2(0, -10);
  late Tile currentTile;
  Tile? destinationTile;

  double truckSpeed = 100;
  bool isTruckMoving = false;
  double acceleration = 1;

  String spriteImagePath = '';

  List<Point<int>> pathListCoordinates = [];

  Task? currentTask;
  int priorityForTask = 0;
  LoadType? loadType;
  int loadQuantity = 0;
  VehiculeType vehiculeType = VehiculeType.truck;

  @override
  FutureOr<void> onLoad() {
    id = const Uuid().v4();

    startingTileAtCreation ??= game.gridController.getTileAtDimetricCoordinates(startingTileCoordinatesAtCreation!)!;
    startingTileCoordinatesAtCreation ??= startingTileAtCreation!.dimetricCoordinates;

    startingTile = startingTileAtCreation!;
    startingTileCoordinates = startingTileCoordinatesAtCreation!;

    currentTile = startingTile;
    currentTile.listTrucksOnTile.add(this);

    priority = 100;
    anchor = Anchor.center;
    scale = Vector2.all(0.6);
    spriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: truckDirection.angle);
    sprite = Sprite(game.images.fromCache(spriteImagePath));
    position = startingTile.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset;
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }

  ///
  ///
  /// Go to designed [Tile]
  void goToTile(Tile finishTile) {
    pathListCoordinates = game.aStarController.findPathAStar(currentTile.dimetricCoordinates, finishTile.dimetricCoordinates);

    if (pathListCoordinates.isNotEmpty) {
      currentTile = game.gridController.getTileAtDimetricCoordinates(pathListCoordinates[0])!;
      startMove();
    }
  }

  ///
  ///
  /// Update truck sprite according to rotation
  void updateTruckSprite(double angle) {
    String newSpriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: angle);
    if (spriteImagePath != newSpriteImagePath) {
      spriteImagePath = newSpriteImagePath;
      sprite = Sprite(game.images.fromCache(spriteImagePath));
    }
  }

  ///
  ///
  /// Initiate move to a tile
  void startMove() {
    pathListCoordinates.removeAt(0);
    if (pathListCoordinates.isNotEmpty) {
      destinationTile = game.gridController.getTileAtDimetricCoordinates(pathListCoordinates[0])!;
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
  }

  ///
  ///
  /// Update every game tick
  @override
  void update(double dt) {
    super.update(dt);

    if (isTruckMoving) {
      Vector2 destinationPosition = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset;
      Vector2 movementVector = destinationPosition - position;
      if (movementVector.length > truckSpeed * dt) {
        moveStraight(movementVector: movementVector, dt: dt);
      } else {
        position = destinationPosition;
        completeMove();
      }
    }
  }

  void moveStraight({required Vector2 movementVector, required double dt}) {
    movementVector.normalize();
    double truckSpeedCorrected = (startingTile == currentTile || acceleration != 5) ? truckSpeed * acceleration / 5 : truckSpeed;
    position += movementVector * truckSpeedCorrected * dt;
    acceleration = (acceleration + acceleration * dt).clamp(0, 5);
  }
}
