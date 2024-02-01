import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/ui/cursor.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';

import 'bloc/game_bloc.dart';
import 'tile.dart';

class GameWorld extends World with HasGameRef<MGame>, TapCallbacks {
  GameBloc gameBloc;
  GameWorld({required this.gameBloc});
  static const int gridWidth = 20;
  static const int gridHeight = 35;
  List<List<Tile>>? grid;

  bool isDebugGridNumbersOn = false;
  Cursor? cursor;
  bool cursorAdded = false;

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
              coordinates: convertGridCoordinatesToDimetric(i, j),
              position: Vector2(j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight), i * (MGame.tileHeight / 2)),
              isDebugMode: true,
            );
          },
        );
      },
    );

    await addAll([for (List<Tile> row in grid!) ...row]);

    if (isDebugGridNumbersOn) await addDebugGridNumbers();

    return super.onLoad();
  }

  Map<Directions, TileType> getNeigbhors(Point<int> coordinates) {
    ///TODO Implement this
    return {
      Directions.S: TileType.grass,
      Directions.W: TileType.grass,
      Directions.N: TileType.grass,
      Directions.E: TileType.grass,
    };
  }

  ///
  ///
  ///
  ///
  /// Handle Taps

  void onPrimaryTapDown() {
    if (gameBloc.state.status == GameStatus.construct) {
      construct(posDimetric: game.currentMouseTilePos, tileType: gameBloc.state.tileType!);
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
    if (gameBloc.state.tileType == TileType.roadSN) {
      gameBloc.add(const ConstructionModePressed(tileType: TileType.roadWE));
    }
    if (gameBloc.state.tileType == TileType.roadWE) {
      gameBloc.add(const ConstructionModePressed(tileType: TileType.roadSN));
    }
    await Future.delayed(const Duration(milliseconds: 10));
    mouseIsMovingOnNewTile(game.currentMouseTilePos);
  }

  ///
  ///
  ///
  ///
  /// Handle Construction

  void construct({required Vector2 posDimetric, required TileType tileType, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid![posGrid.x][posGrid.y].construct(tileType: tileType, isMouseDragging: isMouseDragging);
    }
  }

  void destroy({required Vector2 posDimetric, bool isMouseDragging = false}) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid![posGrid.x][posGrid.y].destroy(isMouseDragging: isMouseDragging);
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
    grid![posGrid.x][posGrid.y].highlight();
  }

  void removeHighlightOfTile(Point<int> posGrid) {
    grid![posGrid.x][posGrid.y].removeHighlight();
  }

  void projectConstructionOnTile(Point<int> posGrid) {
    grid![posGrid.x][posGrid.y].changeTileTo(gameBloc.state.tileType!);
  }

  void projectDestructionOnTile(Point<int> posGrid) {
    grid![posGrid.x][posGrid.y].changeTileToWantToDestroy();
  }

  void resetTile(Vector2 posDimetric) {
    Point<int> posGrid = convertDimetricToGridCoordinates(posDimetric);
    if (checkIfWithinGridBoundaries(posGrid)) {
      grid![posGrid.x][posGrid.y].resetTile();
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

    Point<int> posGrid = convertDimetricToGridCoordinates(newMouseTilePos);
    if (checkIfWithinGridBoundaries(posGrid)) {
      if (game.isMouseDragging) {
        if (gameBloc.state.status == GameStatus.construct) {
          construct(posDimetric: game.currentMouseTilePos, tileType: gameBloc.state.tileType!, isMouseDragging: true);
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
    if (posGrid.x >= 0 && posGrid.x < (grid?.length ?? 0) && posGrid.y >= 0 && posGrid.y < (grid?[posGrid.x] ?? []).length) {
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
          Point<int> pos = convertGridCoordinatesToDimetric(i, j);
          int x = pos.x;
          int y = pos.y;
          return TextComponent(
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
