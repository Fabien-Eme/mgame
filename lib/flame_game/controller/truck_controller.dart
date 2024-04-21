import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';

import '../buildings/garage/garage.dart';
import '../game.dart';
import '../level.dart';
import '../truck/truck.dart';
import '../ui/pollution_bar.dart';

class TruckController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  void buyTruck(TruckType truckType) {
    if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(truckType.model.buyCost.toDouble())) {
      (game.findByKeyName('level') as Level).money.addValue(-truckType.model.buyCost.toDouble());

      Point<int> truckSpawnLocation = world.buildings.whereType<Garage>().first.spawnPointDimetric;
      (game.findByKeyName('pollutionBar') as PollutionBar).addValue(truckType.model.buyPollution.toDouble());

      ref.read(allTrucksControllerProvider.notifier).addTruck(truckType, truckSpawnLocation);

      Future.delayed(const Duration(milliseconds: 100)).then((value) => world.add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
    }
  }

  void sellTruck(TruckType truckType) {
    //ref.read(allTrucksControllerProvider.notifier).removeTruck(truckType);
  }

  List<Truck> getAvailableTrucks({bool onlyTruckEmpty = false}) {
    List<Truck> listTrucksAvailable = [];
    Map<String, Truck> mapTrucksOwned = ref.read(allTrucksControllerProvider).trucksOwned;

    for (Truck truck in mapTrucksOwned.values) {
      if (truck.currentTask == null && (!onlyTruckEmpty || truck.loadQuantity == 0)) listTrucksAvailable.add(truck);
    }

    return listTrucksAvailable;

    // ///Group trucks by priorityForTask
    // Map<int, List<Truck>> groupedByPriority = {};
    // for (Truck truck in listTrucksAvailable) {
    //   groupedByPriority.putIfAbsent(truck.priorityForTask, () => []).add(truck);
    // }

    // // Sort groups by priority in descending order
    // List<int> sortedKeys = groupedByPriority.keys.toList(growable: false)..sort((k1, k2) => k2.compareTo(k1));

    // //Shuffle each group and flatten the list
    // List<Truck> sortedAndRandomized = [];
    // Random rng = Random();
    // for (var key in sortedKeys) {
    //   var group = groupedByPriority[key]!;
    //   // Shuffle the trucks with the same priority
    //   group.shuffle(rng);
    //   sortedAndRandomized.addAll(group);
    // }

    // return sortedAndRandomized;
  }

  List<Truck> getAllTrucks() {
    Map<String, Truck> mapTrucksOwned = ref.read(allTrucksControllerProvider).trucksOwned;

    return mapTrucksOwned.values.toList();
  }
}
