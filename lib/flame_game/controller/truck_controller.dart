import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';

import '../game.dart';
import '../truck/truck.dart';

class TruckController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  Map<String, Truck> mapTruck = {};

  void buyTruck(TruckType truckType) {
    ref.read(allTrucksControllerProvider.notifier).addTruck(truckType);
  }

  void sellTruck(TruckType truckType) {
    //ref.read(allTrucksControllerProvider.notifier).removeTruck(truckType);
  }

  List<Truck> getAvailableTrucksOrdered() {
    List<Truck> listTrucksAvailable = [];
    Map<String, Truck> mapTrucksOwned = ref.read(allTrucksControllerProvider).trucksOwned;

    for (Truck truck in mapTrucksOwned.values) {
      if (truck.currentTask == null) listTrucksAvailable.add(truck);
    }

    ///Group trucks by priorityForTask
    Map<int, List<Truck>> groupedByPriority = {};
    for (Truck truck in listTrucksAvailable) {
      groupedByPriority.putIfAbsent(truck.priorityForTask, () => []).add(truck);
    }

    // Sort groups by priority in descending order
    List<int> sortedKeys = groupedByPriority.keys.toList(growable: false)..sort((k1, k2) => k2.compareTo(k1));

    //Shuffle each group and flatten the list
    List<Truck> sortedAndRandomized = [];
    Random rng = Random();
    for (var key in sortedKeys) {
      var group = groupedByPriority[key]!;
      // Shuffle the trucks with the same priority
      group.shuffle(rng);
      sortedAndRandomized.addAll(group);
    }

    return sortedAndRandomized;
  }
}
