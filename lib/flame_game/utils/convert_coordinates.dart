import 'package:flame/game.dart';

import '../game.dart';

Vector2 convertDimetricToGridCoordinates(Vector2 pos) {
  double x = pos.x - pos.y;
  double y = pos.y + (x / 2).floor();
  return Vector2(x, y);
}

Vector2 convertDimetricWorldCoordinates(Vector2 pos) {
  Vector2 gridCoordinates = convertDimetricToGridCoordinates(pos);
  int y = gridCoordinates.x * MGame.tileHeight ~/ 2;
  int x = (gridCoordinates.y * MGame.tileWidth + ((gridCoordinates.x.toInt().isEven) ? 0 : MGame.tileHeight)).toInt();
  return Vector2(x.toDouble(), y.toDouble());
}

Vector2 convertGridCoordinatesToDimetric(int posX, int posY) {
  int x = posX + posY - (posX / 2).floor();
  int y = posY - (posX / 2).floor();
  return Vector2(x.toDouble(), y.toDouble());
}
