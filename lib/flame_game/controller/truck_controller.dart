import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/controller/task_controller.dart';
import 'package:mgame/flame_game/game_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/all_trucks_controller.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';

import '../buildings/garage/garage.dart';
import '../game.dart';
import '../truck/truck.dart';

class TruckController extends Component with HasGameReference<MGame>, HasWorldReference<GameWorld>, RiverpodComponentMixin {
  Map<String, Truck> mapTruck = {};

  void buyTruck(TruckType truckType) {
    Point<int> truckSpawnLocation = world.buildings.whereType<Garage>().first.spawnPointDimetric;
    ref.read(allTrucksControllerProvider.notifier).addTruck(truckType, truckSpawnLocation);

    Future.delayed(const Duration(milliseconds: 100)).then((value) => game.world.add(ref.read(allTrucksControllerProvider).trucksOwned[ref.read(allTrucksControllerProvider).lastTruckAddedId]!));
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

  List<Truck> getAllTrucks() {
    Map<String, Truck> mapTrucksOwned = ref.read(allTrucksControllerProvider).trucksOwned;

    return mapTrucksOwned.values.toList();
  }

  void completeTask({required Truck truck, required Task task}) async {
    for (TaskReward taskReward in task.taskReward) {
      switch (taskReward) {
        case TaskReward.loadGarbage:
          await Future.delayed(const Duration(seconds: 2));
          int stackMax = game.garbageController.listGarbageStack[task.taskBuilding!.garbageStackId]?.stackQuantity ?? 0;
          int loadMax = truck.maxLoad;
          int load = min(stackMax, loadMax);

          game.garbageController.listGarbageStack[task.taskBuilding!.garbageStackId]?.stackQuantity = stackMax - load;
          truck.loadQuantity = load;
          truck.loadType = LoadType.garbageCan;

          truck.currentTask = null;
          truck.isCompletingTask = false;
          break;
        case TaskReward.unloadGarbage:
          break;
        case TaskReward.unloadAll:
          await Future.delayed(const Duration(seconds: 2));

          truck.loadQuantity = 0;

          truck.currentTask = null;
          truck.isCompletingTask = false;
          break;
      }
    }
  }
}
