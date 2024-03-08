import 'dart:math';

import 'package:flame/components.dart' hide Timer;

import 'buildings/building.dart';
import 'game.dart';
import 'level_world_generator.dart';
import 'listener/construction_mode_listener.dart';
import 'tile/tile.dart';
import 'tile/tile_helper.dart';
import 'tile/tile_holder.dart';
import 'ui/tile_cursor.dart';

import 'controller/a_star_controller.dart';
import 'controller/building_controller.dart';
import 'controller/construction_controller.dart';
import 'controller/cursor_controller.dart';
import 'controller/drag_zoom_controller.dart';
import 'controller/garbage_controller.dart';
import 'controller/grid_controller.dart';
import 'controller/mouse_controller.dart';
import 'controller/tap_controller.dart';
import 'controller/task_controller.dart';
import 'controller/truck_controller.dart';
import 'utils/convert_rotations.dart';

class LevelWorld extends World with HasGameReference<MGame>, IgnoreEvents {
  static const int gridWidth = 20;
  static const int gridHeight = 39;
  List<List<Tile>> grid = [];
  List<Building> buildings = [];

  bool isDebugGridNumbersOn = false;
  TileCursor tileCursor = TileCursor();
  Building? temporaryBuilding;

  late final MouseController mouseController;
  late final DragZoomController dragZoomController;
  late final TapController tapController;
  late final GridController gridController;
  late final ConstructionController constructionController;
  late final CursorController cursorController;
  late final BuildingController buildingController;
  late final ConvertRotations convertRotations;
  late final TruckController truckController;
  late final GarbageController garbageController;
  late final TaskController taskController;
  late final AStarController aStarController;

  Point<int> currentMouseTilePos = const Point(0, 0);

  @override
  void onLoad() async {
    super.onLoad();

    addAll([
      mouseController = MouseController(),
      dragZoomController = DragZoomController(),
      tapController = TapController(),
      gridController = GridController(),
      constructionController = ConstructionController(),
      cursorController = CursorController(),
      buildingController = BuildingController(),
      convertRotations = ConvertRotations(),
      truckController = TruckController(),
      garbageController = GarbageController(),
      taskController = TaskController(),
      aStarController = AStarController(),
    ]);

    add(ConstructionModeListener());

    /// Add grid
    grid = generateGrid();

    TileHolder tileHolder = TileHolder([
      ...generateGridForestTop(),
      ...generateGridForestLeft(),
      ...generateGridForestRight(),
      ...generateGridForestBottom(),
      for (List<Tile> row in grid) ...row,
    ]);
    await add(tileHolder);

    /// Add Tile Cursor
    add(tileCursor);

    /// Add debug grid
    if (isDebugGridNumbersOn) addAll(generateDebugGridNumbers());

    await gridController.internalBuildOnTile(const Point<int>(6, -2), BuildingType.garage, Directions.E);
    await gridController.internalBuildOnTile(const Point<int>(32, 3), BuildingType.city, Directions.S);
    // await game.gridController.internalBuildOnTile(const Point<int>(31, 2), BuildingType.garbageLoader, Directions.S);

    for (int i = 0; i < 25; i++) {
      constructionController.construct(posDimetric: Point<int>(7 + i, -1), tileType: TileType.road);
    }
    constructionController.construct(posDimetric: const Point<int>(31, 0), tileType: TileType.road);
    constructionController.construct(posDimetric: const Point<int>(31, 1), tileType: TileType.road);

    await gridController.internalBuildOnTile(const Point<int>(31, 2), BuildingType.garbageLoader, Directions.S);
    await gridController.internalBuildOnTile(const Point<int>(22, 2), BuildingType.incinerator, Directions.S);

    constructionController.construct(posDimetric: const Point<int>(21, 0), tileType: TileType.road);
    constructionController.construct(posDimetric: const Point<int>(21, 1), tileType: TileType.road);

    // add(Truck(id: 'test', truckType: TruckType.yellow, truckDirection: Directions.S, startingTileCoordinatesAtCreation: const Point<int>(15, 5)));
    // constructionController.construct(posDimetric: const Point<int>(14, 5), tileType: TileType.road);
    // constructionController.construct(posDimetric: const Point<int>(15, 5), tileType: TileType.road);
    // constructionController.construct(posDimetric: const Point<int>(16, 5), tileType: TileType.road);
  }
}


///
///
///
/// Priority of world
/// 
/// 
/// Tiles : 10
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