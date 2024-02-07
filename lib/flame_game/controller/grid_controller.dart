import 'dart:math';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/game_world.dart';

import '../game.dart';
import '../tile.dart';
import '../utils/manage_coordinates.dart';

class GridController extends Component with HasGameRef<MGame>, HasWorldReference<GameWorld> {
  Map<Directions, Tile?> getAllNeigbhorsTile({required Point<int> dimetricGridPoint}) {
    return {
      Directions.S: getNeigbhorTile(dimetricGridPoint, Directions.S),
      Directions.W: getNeigbhorTile(dimetricGridPoint, Directions.W),
      Directions.N: getNeigbhorTile(dimetricGridPoint, Directions.N),
      Directions.E: getNeigbhorTile(dimetricGridPoint, Directions.E),
    };
  }

  Tile? getNeigbhorTile(Point<int> dimetricGridPoint, Directions direction) {
    Point<int> neighborDimetricPoint = switch (direction) {
      Directions.S => Point(dimetricGridPoint.x, dimetricGridPoint.y - 1),
      Directions.W => Point(dimetricGridPoint.x - 1, dimetricGridPoint.y),
      Directions.N => Point(dimetricGridPoint.x, dimetricGridPoint.y + 1),
      Directions.E => Point(dimetricGridPoint.x + 1, dimetricGridPoint.y),
    };
    Point<int> neighborGridPoint = convertDimetricPointToGridPoint(neighborDimetricPoint);

    if (checkIfWithinGridBoundaries(neighborGridPoint)) {
      return world.grid[neighborGridPoint.x][neighborGridPoint.y];
    } else {
      return null;
    }
  }

  Map<Directions, TileType?> getAllNeigbhorsTileType({required Point<int> dimetricGridPoint}) {
    return {
      Directions.S: getNeigbhorTileType(dimetricGridPoint, Directions.S),
      Directions.W: getNeigbhorTileType(dimetricGridPoint, Directions.W),
      Directions.N: getNeigbhorTileType(dimetricGridPoint, Directions.N),
      Directions.E: getNeigbhorTileType(dimetricGridPoint, Directions.E),
    };
  }

  TileType? getNeigbhorTileType(Point<int> dimetricGridPoint, Directions direction) {
    return getNeigbhorTile(dimetricGridPoint, direction)?.projectedTileType ?? getNeigbhorTile(dimetricGridPoint, direction)?.tileType;
  }

  ///
  ///
  ///Method to check if Vector2 is within grid boundaries
  ///
  bool checkIfWithinGridBoundaries(Point<int> posGrid) {
    if (posGrid.x >= 0 && posGrid.x < (world.grid.length) && posGrid.y >= 0 && posGrid.y < (world.grid[posGrid.x]).length) {
      return true;
    } else {
      return false;
    }
  }
}
