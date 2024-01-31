import 'dart:async';

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
            return Tile(tileType: TileType.grass, position: Vector2(j * 100 + ((i.isEven) ? 0 : 50), i * 25));
          },
        );
      },
    );

    await addAll([for (List<Tile> row in grid!) ...row]);

    if (isDebugGridNumbersOn) addDebugGridNumbers();

    return super.onLoad();
  }

  void primaryTapDown() {
    if (gameBloc.state.status == GameStatus.construct) {
      construct(game.currentHighlightedTilePos);
      game.hasConstructed = true;
      removeHighlight(game.currentHighlightedTilePos);
    }
  }

  void highlightTile(int gridX, int gridY) {
    grid![gridX][gridY].highlight();
  }

  void removeHighlightOfTile(int gridX, int gridY) {
    grid![gridX][gridY].removeHighlight();
  }

  void projectConstructionOnTile(int gridX, int gridY) {
    grid![gridX][gridY].changeTileTo(TileType.roadSN);
  }

  void resetTile(Vector2? posDimetric) {
    if (posDimetric != null) {
      Vector2 posGrid = convertDimetricToGridCoordinates(posDimetric);
      if (checkIfWithinGridBoundaries(posGrid)) {
        int gridX = posGrid.x.toInt();
        int gridY = posGrid.y.toInt();
        grid![gridX][gridY].removeHighlight();
        grid![gridX][gridY].resetTile();
      }
    }
  }

  void removeHighlight(Vector2? posDimetric) {
    if (posDimetric != null) {
      Vector2 posGrid = convertDimetricToGridCoordinates(posDimetric);
      if (checkIfWithinGridBoundaries(posGrid)) {
        removeHighlightOfTile(posGrid.x.toInt(), posGrid.y.toInt());
      }
    }
  }

  void construct(Vector2? posDimetric) {
    if (posDimetric != null) {
      Vector2 posGrid = convertDimetricToGridCoordinates(posDimetric);
      if (checkIfWithinGridBoundaries(posGrid)) {
        grid![posGrid.x.toInt()][posGrid.y.toInt()].highlight();
      }
    }
  }

  void moveTileCursor(Vector2? posDimetric) async {
    if (posDimetric != null) {
      Vector2 posGrid = convertDimetricToGridCoordinates(posDimetric);
      if (checkIfWithinGridBoundaries(posGrid)) {
        if (gameBloc.state.status == GameStatus.construct) {
          projectConstructionOnTile(posGrid.x.toInt(), posGrid.y.toInt());
        } else {
          highlightTile(posGrid.x.toInt(), posGrid.y.toInt());
        }
        if (cursorAdded) {
          cursor!.position = convertDimetricWorldCoordinates(posDimetric);
        }
        if (cursor == null && !(cursor?.isRemoving ?? false)) {
          cursor = Cursor(position: convertDimetricWorldCoordinates(posDimetric));
          await add(cursor!);
          cursorAdded = true;
        }
      } else {
        hideCursor();
      }
    }
  }

  void hideCursor() {
    if (cursor != null && !cursor!.isRemoving) {
      remove(cursor!);
      cursor = null;

      cursorAdded = false;
    }
  }

  void _handleConstructionState(GameState newState) {
    switch (newState.status) {
      case GameStatus.construct:
        hideCursor();
        removeHighlight(game.currentHighlightedTilePos);
        break;
      case GameStatus.destruct:
        break;
      case GameStatus.idle:
        removeHighlight(game.currentHighlightedTilePos);
        moveTileCursor(game.currentHighlightedTilePos);
        if (game.hasConstructed) {
          game.hasConstructed = false;
        } else {
          resetTile(game.currentHighlightedTilePos);
        }
        break;
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///Method to check if Vector2 is within grid boundaries
  bool checkIfWithinGridBoundaries(Vector2 posGrid) {
    if (posGrid.x >= 0 && posGrid.x < (grid?.length ?? 0) && posGrid.y >= 0 && posGrid.y < (grid?[posGrid.x.toInt()] ?? []).length) {
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
  void addDebugGridNumbers() {
    List<List<TextBoxComponent>>? grid;
    grid = List.generate(
      gridHeight,
      (i) => List.generate(
        (i.isEven) ? gridWidth : gridWidth - 1,
        (j) {
          Vector2 pos = convertGridCoordinatesToDimetric(i, j);
          int x = pos.x.toInt();
          int y = pos.y.toInt();
          return TextBoxComponent(
              text: '[$x,$y]',
              position: Vector2(j * MGame.tileWidth + ((i.isEven) ? 0 : MGame.tileHeight) + MGame.tileWidth, i * (MGame.tileHeight / 2) + (MGame.tileHeight / 2)),
              scale: Vector2(0.6, 0.6),
              anchor: Anchor.center);
        },
      ),
    );

    addAll([for (List<TextBoxComponent> row in grid) ...row]);
  }
}
