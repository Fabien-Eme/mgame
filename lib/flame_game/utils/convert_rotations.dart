import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../game.dart';
import '../game_world.dart';
import '../riverpod_controllers/rotation_controller.dart';

class ConvertRotations extends Component with HasGameReference<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  Rotation rotation = Rotation.zero;

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(rotationControllerProvider, (previous, value) {
          rotation = value;
        }));
    super.onMount();
  }

  Point<int> rotateCoordinates(Point<int> dimetricGridCoordinates) {
    switch (rotation) {
      case Rotation.zero:
        return dimetricGridCoordinates;
      case Rotation.halfPi:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) ~/ 2 - dimetricGridCoordinates.y, dimetricGridCoordinates.x - (GameWorld.gridHeight - 1) ~/ 2);
      case Rotation.pi:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) - dimetricGridCoordinates.x, -dimetricGridCoordinates.y);
      case Rotation.piAndHalf:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) ~/ 2 + dimetricGridCoordinates.y, (GameWorld.gridHeight - 1) ~/ 2 - dimetricGridCoordinates.x);
    }
  }

  Point<int> unRotateCoordinates(Point<int> dimetricGridCoordinates) {
    switch (rotation) {
      case Rotation.zero:
        return dimetricGridCoordinates;
      case Rotation.halfPi:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) ~/ 2 + dimetricGridCoordinates.y, (GameWorld.gridHeight - 1) ~/ 2 - dimetricGridCoordinates.x);
      case Rotation.pi:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) - dimetricGridCoordinates.x, -dimetricGridCoordinates.y);
      case Rotation.piAndHalf:
        return dimetricGridCoordinates = Point((GameWorld.gridHeight - 1) ~/ 2 - dimetricGridCoordinates.y, dimetricGridCoordinates.x - (GameWorld.gridHeight - 1) ~/ 2);
    }
  }

  Vector2 rotateVector(Vector2 vector) {
    // vector.rotate(rotation.angle, center: Vector2(MGame.gameWidth / 2, MGame.gameHeight / 2));
    // Vector2 adjustedVector = Vector2((MGame.gameWidth / 2 - vector.x) * 2, (MGame.gameHeight / 2 - vector.y) / 2);

    // return adjustedVector;

    // Vector2 center = Vector2(MGame.gameWidth / 2, MGame.gameHeight / 2);
    // Vector2 translatedVector = vector - center;
    // double cosTheta = cos(rotation.angle);
    // double sinTheta = sin(rotation.angle);
    // Vector2 rotatedVector = Vector2(
    //   translatedVector.x * cosTheta - translatedVector.y * sinTheta,
    //   translatedVector.x * sinTheta + translatedVector.y * cosTheta,
    // );

    // return rotatedVector + center;

    switch (rotation) {
      case Rotation.zero:
        return vector;
      case Rotation.piAndHalf:
        return Vector2(MGame.gameWidth / 2 + (MGame.gameHeight / 2 - vector.y) * 2, MGame.gameHeight / 2 - (MGame.gameWidth / 2 - vector.x) / 2);
      case Rotation.pi:
        return Vector2(MGame.gameWidth - vector.x, MGame.gameHeight - vector.y);
      case Rotation.halfPi:
        return Vector2(MGame.gameWidth / 2 - (MGame.gameHeight / 2 - vector.y) * 2, MGame.gameHeight / 2 + (MGame.gameWidth / 2 - vector.x) / 2);
    }
  }

  Directions rotateDirections(Directions direction) {
    switch (rotation) {
      case Rotation.zero:
        return direction;
      case Rotation.halfPi:
        switch (direction) {
          case Directions.S:
            return Directions.E;
          case Directions.W:
            return Directions.S;
          case Directions.N:
            return Directions.W;
          case Directions.E:
            return Directions.N;
        }
      case Rotation.pi:
        switch (direction) {
          case Directions.S:
            return Directions.N;
          case Directions.W:
            return Directions.E;
          case Directions.N:
            return Directions.S;
          case Directions.E:
            return Directions.W;
        }
      case Rotation.piAndHalf:
        switch (direction) {
          case Directions.S:
            return Directions.W;
          case Directions.W:
            return Directions.N;
          case Directions.N:
            return Directions.E;
          case Directions.E:
            return Directions.S;
        }
    }
  }

  Directions unRotateDirections(Directions direction) {
    switch (rotation) {
      case Rotation.zero:
        return direction;
      case Rotation.halfPi:
        switch (direction) {
          case Directions.S:
            return Directions.W;
          case Directions.W:
            return Directions.N;
          case Directions.N:
            return Directions.E;
          case Directions.E:
            return Directions.S;
        }
      case Rotation.pi:
        switch (direction) {
          case Directions.S:
            return Directions.N;
          case Directions.W:
            return Directions.E;
          case Directions.N:
            return Directions.S;
          case Directions.E:
            return Directions.W;
        }
      case Rotation.piAndHalf:
        switch (direction) {
          case Directions.S:
            return Directions.E;
          case Directions.W:
            return Directions.S;
          case Directions.N:
            return Directions.W;
          case Directions.E:
            return Directions.N;
        }
    }
  }

  Point<int> rotateOffsetSizeInTile(int sizeInTile) {
    int size = sizeInTile - 1;

    switch (rotation) {
      case Rotation.zero:
        return const Point(0, 0);
      case Rotation.halfPi:
        return Point(size, 0);

      case Rotation.pi:
        return Point(size, -size);

      case Rotation.piAndHalf:
        return Point(0, -size);
    }
  }

  Point<int> unRotateOffsetSizeInTile(int sizeInTile) {
    int size = sizeInTile - 1;

    switch (rotation) {
      case Rotation.zero:
        return const Point(0, 0);
      case Rotation.halfPi:
        return Point(0, -size);

      case Rotation.pi:
        return Point(size, -size);

      case Rotation.piAndHalf:
        return Point(size, 0);
    }
  }

  bool? isRightTurn({required Directions initialDirection, required Directions directionAfterTurn}) {
    switch (initialDirection) {
      case Directions.S:
        switch (directionAfterTurn) {
          case Directions.S:
            return null;
          case Directions.W:
            return true;
          case Directions.N:
            return null;
          case Directions.E:
            return false;
        }
      case Directions.W:
        switch (directionAfterTurn) {
          case Directions.S:
            return false;
          case Directions.W:
            return null;
          case Directions.N:
            return true;
          case Directions.E:
            return null;
        }
      case Directions.N:
        switch (directionAfterTurn) {
          case Directions.S:
            return null;
          case Directions.W:
            return false;
          case Directions.N:
            return null;
          case Directions.E:
            return true;
        }
      case Directions.E:
        switch (directionAfterTurn) {
          case Directions.S:
            return true;
          case Directions.W:
            return null;
          case Directions.N:
            return false;
          case Directions.E:
            return null;
        }
    }
  }
}

enum Directions {
  S,
  W,
  N,
  E;

  Directions get mirror {
    return switch (this) {
      Directions.S => Directions.N,
      Directions.W => Directions.E,
      Directions.N => Directions.S,
      Directions.E => Directions.W,
    };
  }

  double get angle {
    return switch (this) {
      Directions.S => 5 / 4 * pi,
      Directions.W => 3 / 4 * pi,
      Directions.N => 1 / 4 * pi,
      Directions.E => 7 / 4 * pi,
    };
  }
}
