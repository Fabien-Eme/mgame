import 'dart:async';

import 'package:flame/components.dart';

import 'buildings/belt.dart';
import 'buildings/garbage_conveyor/garbage_conveyor_back.dart';
import 'buildings/garbage_conveyor/garbage_conveyor_front.dart';
import 'buildings/garbage_loader/garbage_loader.dart';
import 'buildings/garbage_loader/garbage_loader_front.dart';
import 'buildings/incinerator/incinerator.dart';
import 'utils/manage_coordinates.dart';

class ListDebugComponent extends Component with HasWorldReference {
  @override
  FutureOr<void> onLoad() {
    world.addAll([
      Belt(beltType: BeltType.beltWE, position: convertDimetricToWorldCoordinates(Vector2(8, 0))),
      Belt(beltType: BeltType.beltWE, position: convertDimetricToWorldCoordinates(Vector2(9, 0))),
      Belt(beltType: BeltType.beltSN, position: convertDimetricToWorldCoordinates(Vector2(11, 5))),
      Belt(beltType: BeltType.beltSN, position: convertDimetricToWorldCoordinates(Vector2(11, 4))),
      Belt(beltType: BeltType.beltWE, position: convertDimetricToWorldCoordinates(Vector2(6, -5))),
      Belt(beltType: BeltType.beltWE, position: convertDimetricToWorldCoordinates(Vector2(7, -5))),
      GarbageConveyorBack(position: convertDimetricToWorldCoordinates(Vector2(6, -5))),
      GarbageConveyorFront(position: convertDimetricToWorldCoordinates(Vector2(6, -5))),
      GarbageLoader(direction: Directions.E, garbageLoaderFlow: GarbageLoaderFlow.flowIn, position: convertDimetricToWorldCoordinates(Vector2(8, -5))),
      GarbageLoader(direction: Directions.S, garbageLoaderFlow: GarbageLoaderFlow.flowIn, position: convertDimetricToWorldCoordinates(Vector2(12, 0))),
      Incinerator(direction: Directions.E, position: convertDimetricToWorldCoordinates(Vector2(18, -5))),
      Incinerator(direction: Directions.S, position: convertDimetricToWorldCoordinates(Vector2(20, 7))),
    ]);
    return super.onLoad();
  }
}

    // add(Truck(position: Vector2(1405, 783), asset: Assets.images.truckTL.path));
    // add(Truck(position: Vector2(225, 203), asset: Assets.images.truckBR.path));
    // add(Truck(position: Vector2(305, 243), asset: Assets.images.truckBR.path));
    // add(Truck(position: Vector2(185, 183), asset: Assets.images.truckBR.path));