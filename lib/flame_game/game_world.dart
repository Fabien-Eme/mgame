import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/ui/tile_cursor.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/manage_coordinates.dart';
import 'list_debug_component.dart';
import 'tile.dart';

class GameWorld extends World with HasGameRef<MGame>, TapCallbacks {
  GameWorld();
  static const int gridWidth = 20;
  static const int gridHeight = 35;
  List<List<Tile>> grid = [];

  bool isDebugGridNumbersOn = false;
  TileCursor tileCursor = TileCursor();
  Incinerator? temporaryBuilding;

  @override
  FutureOr<void> onLoad() {
    /// Add grid
    grid = generateGrid();
    addAll([for (List<Tile> row in grid) ...row]);

    /// Add debug components
    add(ListDebugComponent());

    /// Add Tile Cursor
    add(tileCursor);

    /// Add debug grid
    if (isDebugGridNumbersOn) addDebugGridNumbers();
    return super.onLoad();
  }

  ///
  ///
  /// Generate GameWorld Grid
  ///
  List<List<Tile>> generateGrid() {
    return List.generate(
      gridHeight,
      (i) {
        return List.generate(
          (i.isEven) ? gridWidth : gridWidth - 1,
          (j) {
            return Tile(
              tileType: TileType.grass,
              gridCoordinates: Point<int>(i, j),
              dimetricGridCoordinates: convertGridPointToGridDimetric(i, j),
              position: Vector2(j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight), i * (MGame.tileHeight / 2)),
            );
          },
        );
      },
    );
  }

  ///
  ///
  /// Method to add a text on each tile with its dimetric coordinates
  ///
  Future<void> addDebugGridNumbers() async {
    List<List<TextComponent>> grid = List.generate(
      gridHeight,
      (i) => List.generate(
        (i.isEven) ? gridWidth : gridWidth - 1,
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
            scale: Vector2.all(0.5),
          );
        },
      ),
    );

    await addAll([for (List<TextComponent> row in grid) ...row]);
  }
}
