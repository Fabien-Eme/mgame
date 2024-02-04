import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/buildings/belt.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
import 'package:mgame/flame_game/ui/cursor.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/manage_coordinates.dart';
import 'bloc/game_bloc.dart';
import 'buildings/garbage_conveyor/garbage_conveyor_back.dart';
import 'buildings/garbage_conveyor/garbage_conveyor_front.dart';
import 'buildings/garbage_loader/garbage_loader_back.dart';
import 'tile.dart';

class GameWorld extends World with HasGameRef<MGame>, TapCallbacks {
  GameBloc gameBloc;
  GameWorld({required this.gameBloc});
  static const int gridWidth = 20;
  static const int gridHeight = 35;
  List<List<Tile>> grid = [];

  bool isDebugGridNumbersOn = false;
  Cursor? cursor;
  bool cursorAdded = false;
  bool hasConstructed = false;

  @override
  FutureOr<void> onLoad() async {
    add(FlameBlocListener<GameBloc, GameState>(
      bloc: gameBloc,
      onNewState: (newState) {
        _handleConstructionState(newState);
      },
    ));

    grid = List.generate(
      gridHeight,
      (i) {
        return List.generate(
          (i.isEven) ? gridWidth : gridWidth - 1,
          (j) {
            return Tile(
              tileType: TileType.grass,
              gridCoordinates: Point<int>(i, j),
              dimetricGridCoordinates: convertGridCoordinatesToGridDimetric(i, j),
              position: Vector2(j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight), i * (MGame.tileHeight / 2)),
            );
          },
        );
      },
    );

    await addAll([for (List<Tile> row in grid) ...row]);

    add(Belt(beltType: BeltType.beltWE, position: convertDimetricWorldCoordinates(Vector2(8, 0))));
    add(Belt(beltType: BeltType.beltWE, position: convertDimetricWorldCoordinates(Vector2(9, 0))));
    add(Belt(beltType: BeltType.beltSN, position: convertDimetricWorldCoordinates(Vector2(11, 5))));
    add(Belt(beltType: BeltType.beltSN, position: convertDimetricWorldCoordinates(Vector2(11, 4))));

    add(Belt(beltType: BeltType.beltWE, position: convertDimetricWorldCoordinates(Vector2(6, -5))));
    add(Belt(beltType: BeltType.beltWE, position: convertDimetricWorldCoordinates(Vector2(7, -5))));

    add(GarbageConveyorBack(position: convertDimetricWorldCoordinates(Vector2(6, -5))));
    add(GarbageConveyorFront(position: convertDimetricWorldCoordinates(Vector2(6, -5))));

    add(GarbageLoaderFront(garbageLoaderDirection: GarbageLoaderDirections.E, garbageLoaderFlow: GarbageLoaderFlow.flowOut, position: convertDimetricWorldCoordinates(Vector2(8, -5))));
    add(GarbageLoaderBack(garbageLoaderDirection: GarbageLoaderDirections.E, position: convertDimetricWorldCoordinates(Vector2(8, -5))));

    // add(GarbageLoaderFront(garbageLoaderDirection: GarbageLoaderDirections.S, garbageLoaderFlow: GarbageLoaderFlow.flowOut, position: convertDimetricWorldCoordinates(Vector2(11, 3))));
    // add(GarbageLoaderBack(garbageLoaderDirection: GarbageLoaderDirections.S, position: convertDimetricWorldCoordinates(Vector2(11, 3))));

    // add(Truck(position: Vector2(1405, 783), asset: Assets.images.truckTL.path));
    // add(Truck(position: Vector2(225, 203), asset: Assets.images.truckBR.path));
    // add(Truck(position: Vector2(305, 243), asset: Assets.images.truckBR.path));
    // add(Truck(position: Vector2(185, 183), asset: Assets.images.truckBR.path));
    if (isDebugGridNumbersOn) await addDebugGridNumbers();

    return super.onLoad();
  }

  Map<Directions, Tile?> getAllNeigbhorsTile({required Point<int> dimetricGridCoordinates}) {
    return {
      Directions.S: getNeigbhorTile(dimetricGridCoordinates, Directions.S),
      Directions.W: getNeigbhorTile(dimetricGridCoordinates, Directions.W),
      Directions.N: getNeigbhorTile(dimetricGridCoordinates, Directions.N),
      Directions.E: getNeigbhorTile(dimetricGridCoordinates, Directions.E),
    };
  }

  Tile? getNeigbhorTile(Point<int> dimetricGridCoordinates, Directions direction) {
    Point<int> neighborDimetricCoordinate = switch (direction) {
      Directions.S => Point(dimetricGridCoordinates.x, dimetricGridCoordinates.y - 1),
      Directions.W => Point(dimetricGridCoordinates.x - 1, dimetricGridCoordinates.y),
      Directions.N => Point(dimetricGridCoordinates.x, dimetricGridCoordinates.y + 1),
      Directions.E => Point(dimetricGridCoordinates.x + 1, dimetricGridCoordinates.y),
    };
    Point<int> neighborGridCoordinate = convertDimetricPointToGridPoint(neighborDimetricCoordinate);

    if (isPointWithinGridBoundaries(point: neighborGridCoordinate, grid: grid)) {
      return grid[neighborGridCoordinate.x][neighborGridCoordinate.y];
    } else {
      return null;
    }
  }

  Map<Directions, TileType?> getAllNeigbhorsTileType({required Point<int> dimetricGridCoordinates}) {
    return {
      Directions.S: getNeigbhorTileType(dimetricGridCoordinates, Directions.S),
      Directions.W: getNeigbhorTileType(dimetricGridCoordinates, Directions.W),
      Directions.N: getNeigbhorTileType(dimetricGridCoordinates, Directions.N),
      Directions.E: getNeigbhorTileType(dimetricGridCoordinates, Directions.E),
    };
  }

  TileType? getNeigbhorTileType(Point<int> dimetricGridCoordinates, Directions direction) {
    return getNeigbhorTile(dimetricGridCoordinates, direction)?.projectedTileType ?? getNeigbhorTile(dimetricGridCoordinates, direction)?.tileType;
  }

  ///
  ///
  ///
  ///
  /// Handle Taps

  void onPrimaryTapDown() {
    if (gameBloc.state.status == GameStatus.construct) {
      construct(posDimetric: game.currentMouseTilePos, tileType: gameBloc.state.tileType!);
      hasConstructed = true;
    } else if (gameBloc.state.status == GameStatus.destruct) {
      destroy(posDimetric: game.currentMouseTilePos);
    }
  }

  void onSecondaryTapUp() {
    switch (gameBloc.state.status) {
      case GameStatus.initial:
        gameBloc.add(const DestructionModePressed());

        break;
      case GameStatus.construct:
        gameBloc.add(const ConstructionModeExited());

        break;
      case GameStatus.destruct:
        gameBloc.add(const DestructionModeExited());

        break;
      case GameStatus.idle:
        gameBloc.add(const DestructionModePressed());

        break;
    }
  }

  void onTertiaryTapDown(TapDownInfo info) async {
    // if (gameBloc.state.tileType == TileType.roadSN) {
    //   gameBloc.add(const ConstructionModePressed(tileType: TileType.roadWE));
    // }
    // if (gameBloc.state.tileType == TileType.roadWE) {
    //   gameBloc.add(const ConstructionModePressed(tileType: TileType.roadSN));
    // }
    // await Future.delayed(const Duration(milliseconds: 10));
    // mouseIsMovingOnNewTile(game.currentMouseTilePos);
  }

  ///
  ///
  ///
  ///
  /// Handle Construction

  void construct({required Vector2 posDimetric, required TileType tileType, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid[posGrid.x][posGrid.y].construct(tileType: tileType, isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors =
          getAllNeigbhorsTile(dimetricGridCoordinates: convertGridCoordinatesToGridDimetric(convertDimetricToGridCoordinates(posDimetric).x, convertDimetricToGridCoordinates(posDimetric).y));
      for (Tile? tile in mapNeighbors.values) {
        tile?.propagateTileChange();
      }
    }
  }

  void destroy({required Vector2 posDimetric, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid[posGrid.x][posGrid.y].destroy(isMouseDragging: isMouseDragging);

      Map<Directions, Tile?> mapNeighbors =
          getAllNeigbhorsTile(dimetricGridCoordinates: convertGridCoordinatesToGridDimetric(convertDimetricToGridCoordinates(posDimetric).x, convertDimetricToGridCoordinates(posDimetric).y));
      for (Tile? tile in mapNeighbors.values) {
        tile?.projectTileChange();
        tile?.propagateTileChange();
      }
    }
  }

  void _handleConstructionState(GameState newState) {
    switch (newState.status) {
      case GameStatus.initial:
        resetTile(game.currentMouseTilePos);
        mouseIsMovingOnNewTile(game.currentMouseTilePos);
        break;
      case GameStatus.construct:
        resetTile(game.currentMouseTilePos);
        mouseIsMovingOnNewTile(game.currentMouseTilePos);
        break;
      case GameStatus.destruct:
        resetTile(game.currentMouseTilePos);
        mouseIsMovingOnNewTile(game.currentMouseTilePos);
        break;
      case GameStatus.idle:
        resetTile(game.currentMouseTilePos);
        mouseIsMovingOnNewTile(game.currentMouseTilePos);
        break;
    }
  }

  ///
  ///
  ///
  ///
  /// Handle Tile operations

  void highlightTile(Point<int> posGrid) {
    grid[posGrid.x][posGrid.y].highlight();
  }

  void removeHighlightOfTile(Point<int> posGrid) {
    grid[posGrid.x][posGrid.y].removeHighlight();
  }

  void projectConstructionOnTile(Point<int> posGrid) {
    grid[posGrid.x][posGrid.y].projectConstruction(gameBloc.state.tileType);
  }

  void projectDestructionOnTile(Point<int> posGrid) {
    grid[posGrid.x][posGrid.y].changeTileToWantToDestroy();
  }

  void resetTile(Vector2 posDimetric) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid[posGrid.x][posGrid.y].resetTile();
    }
  }

  void removeHighlight(Vector2 posDimetric) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      removeHighlightOfTile(posGrid);
    }
  }

  void hideCursor() {
    if (cursor != null && !cursor!.isRemoving) {
      remove(cursor!);
      cursor = null;

      cursorAdded = false;
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  /// Handle Mouse Movement

  void mouseIsMovingOnNewTile(Vector2 newMouseTilePos) async {
    resetTile(game.currentMouseTilePos);
    if (hasConstructed) {
      hasConstructed = false;
    } else {
      Map<Directions, Tile?> mapPrecedentNeighbors = getAllNeigbhorsTile(
          dimetricGridCoordinates: convertGridCoordinatesToGridDimetric(convertDimetricToGridCoordinates(game.currentMouseTilePos).x, convertDimetricToGridCoordinates(game.currentMouseTilePos).y));
      for (Tile? tile in mapPrecedentNeighbors.values) {
        tile?.cancelProjectedTileChange();
      }
    }
    Point<int> posGrid = convertDimetricToGridCoordinates(newMouseTilePos);
    if (checkIfWithinGridBoundaries(posGrid)) {
      if (game.isMouseDragging) {
        if (gameBloc.state.status == GameStatus.construct) {
          if (gameBloc.state.tileType != null) {
            construct(posDimetric: game.currentMouseTilePos, tileType: gameBloc.state.tileType!, isMouseDragging: true);
            Map<Directions, Tile?> mapNeighbors = getAllNeigbhorsTile(
                dimetricGridCoordinates:
                    convertGridCoordinatesToGridDimetric(convertDimetricToGridCoordinates(game.currentMouseTilePos).x, convertDimetricToGridCoordinates(game.currentMouseTilePos).y));
            for (Tile? tile in mapNeighbors.values) {
              tile?.projectTileChange();
              tile?.propagateTileChange();
            }
            hasConstructed = true;
          }
        } else if (gameBloc.state.status == GameStatus.destruct) {
          destroy(posDimetric: game.currentMouseTilePos, isMouseDragging: true);
        }
      }
      if (gameBloc.state.status == GameStatus.construct) {
        projectConstructionOnTile(posGrid);
      } else if (gameBloc.state.status == GameStatus.destruct) {
        projectDestructionOnTile(posGrid);
      } else {
        highlightTile(posGrid);
      }

      if (gameBloc.state.status == GameStatus.construct || gameBloc.state.status == GameStatus.destruct) {
        Map<Directions, Tile?> mapNeighbors = getAllNeigbhorsTile(
            dimetricGridCoordinates: convertGridCoordinatesToGridDimetric(convertDimetricToGridCoordinates(newMouseTilePos).x, convertDimetricToGridCoordinates(newMouseTilePos).y));
        for (Tile? tile in mapNeighbors.values) {
          tile?.projectTileChange();
        }
      }

      if (cursorAdded) {
        cursor!.position = convertDimetricWorldCoordinates(newMouseTilePos);
      }
      if (cursor == null && !(cursor?.isRemoving ?? false)) {
        cursor = Cursor(position: convertDimetricWorldCoordinates(newMouseTilePos));
        await add(cursor!);
        cursorAdded = true;
      }
    } else {
      hideCursor();
    }
    game.currentMouseTilePos = newMouseTilePos;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///Method to check if Vector2 is within grid boundaries
  bool checkIfWithinGridBoundaries(Point<int> posGrid) {
    if (posGrid.x >= 0 && posGrid.x < (grid.length) && posGrid.y >= 0 && posGrid.y < (grid[posGrid.x]).length) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///
  ///
  ///
  ///
  /// Method to add a text with the coordinates of the grid
  Future<void> addDebugGridNumbers() async {
    List<List<TextComponent>> grid = List.generate(
      gridHeight,
      (i) => List.generate(
        (i.isEven) ? gridWidth : gridWidth - 1,
        (j) {
          Point<int> pos = convertGridCoordinatesToGridDimetric(i, j);
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
