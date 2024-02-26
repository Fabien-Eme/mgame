import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mgame/flame_game/truck/truck.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:mgame/flame_game/ui/tile_cursor.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';
import 'package:mgame/flame_game/utils/convert_rotations.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'buildings/building.dart';
import 'tile.dart';
import 'tile_helper.dart';

class GameWorld extends World with HasGameReference<MGame>, TapCallbacks {
  GameWorld();
  static const int gridWidth = 20;
  static const int gridHeight = 39;
  List<List<Tile>> grid = [];
  List<Building> buildings = [];

  bool isDebugGridNumbersOn = true;
  TileCursor tileCursor = TileCursor();
  Building? temporaryBuilding;

  @override
  FutureOr<void> onMount() async {
    super.onMount();

    addAll(generateGridForestTop());
    addAll(generateGridForestLeft());
    addAll(generateGridForestRight());
    addAll(generateGridForestBottom());

    /// Add grid
    grid = generateGrid();
    addAll([for (List<Tile> row in grid) ...row]);

    /// Add Tile Cursor
    add(tileCursor);

    /// Add debug grid
    if (isDebugGridNumbersOn) addDebugGridNumbers();

    await game.gridController.internalBuildOnTile(const Point<int>(6, -2), BuildingType.garage, Directions.E);
    await game.gridController.internalBuildOnTile(const Point<int>(32, 3), BuildingType.city, Directions.S);

    game.constructionController.construct(posDimetric: const Point<int>(8, -1), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(9, -1), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(10, -1), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(11, -1), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(12, -1), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(12, -2), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(12, -3), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(12, -4), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(12, -5), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(10, -2), tileType: TileType.road);
    game.constructionController.construct(posDimetric: const Point<int>(10, -3), tileType: TileType.road);

    Truck truck = Truck(truckType: TruckType.blue, truckDirection: Directions.E, startingTile: game.gridController.getTileAtDimetricCoordinates(const Point<int>(8, -1))!);
    add(truck);

    truck.goToTile(game.gridController.getTileAtDimetricCoordinates(const Point<int>(12, -5))!);
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
            )..priority = i;
          },
        );
      },
    );
  }

  List<Tile> generateGridForestTop() {
    return List.generate(
      gridWidth + 1,
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
      gridHeight ~/ 2 + 1,
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
      gridWidth + 1,
      (i) {
        return Tile(
          tileType: TileType.forestS,
          gridCoordinates: Point<int>(gridHeight - 1, i),
          dimetricCoordinates: convertGridPointToGridDimetric(gridHeight - 1, i),
          position: Vector2(i * MGame.tileWidth - MGame.tileWidth / 2, gridHeight * (MGame.tileHeight / 2)),
        )..priority = 600;
      },
    );
  }

  List<Tile> generateGridForestRight() {
    return List.generate(
      gridHeight ~/ 2 + 1,
      (i) {
        return Tile(
          tileType: TileType.forestS,
          gridCoordinates: Point<int>(i, gridWidth),
          dimetricCoordinates: convertGridPointToGridDimetric(i, gridWidth),
          position: Vector2(gridWidth * MGame.tileWidth - MGame.tileWidth / 2, i * MGame.tileHeight + MGame.tileHeight / 2),
        )..priority = i * 2 + 1;
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
            textRenderer: MyTextStyle.debugGridNumber,
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
/// Trucks : 100
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
