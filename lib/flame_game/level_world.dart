import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/city/city.dart';
import 'package:mgame/flame_game/buildings/garbage_loader/garbage_loader_front.dart';
import 'package:mgame/flame_game/tile/tile_helper.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';

import 'buildings/building.dart';
import 'game.dart';
import 'level_world_generator.dart';
import 'listener/construction_mode_listener.dart';
import 'riverpod_controllers/all_trucks_controller.dart';
import 'tile/tile.dart';
import 'tile/tile_holder.dart';
import 'ui/tile_cursor.dart';

import 'controller/a_star_controller.dart';
import 'controller/building_controller.dart';
import 'controller/construction_controller.dart';
import 'controller/cursor_controller.dart';
import 'controller/drag_zoom_controller.dart';
import 'controller/waste_controller.dart';
import 'controller/grid_controller.dart';
import 'controller/mouse_controller.dart';
import 'controller/tap_controller.dart';
import 'controller/task_controller.dart';
import 'controller/truck_controller.dart';
import 'utils/convert_rotations.dart';

class LevelWorld extends World with HasGameReference<MGame>, IgnoreEvents, RiverpodComponentMixin {
  int level;
  LevelWorld({required this.level});

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
  late final WasteController wasteController;
  late final TaskController taskController;
  late final AStarController aStarController;

  Point<int> currentMouseTilePos = const Point(0, 0);

  late final DebugGridNumbersHolder debugGridNumbersHolder;

  @override
  void onMount() async {
    await addAll([
      mouseController = MouseController(),
      dragZoomController = DragZoomController(),
      tapController = TapController(),
      gridController = GridController(),
      constructionController = ConstructionController(),
      cursorController = CursorController(),
      buildingController = BuildingController(),
      convertRotations = ConvertRotations(),
      truckController = TruckController(),
      wasteController = WasteController(),
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
    if (level != 0) {
      add(tileCursor);
    }

    /// Add debug grid
    debugGridNumbersHolder = DebugGridNumbersHolder();
    if (isDebugGridNumbersOn) add(debugGridNumbersHolder);

    addLevelBuildings(level);

    super.onMount();
  }

  void showHideDebugGrid() {
    if (debugGridNumbersHolder.isMounted) {
      remove(debugGridNumbersHolder);
    } else {
      add(debugGridNumbersHolder);
    }
  }

  void addLevelBuildings(int level) async {
    switch (level) {
      case 0:
        game.router.previousRoute?.resumeTime();
        animateMenuBackground();
        break;
      case 1:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(6, -2), buildingType: BuildingType.garage, direction: Directions.E, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(32, 3), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.tutorial);
        break;
      case 2:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(24, 9), buildingType: BuildingType.garage, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(10, -6), buildingType: BuildingType.city, direction: Directions.E, hideMoney: true, cityType: CityType.pollutingWithRecyclable);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(17, -13), buildingType: BuildingType.city, direction: Directions.N, hideMoney: true, cityType: CityType.recycleALot);
        break;
      case 3:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(19, 9), buildingType: BuildingType.garage, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(6, -3), buildingType: BuildingType.city, direction: Directions.E, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(13, -9), buildingType: BuildingType.city, direction: Directions.E, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(29, 4), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(14, 2), buildingType: BuildingType.composter, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(18, 1), buildingType: BuildingType.composter, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(22, -3), buildingType: BuildingType.composter, direction: Directions.S, hideMoney: true);
        break;
      case 4:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(15, 5), buildingType: BuildingType.garage, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(22, -10), buildingType: BuildingType.city, direction: Directions.N, hideMoney: true, cityType: CityType.pollutingWithToxic);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(23, 5), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.pollutingWithRecyclable);
        break;
      case 5:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(15, 3), buildingType: BuildingType.garage, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(9, -3), buildingType: BuildingType.city, direction: Directions.E, hideMoney: true, cityType: CityType.classicCity);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(21, 10), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(28, -6), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.recycleALot);
        break;
      case 6:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(22, 10), buildingType: BuildingType.garage, direction: Directions.S, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(16, -9), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.classicCity);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(16, -5), buildingType: BuildingType.city, direction: Directions.N, hideMoney: true, cityType: CityType.classicCity);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(20, -9), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        await gridController.internalBuildOnTile(
            coordinates: const Point<int>(20, -5), buildingType: BuildingType.city, direction: Directions.N, hideMoney: true, cityType: CityType.pollutingWithOrganic);
        break;
      case 7:
        await gridController.internalBuildOnTile(coordinates: const Point<int>(8, -2), buildingType: BuildingType.garage, direction: Directions.E, hideMoney: true);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(22, -10), buildingType: BuildingType.city, direction: Directions.N, hideMoney: true, cityType: CityType.classicCity);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(16, 4), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.classicCity);
        await gridController.internalBuildOnTile(coordinates: const Point<int>(21, 3), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.classicCity);
        break;
    }
  }

  void animateMenuBackground() async {
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(22, 11), buildingType: BuildingType.city, direction: Directions.S, hideMoney: true, cityType: CityType.normal);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(15, -12), buildingType: BuildingType.garage, direction: Directions.E, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(21, 10), buildingType: BuildingType.garbageLoader, direction: Directions.S, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(16, -11), tileType: TileType.road, hideMoney: true);

    for (int i = 0; i < 6; i++) {
      if (isMounted) constructionController.construct(posDimetric: Point<int>(16 + i, -11), tileType: TileType.road);
      if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    }

    for (int i = 0; i < 20; i++) {
      if (isMounted) constructionController.construct(posDimetric: Point<int>(21, -10 + i), tileType: TileType.road);
      if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(10, -4), buildingType: BuildingType.incinerator, direction: Directions.E, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));

    for (int i = 0; i < 10; i++) {
      if (isMounted) constructionController.construct(posDimetric: Point<int>(20 - i, -3), tileType: TileType.road);
      if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.yellow, const Point<int>(14, -11));
    if (isMounted) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 10));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.purple, const Point<int>(14, -11));
    if (isMounted) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 10));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(34, -1), buildingType: BuildingType.city, direction: Directions.W, hideMoney: true, cityType: CityType.classicCity);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) {
      gridController.internalBuildOnTile(coordinates: const Point<int>(31, 0), buildingType: BuildingType.garbageLoader, direction: Directions.W, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(30, 0), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(29, 0), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(29, 1), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(29, 2), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(29, 3), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(29, 4), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(28, 4), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(27, 4), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(26, 4), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(26, 5), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(26, 6), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(26, 7), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(25, 7), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(24, 7), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(23, 7), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(22, 7), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) await Future.delayed(const Duration(seconds: 1));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.blue, const Point<int>(14, -11));
    if (isMounted) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 5));
    if (isMounted) gridController.internalBuildOnTile(coordinates: const Point<int>(28, 7), buildingType: BuildingType.buryer, direction: Directions.S, hideMoney: true);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));

    if (isMounted) {
      gridController.internalBuildOnTile(
          coordinates: const Point<int>(28, 6), buildingType: BuildingType.garbageLoader, direction: Directions.N, garbageLoaderFlow: GarbageLoaderFlow.flowMirror, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(28, 5), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(seconds: 5));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.blue, const Point<int>(14, -11));
    if (isMounted) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
    if (isMounted) await Future.delayed(const Duration(seconds: 5));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.blue, const Point<int>(14, -11));
    if (isMounted) Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));

    if (isMounted) gridController.internalBuildOnTile(coordinates: const Point<int>(16, 9), buildingType: BuildingType.recycler, direction: Directions.E, hideMoney: true);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(17, 10), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(18, 10), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(18, 9), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(19, 9), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(19, 8), tileType: TileType.road);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(20, 8), tileType: TileType.road);

    if (isMounted) await Future.delayed(const Duration(seconds: 3));
    if (isMounted) gridController.internalBuildOnTile(coordinates: const Point<int>(24, 10), buildingType: BuildingType.composter, direction: Directions.S, hideMoney: true);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) {
      gridController.internalBuildOnTile(
          coordinates: const Point<int>(24, 9), buildingType: BuildingType.garbageLoader, direction: Directions.N, garbageLoaderFlow: GarbageLoaderFlow.flowMirror, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(24, 8), tileType: TileType.road);

    if (isMounted) await Future.delayed(const Duration(seconds: 5));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.blue, const Point<int>(14, -11));
    if (isMounted) Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));

    if (isMounted) await Future.delayed(const Duration(seconds: 3));
    if (isMounted) gridController.internalBuildOnTile(coordinates: const Point<int>(18, -9), buildingType: BuildingType.composter, direction: Directions.E, hideMoney: true);
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) {
      gridController.internalBuildOnTile(
          coordinates: const Point<int>(19, -9), buildingType: BuildingType.garbageLoader, direction: Directions.W, garbageLoaderFlow: GarbageLoaderFlow.flowMirror, hideMoney: true);
    }
    if (isMounted) await Future.delayed(const Duration(milliseconds: 100));
    if (isMounted) constructionController.construct(posDimetric: const Point<int>(20, -9), tileType: TileType.road);

    if (isMounted) await Future.delayed(const Duration(seconds: 5));
    if (isMounted) ref.read(allTrucksControllerProvider.notifier).addTruck(TruckType.blue, const Point<int>(14, -11));
    if (isMounted) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
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
/// WasteStackCount : 399
