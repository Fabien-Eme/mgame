import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:mgame/flame_game/utils/convert_rotations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../truck/truck.dart';

part 'all_trucks_controller.g.dart';
part 'all_trucks_controller.freezed.dart';

@Riverpod(keepAlive: true)
class AllTrucksController extends _$AllTrucksController {
  @override
  AllTrucks build() {
    return AllTrucks.initial();
  }

  void addTruck(TruckType truckType, Point<int> spawnLocation) {
    Map<String, Truck> trucksOwned = Map.of(state.trucksOwned);
    String truckId = const Uuid().v4();
    trucksOwned[truckId] = Truck(id: truckId, startingTileCoordinatesAtCreation: spawnLocation, truckType: truckType, truckDirection: Directions.E);
    state = state.copyWith(trucksOwned: trucksOwned, lastTruckAddedId: truckId);
  }

  void resetTruck() {
    state = AllTrucks.initial();
  }
}

@freezed
class AllTrucks with _$AllTrucks {
  factory AllTrucks({
    required Map<String, Truck> trucksOwned,
    String? lastTruckAddedId,
  }) = _AllTrucks;

  factory AllTrucks.initial() {
    return AllTrucks(trucksOwned: {});
  }
}
