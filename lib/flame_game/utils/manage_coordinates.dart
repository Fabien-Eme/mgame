import 'dart:math';

import 'package:flame/game.dart';

import '../game.dart';
import '../tile.dart';

Point<int> convertDimetricToGridCoordinates(Vector2 pos) {
  double x = pos.x - pos.y;
  double y = pos.y + (x / 2).floor();
  return Point(x.toInt(), y.toInt());
}

Point<int> convertDimetricPointToGridPoint(Point<int> pos) {
  int x = pos.x - pos.y;
  int y = pos.y + (x / 2).floor();
  return Point(x, y);
}

Vector2 convertDimetricWorldCoordinates(Vector2 pos) {
  Point gridCoordinates = convertDimetricToGridCoordinates(pos);
  int y = gridCoordinates.x * MGame.tileHeight ~/ 2;
  int x = (gridCoordinates.y * MGame.tileWidth + ((gridCoordinates.x.toInt().isEven) ? 0 : MGame.tileHeight)).toInt();
  return Vector2(x.toDouble(), y.toDouble());
}

Point<int> convertGridCoordinatesToGridDimetric(int posX, int posY) {
  int x = posX + posY - (posX / 2).floor();
  int y = posY - (posX / 2).floor();
  return Point(x, y);
}

bool isPointWithinGridBoundaries({required Point<int> point, required List<List<Tile>> grid}) {
  if (point.x >= 0 && point.x < grid.length) {
    if (point.y >= 0 && point.y < grid[point.x].length) {
      return true;
    }
  }
  return false;
}

enum Directions { S, W, N, E }
