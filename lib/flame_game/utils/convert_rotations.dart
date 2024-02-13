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
}
