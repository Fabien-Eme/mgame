import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/garage/garage.dart';

import 'convert_coordinates.dart';
import 'convert_rotations.dart';

class ListDebugComponent extends Component with HasWorldReference {
  @override
  FutureOr<void> onLoad() {
    world.addAll([
      // Belt(beltType: BeltType.beltWE, position: convertDimetricPointToWorldCoordinates(const Point(8, 0))),
      // Belt(beltType: BeltType.beltWE, position: convertDimetricPointToWorldCoordinates(const Point(9, 0))),
      // Belt(beltType: BeltType.beltSN, position: convertDimetricPointToWorldCoordinates(const Point(11, 5))),
      // Belt(beltType: BeltType.beltSN, position: convertDimetricPointToWorldCoordinates(const Point(11, 4))),
      // Belt(beltType: BeltType.beltWE, position: convertDimetricPointToWorldCoordinates(const Point(6, -5))),
      // Belt(beltType: BeltType.beltWE, position: convertDimetricPointToWorldCoordinates(const Point(7, -5))),
      // GarbageConveyorBack(position: convertDimetricPointToWorldCoordinates(const Point(6, -5))),
      // GarbageConveyorFront(position: convertDimetricPointToWorldCoordinates(const Point(6, -5))),
      // GarbageLoader(direction: Directions.E, garbageLoaderFlow: GarbageLoaderFlow.flowIn, position: convertDimetricPointToWorldCoordinates(const Point(8, -5)), anchorTile: const Point(0, 0)),
      // GarbageLoader(direction: Directions.S, garbageLoaderFlow: GarbageLoaderFlow.flowIn, position: convertDimetricPointToWorldCoordinates(const Point(12, 0)), anchorTile: const Point(0, 0)),
      // Incinerator(direction: Directions.E, position: convertDimetricPointToWorldCoordinates(const Point(18, -5)), anchorTile: const Point(0, 0)),
      Garage(direction: Directions.S, position: convertDimetricPointToWorldCoordinates(const Point(10, 0)), anchorTile: const Point(0, 0)),
    ]);
    return super.onLoad();
  }
}

    // add(Truck(position: Point(1405, 783), asset: Assets.images.truckTL.path));
    // add(Truck(position: Point(225, 203), asset: Assets.images.truckBR.path));
    // add(Truck(position: Point(305, 243), asset: Assets.images.truckBR.path));
    // add(Truck(position: Point(185, 183), asset: Assets.images.truckBR.path));