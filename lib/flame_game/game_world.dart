import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mgame/flame_game/truck/truck.dart';
import 'package:mgame/flame_game/ui/tile_cursor.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';
import 'package:mgame/flame_game/utils/convert_rotations.dart';
import 'buildings/building.dart';
import 'tile.dart';
import 'tile_helper.dart';
import 'truck/truck_stacked.dart';

class GameWorld extends World with HasGameRef<MGame>, TapCallbacks {
  GameWorld();
  static const int gridWidth = 20;
  static const int gridHeight = 39;
  List<List<Tile>> grid = [];
  List<Building> buildings = [];

  bool isDebugGridNumbersOn = false;
  TileCursor tileCursor = TileCursor();
  Building? temporaryBuilding;

  @override
  FutureOr<void> onLoad() {
    /// Add grid
    grid = generateGrid();
    addAll([for (List<Tile> row in grid) ...row]);

    /// Add debug components
    //add(ListDebugComponent());

    /// Add Tile Cursor
    add(tileCursor);

    /// Add debug grid
    if (isDebugGridNumbersOn) addDebugGridNumbers();

    game.gridController.internalBuildOnTile(const Point<int>(6, -2), BuildingType.garage, Directions.E);

    add(Truck());

    return super.onLoad();
  }

  void removeTemporaryBuilding() {
    if (temporaryBuilding != null) {
      remove(temporaryBuilding!);
    }
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
              dimetricCoordinates: convertGridPointToGridDimetric(i, j),
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



///
///
///
/// Priority of world
/// 
/// 
/// 
/// Building front : 110
/// Building back : 90
/// 
/// 
/// When dragging building for build : 
///   - Door : 511
///   - Front : 510
///   - Back : 490
/// 
/// 
/// 
/// TileCursor : 400
/// 
/// 
