import 'dart:math';

import 'package:flame/components.dart';

import 'game.dart';
import 'level_world.dart';
import 'tile/tile.dart';
import 'tile/tile_helper.dart';
import 'utils/convert_coordinates.dart';
import 'utils/my_text_style.dart';

///
///
/// Generate GameWorld Grid
///
List<List<Tile>> generateGrid() {
  return List.generate(
    LevelWorld.gridHeight,
    (i) {
      return List.generate(
        (i.isEven) ? LevelWorld.gridWidth : LevelWorld.gridWidth - 1,
        (j) {
          return Tile(
            tileType: TileType.grass,
            gridCoordinates: Point<int>(i, j),
            dimetricCoordinates: convertGridPointToGridDimetric(i, j),
            position: Vector2(j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight), i * (MGame.tileHeight / 2)),
          )..priority = i;
        },
      );
    },
  );
}

List<Tile> generateGridForestTop() {
  return List.generate(
    LevelWorld.gridWidth + 1,
    (i) {
      return Tile(
        tileType: TileType.forestS,
        gridCoordinates: Point<int>(0, i),
        dimetricCoordinates: convertGridPointToGridDimetric(0, i),
        position: Vector2(i * MGame.tileWidth - MGame.tileWidth / 2, -MGame.tileHeight / 2),
      );
    },
  );
}

List<Tile> generateGridForestLeft() {
  return List.generate(
    LevelWorld.gridHeight ~/ 2 + 1,
    (i) {
      return Tile(
        tileType: TileType.forestS,
        gridCoordinates: Point<int>(i, -1),
        dimetricCoordinates: convertGridPointToGridDimetric(i, -1),
        position: Vector2(-MGame.tileWidth / 2, i * MGame.tileHeight + MGame.tileHeight / 2),
      )..priority = i * 2 + 1;
    },
  );
}

List<Tile> generateGridForestBottom() {
  return List.generate(
    LevelWorld.gridWidth + 1,
    (i) {
      return Tile(
        tileType: TileType.forestS,
        gridCoordinates: Point<int>(LevelWorld.gridHeight - 1, i),
        dimetricCoordinates: convertGridPointToGridDimetric(LevelWorld.gridHeight - 1, i),
        position: Vector2(i * MGame.tileWidth - MGame.tileWidth / 2, LevelWorld.gridHeight * (MGame.tileHeight / 2)),
      )..priority = 600;
    },
  );
}

List<Tile> generateGridForestRight() {
  return List.generate(
    LevelWorld.gridHeight ~/ 2 + 1,
    (i) {
      return Tile(
        tileType: TileType.forestS,
        gridCoordinates: Point<int>(i, LevelWorld.gridWidth),
        dimetricCoordinates: convertGridPointToGridDimetric(i, LevelWorld.gridWidth),
        position: Vector2(LevelWorld.gridWidth * MGame.tileWidth - MGame.tileWidth / 2, i * MGame.tileHeight + MGame.tileHeight / 2),
      )..priority = i * 2 + 1;
    },
  );
}

///
///
/// Method to add a text on each tile with its dimetric coordinates
///
List<TextComponent> generateDebugGridNumbers() {
  List<List<TextComponent>> grid = List.generate(
    LevelWorld.gridHeight,
    (i) => List.generate(
      (i.isEven) ? LevelWorld.gridWidth : LevelWorld.gridWidth - 1,
      (j) {
        Point<int> pos = convertGridPointToGridDimetric(i, j);
        int x = pos.x;
        int y = pos.y;
        return TextComponent(
          priority: 1000,
          text: '[$x,$y]',
          position: Vector2(
            j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight) + MGame.tileWidth / 2.6,
            i * (MGame.tileHeight / 2) + (MGame.tileHeight / 2) - 5,
          ),
          textRenderer: MyTextStyle.debugGridNumber,
          scale: Vector2.all(0.5),
        );
      },
    ),
  );

  return [for (List<TextComponent> row in grid) ...row];
}
