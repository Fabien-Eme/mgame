import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:mgame/flame_game/tile_helper.dart';
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
  Tile startingTile;
  late String id;

  Truck({required this.truckType, required this.truckDirection, required this.startingTile});

  Vector2 offset = Vector2(MGame.tileWidth / 2, MGame.tileHeight / 2) + Vector2(0, -10);
  late Tile currentTile;
  Tile? destinationTile;
  Directions? destinationTileDirection;

  double truckSpeed = 100;
  bool isTruckMoving = false;
  double baseAcceleration = 1;
  double acceleration = 1;

  double truckAngle = 0;
  String spriteImagePath = '';

  List<Point<int>> pathListCoordinates = [];
  Directions? directionAfterDestinationTile;

  ///

  bool isTurning = false;
  double turnTime = 0;

  ///

  @override
  FutureOr<void> onLoad() {
    id = const Uuid().v4();

    truckAngle = truckDirection.angle;

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
      startingTile = game.gridController.getTileAtDimetricCoordinates(pathListCoordinates[0])!;

      startMove();
    }
  }

  ///
  ///
  /// Get Direction that the truck will have exiting destination tile
  Directions getDirectionAfterDestinationTile(Tile currentTile, Tile destinationTile, Tile? tileAfterDestinationTile) {
    Directions entryDirection = game.gridController.getNeigbhorTileDirection(me: currentTile, neighbor: destinationTile)!;
    if (tileAfterDestinationTile == null) {
      return entryDirection;
    } else {
      Directions exitDirection = game.gridController.getNeigbhorTileDirection(me: destinationTile, neighbor: tileAfterDestinationTile)!;
      return exitDirection;
    }
  }

  ///
  ///
  /// Update truck sprite according to rotation
  void updateTruckSprite(double angle) {
    String newSpriteImagePath = getTruckAssetPath(truckType: truckType, truckAngle: angle);
    if (spriteImagePath != newSpriteImagePath) {
      sprite = Sprite(game.images.fromCache(newSpriteImagePath));
    }
  }

  ///
  ///
  /// Initiate move to a tile
  void startMove() {
    pathListCoordinates.removeAt(0);
    if (pathListCoordinates.isNotEmpty) {
      destinationTile = game.gridController.getTileAtDimetricCoordinates(pathListCoordinates[0])!;
      directionAfterDestinationTile = getDirectionAfterDestinationTile(
        currentTile,
        destinationTile!,
        game.gridController.getTileAtDimetricCoordinates((pathListCoordinates.length > 1) ? pathListCoordinates[1] : null),
      );
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

  /// Helper function to calculate the center of the turning arc
  Vector2 calculateTurnCenter(Vector2 entryPoint, bool isRightTurn, Vector2 tileSize) {
    // Assuming entryPoint is the bottom-left corner of the tile for this example
    double offsetX = tileSize.x / 2;
    double offsetY = tileSize.y / 2;
    if (isRightTurn) {
      return Vector2(entryPoint.x - offsetX, entryPoint.y);
    } else {
      return Vector2(entryPoint.x - offsetX, entryPoint.y - offsetY);
    }
  }

  /// Function to update the vehicle's position and rotation for the turn
  void updateVehicleForTurn(double deltaTime, Vector2 turnCenter, double startAngle, double endAngle, double turnDuration) {
    // Current progress of the turn, from 0 to 1
    double progress = min(turnTime / turnDuration, 1.0);
    turnTime += deltaTime;

    // Interpolate the s rotation
    truckAngle = lerpDouble(startAngle, endAngle, progress)!;

    // Calculate the new position along the circular arc
    double radius = position.distanceTo(turnCenter);
    double calculatedAngle = lerpDouble(startAngle, endAngle, progress)!;
    position = Vector2(turnCenter.x + radius * cos(calculatedAngle), turnCenter.y + radius * sin(calculatedAngle));

    // Check if the turn is completed
    if (progress >= 1.0) {
      hasTurned = true;
      isTurning = false; // Turn is complete
    }
  }

  late double startAngle;
  late double endAngle;
  bool hasTurned = false;

  int turnPhase = 1;
  late Vector2 turnCenter;
  double totalAngleTurned = 0;
  double initialAngle = 0;

  ///
  ///
  /// Update every game tick
  @override
  void update(double dt) {
    super.update(dt);

    if (isTruckMoving) {
      if ((truckDirection == directionAfterDestinationTile && turnPhase != 2 && turnPhase != 3) || turnPhase == 4) {
        /// Straight movement
        Vector2 destinationPosition = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset;
        Vector2 movementVector = destinationPosition - position;
        if (movementVector.length > 1) {
          moveStraight(movementVector: movementVector, dt: dt);
        } else {
          position = destinationPosition;
          completeMove();
          turnPhase = 1;
        }
      } else {
        /// Turn movement

        if (turnPhase == 1) {
          Vector2 destinationPosition = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset - Vector2(MGame.tileWidth / 4, MGame.tileHeight / 4);
          Vector2 movementVector = destinationPosition - position;
          if (movementVector.length > 1) {
            moveStraight(movementVector: movementVector, dt: dt);
          } else {
            position = destinationPosition;
            turnPhase = 2;
            totalAngleTurned = 0;
            turnCenter = destinationTile!.dimetricCoordinates.convertDimetricPointToWorldCoordinates() + offset - Vector2(MGame.tileWidth / 2, 0);
            Vector2 toTruckVector = position - turnCenter;
            initialAngle = atan2(toTruckVector.y, toTruckVector.x);
          }
        }
        if (turnPhase == 2 || turnPhase == 3) {
          double radius = position.distanceTo(turnCenter);
          double angularVelocity = truckSpeed / radius;
          double turnCompletion = angularVelocity * dt * 0.7;

          totalAngleTurned += turnCompletion;

          double newAngle = initialAngle + totalAngleTurned;
          position = turnCenter + Vector2(cos(newAngle), sin(newAngle)) * radius;

          if (totalAngleTurned >= pi / 16) {
            updateTruckSprite(truckAngle - pi / 8);
          }

          if (totalAngleTurned >= pi / 8) {
            updateTruckSprite(truckAngle - pi / 4);

            truckAngle = truckAngle - pi / 4;
            totalAngleTurned = 0;
            initialAngle = 0;
            if (turnPhase == 2) {
              turnPhase = 3;
              completeMove();
            } else {
              turnPhase = 4;
              totalAngleTurned = 0;
              initialAngle = 0;
              truckDirection = Directions.S;
            }
          }
        }
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
