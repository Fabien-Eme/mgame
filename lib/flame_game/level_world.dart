import 'dart:math';

import 'package:flame/components.dart';

import 'buildings/building.dart';
import 'level_world_generator.dart';
import 'listener/construction_mode_listener.dart';
import 'tile/tile.dart';
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

class LevelWorld extends World {
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
    if (isDebugGridNumbersOn) addAll(generateDebugGridNumbers());
  }

  // void removeTemporaryBuilding() {
  //   if (temporaryBuilding != null) {
  //     remove(temporaryBuilding!);
  //   }
  // }
}
