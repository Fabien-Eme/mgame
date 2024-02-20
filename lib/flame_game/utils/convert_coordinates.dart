import 'dart:math';

import 'package:flame/game.dart';

import '../game.dart';

Point<int> convertDimetricToGridPoint(Vector2 pos) {
  return convertDimetricPointToGridPoint(Point(pos.x.toInt(), pos.y.toInt()));
}

Point<int> convertDimetricPointToGridPoint(Point<int> pos) {
  int x = pos.x - pos.y;
  int y = pos.y + (x / 2).floor();
  return Point(x, y);
}

Vector2 convertDimetricVectorToWorldCoordinates(Vector2 pos) {
  Point gridCoordinates = convertDimetricToGridPoint(pos);
  int y = gridCoordinates.x * MGame.tileHeight ~/ 2;
  int x = (gridCoordinates.y * MGame.tileWidth + ((gridCoordinates.x.toInt().isEven) ? 0 : MGame.tileHeight)).toInt();
  return Vector2(x.toDouble(), y.toDouble());
}

Vector2 convertDimetricPointToWorldCoordinates(Point<int> coordinate) {
  Point<int> gridCoordinates = convertDimetricPointToGridPoint(coordinate);
  int y = gridCoordinates.x * MGame.tileHeight ~/ 2;
  int x = (gridCoordinates.y * MGame.tileWidth + ((gridCoordinates.x.isEven) ? 0 : MGame.tileHeight)).toInt();
  return Vector2(x.toDouble(), y.toDouble());
}

Point<int> convertGridPointToGridDimetric(int posX, int posY) {
  int x = posX + posY - (posX / 2).floor();
  int y = posY - (posX / 2).floor();
  return Point(x, y);
}

Point<int> convertVectorToPoint(Vector2 vector) {
  return Point(vector.x.toInt(), vector.y.toInt());
}

bool isVectorInsideObject({required Vector2 vector, required Vector2 objectPosition, required Vector2 objectSize}) {
  if (vector.x > objectPosition.x && vector.x <= objectPosition.x + objectSize.x && vector.y > objectPosition.y && vector.y <= objectPosition.y + objectSize.y) {
    return true;
  } else {
    return false;
  }
}
