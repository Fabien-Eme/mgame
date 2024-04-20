import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/buryer/buryer.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/truck/truck.dart';
import 'package:uuid/uuid.dart';

import '../buildings/city/city.dart';
import '../game.dart';
import '../level.dart';
import '../ui/garbage_bar.dart';
import '../ui/pollution_bar.dart';
import 'waste_controller.dart';

class TaskController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  Map<String, Task> globalMapTask = {};

  ///
  ///
  /// Create a [Task], generate a random Id
  void createTask({
    required TaskType taskType,
    required Point<int> taskCoordinate,
    int? taskPriority,
    List<TaskRestriction>? taskRestrictions,
    List<TaskReward>? taskReward,
    String? linkedTaskId,
    List<String>? vehiculeAffected,
    Building? taskBuilding,
    BuildingType? taskBuildingType,
  }) {
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    Task task = Task(
      id: id,
      taskType: taskType,
      taskCoordinate: taskCoordinate,
      taskPriority: taskPriority ?? 0,
      taskRestrictions: taskRestrictions ?? [],
      taskReward: taskReward ?? [],
      linkedTaskId: linkedTaskId,
      vehiculeAffected: vehiculeAffected ?? [],
      taskBuilding: taskBuilding,
      taskBuildingType: taskBuildingType,
    );

    globalMapTask[id] = task;
  }

  ///
  ///
  /// Remove a [Task] from map
  void removeTask({required String taskId}) {
    globalMapTask.remove(taskId);
  }

  ///
  ///
  /// Get a [Task] by its id
  Task? getTaskById({required String taskId}) {
    return globalMapTask[taskId];
  }

  ///
  ///
  /// Get the highest priority [Task], if they are more than one, select at random among them.
  /// Optionnal parameter [withoutVehiculeAffected] to get the highest priority [Task] without vehicule affected to it
  Task? getHighestPriorityTask({required Map<String, Task> mapTask, bool withoutVehiculeAffected = false}) {
    if (mapTask.isEmpty) {
      return null;
    }

    int maxPriority = 0;

    if (withoutVehiculeAffected) {
      maxPriority = mapTask.values.fold<int>(0, (previousValue, task) {
        if (task.vehiculeAffected.isEmpty) {
          return max(previousValue, task.taskPriority);
        } else {
          return previousValue;
        }
      });
    } else {
      maxPriority = mapTask.values.fold<int>(0, (previousValue, task) => max(previousValue, task.taskPriority));
    }

    List<Task> highestPriorityTasks = [];

    if (withoutVehiculeAffected) {
      highestPriorityTasks = mapTask.values.where((task) => task.taskPriority == maxPriority && task.vehiculeAffected.isEmpty).toList();
    } else {
      highestPriorityTasks = mapTask.values.where((task) => task.taskPriority == maxPriority).toList();
    }

    if (highestPriorityTasks.length == 1) {
      return highestPriorityTasks.first;
    } else {
      final randomIndex = Random().nextInt(highestPriorityTasks.length);
      return highestPriorityTasks[randomIndex];
    }
  }

  ///
  ///
  /// Get all tasks available, ordered by priority, ordered by vehicule affected
  List<Task> getAllTaskAvailableOrdered() {
    List<Task> listTask = globalMapTask.values.toList();

    /// Check if Task is available
    for (Task task in listTask) {
      int? maxVehiculeAffected;
      List<TaskRestriction> taskRestriction = task.taskRestrictions.where((element) => element.taskRestrictionType == TaskRestrictionType.vehiculeQuantity).toList();
      if (taskRestriction.isNotEmpty) maxVehiculeAffected = taskRestriction.first.vehiculeQuantity;
      if (maxVehiculeAffected != null && task.vehiculeAffected.length >= maxVehiculeAffected) {
        listTask.remove(task);
      }
    }

    // Pre-sort step to introduce a random key for equal elements
    Random rng = Random();
    List<Map<String, dynamic>> tasksWithRandom = listTask.map((task) {
      // Generate a random key for each task
      double randomKey = rng.nextDouble();
      return {'task': task, 'randomKey': randomKey};
    }).toList();

    // Perform the sort
    tasksWithRandom.sort((a, b) {
      Task taskA = a['task'] as Task;
      Task taskB = b['task'] as Task;
      // Compare by taskPriority
      int priorityComparison = taskB.taskPriority.compareTo(taskA.taskPriority);
      if (priorityComparison != 0) return priorityComparison;

      // If taskPriority is equal, compare by totalWaste count
      int totalWasteComparison = getLoadingTaskTotalWaste(task: taskA).compareTo(getLoadingTaskTotalWaste(task: taskB));
      if (totalWasteComparison != 0) return -totalWasteComparison;

      // // If taskPriority is equal, compare by vehiculeAffected length
      // int vehiculeComparison = taskA.vehiculeAffected.length.compareTo(taskB.vehiculeAffected.length);
      // if (vehiculeComparison != 0) return vehiculeComparison;

      // If both are equal, use the pre-assigned random key
      return (a['randomKey'] as double).compareTo((b['randomKey'] as double));
    });

    // Extract the sorted tasks, discarding the random keys
    return tasksWithRandom.map((e) => e['task']).cast<Task>().toList();
  }

  void buildingBuilt(Building building) {
    switch (building.buildingType) {
      case BuildingType.city:
        break;
      case BuildingType.garbageLoader:
        for (City city in world.buildings.whereType<City>()) {
          if (city.loadTileCoordinate == building.anchorTile) {
            createTask(
              taskType: TaskType.collection,
              taskCoordinate: city.loadTileCoordinate,
              taskRestrictions: [TaskRestriction.simpleCollect()],
              taskReward: [TaskReward.loadWaste],
              taskBuilding: city,
              taskBuildingType: BuildingType.city,
            );
          }
        }

        for (Buryer buryer in world.buildings.whereType<Buryer>()) {
          if (buryer.unLoadTileCoordinate == building.anchorTile) {
            if (!buryer.isBuryerFull) {
              createTask(
                taskType: TaskType.delivery,
                taskCoordinate: buryer.unLoadTileCoordinate,
                taskRestrictions: [TaskRestriction.simpleDelivery()],
                taskReward: [TaskReward.unloadAll],
                taskBuilding: buryer,
                taskBuildingType: BuildingType.buryer,
              );
            }
          }
        }
      case BuildingType.recycler:
        createTask(
          taskType: TaskType.delivery,
          taskCoordinate: (building as Incinerator).deliveryPointDimetric,
          taskRestrictions: [TaskRestriction.simpleDelivery()],
          taskReward: [TaskReward.unloadAll],
          taskBuilding: building,
          taskBuildingType: BuildingType.recycler,
        );
        break;
      case BuildingType.incinerator:
        createTask(
          taskType: TaskType.delivery,
          taskCoordinate: (building as Incinerator).deliveryPointDimetric,
          taskRestrictions: [TaskRestriction.simpleDelivery()],
          taskReward: [TaskReward.unloadAll],
          taskBuilding: building,
          taskBuildingType: BuildingType.incinerator,
        );
        break;
      case BuildingType.garage:
        break;
      case BuildingType.buryer:
        break;
    }
  }

  void buildingDestroyed(Building building) {
    List<Task> listTaskToRemove = [];
    if (building.buildingType == BuildingType.garbageLoader) {
      List<Task> listTaskWithCity = globalMapTask.values.where((Task task) => task.taskBuilding?.buildingType == BuildingType.city).toList();
      for (Task task in listTaskWithCity) {
        if ((task.taskBuilding as City).loadTileCoordinate == building.anchorTile) listTaskToRemove.add(task);
      }
    } else {
      listTaskToRemove.addAll(globalMapTask.values.where((Task task) => task.taskBuilding == building).toList());
    }
    for (Task task in listTaskToRemove) {
      globalMapTask.remove(task.id);
    }
    verifyTrucksTaskStillExist();
  }

  void verifyTrucksTaskStillExist() {
    List<Truck> listTrucks = world.truckController.getAllTrucks();
    for (Truck truck in listTrucks) {
      if (truck.currentTask != null && !globalMapTask.containsKey(truck.currentTask!.id)) truck.currentTask = null;
    }
  }

  doesTruckSatisfyRestriction({required Truck truck, required List<TaskRestriction> restrictions}) {
    for (TaskRestriction taskRestriction in restrictions) {
      switch (taskRestriction.taskRestrictionType) {
        case TaskRestrictionType.loadMinQuantity:
          if (truck.loadQuantity < taskRestriction.loadQuantity!) return false;
        case TaskRestrictionType.loadMaxQuantity:
          if (truck.loadQuantity > taskRestriction.loadQuantity!) return false;
        case TaskRestrictionType.loadType:
          if (truck.loadType != taskRestriction.loadType!) return false;
        case TaskRestrictionType.vehiculeType:
          if (truck.vehiculeType != taskRestriction.vehiculeType!) return false;
        case TaskRestrictionType.vehiculeQuantity:
          break;
      }
    }
    return true;
  }

  void tryToMatchTaskWithVehicule() {
    bool isMatchPossible = true;
    bool hasMatched = false;

    while (isMatchPossible) {
      List<Task> allTaskAvailableOrdered = getAllTaskAvailableOrdered();
      if (allTaskAvailableOrdered.isNotEmpty) {
        do {
          List<Truck> listTrucksAvailable = world.truckController.getAvailableTrucksOrdered();
          if (listTrucksAvailable.isEmpty) isMatchPossible = false;

          Task task = allTaskAvailableOrdered.first;
          List<Truck> listTruck = listTrucksAvailable.where((Truck truck) => doesTruckSatisfyRestriction(truck: truck, restrictions: task.taskRestrictions) == true).toList();

          if (listTruck.isNotEmpty) {
            task.vehiculeAffected.add(listTruck.first.id);
            globalMapTask[task.id] = task;
            listTruck.first.affectTask(task);
            hasMatched = true;
          } else {
            allTaskAvailableOrdered.remove(task);
          }
        } while (!hasMatched && allTaskAvailableOrdered.isNotEmpty);
        if (!hasMatched && allTaskAvailableOrdered.isEmpty) isMatchPossible = false;
        hasMatched = false;
      } else {
        isMatchPossible = false;
      }
    }
  }

  int getLoadingTaskTotalWaste({required Task task}) {
    int totalWaste = 0;
    for (String wasteStackId in task.taskBuilding?.listWasteStackId ?? []) {
      totalWaste += world.wasteController.mapWasteStack[wasteStackId]?.stackQuantity ?? 0;
    }
    return totalWaste;
  }

  WasteStack? getHighestWasteStack({required Task task}) {
    List<String> listWasteStackId = task.taskBuilding?.listWasteStackId ?? [];

    if (world.isMounted) {
      return world.wasteController.getHighestWasteStackFromList(listWasteStackId: listWasteStackId);
    } else {
      return null;
    }
  }

  void completeTask({required Truck truck, required Task task}) async {
    for (TaskReward taskReward in task.taskReward) {
      switch (taskReward) {
        case TaskReward.loadWaste:
          await Future.delayed(const Duration(seconds: 1));

          WasteStack? wasteStack = getHighestWasteStack(task: task);
          if (wasteStack == null) break;
          int stackMax = wasteStack.stackQuantity;

          int loadMax = truck.maxLoad;
          int load = min(stackMax, loadMax);

          world.wasteController.mapWasteStack[wasteStack.id]?.stackQuantity = stackMax - load;

          await Future.delayed(const Duration(seconds: 1));
          truck.loadQuantity = load;
          truck.loadType = LoadType.garbageCan;

          truck.currentTask = null;
          truck.isCompletingTask = false;
          break;
        case TaskReward.unloadWaste:
          break;
        case TaskReward.unloadAll:

          /// BURYER
          if (task.taskBuildingType == BuildingType.buryer) {
            await Future.delayed(const Duration(seconds: 1));
            int loadQuantityRefused = (task.taskBuilding as Buryer).updateFillAmount(truck.loadQuantity);
            int loadQuantityAccepted = truck.loadQuantity - loadQuantityRefused;

            if (loadQuantityRefused != truck.loadQuantity) (task.taskBuilding as Buryer).showGarbageProcessedTick(quantity: (loadQuantityAccepted));

            (game.findByKeyName('garbageBar') as GarbageBar).addValue(loadQuantityAccepted.toDouble());

            await Future.delayed(const Duration(seconds: 1));
            truck.loadQuantity = loadQuantityRefused;
            truck.currentTask = null;
            truck.isCompletingTask = false;

            if (loadQuantityRefused > 0) {
              removeTask(taskId: task.id);
            }
          }

          /// INCINERATOR
          else {
            await Future.delayed(const Duration(seconds: 1));
            (game.findByKeyName('garbageBar') as GarbageBar).addValue(truck.loadQuantity.toDouble());
            (game.findByKeyName('level') as Level).money.addValue(truck.loadQuantity.toDouble() * 100 * (task.taskBuilding as Incinerator).moneyBonus, false);

            if (!(game.currentIncinerator?.isRecycler ?? false)) {
              (game.findByKeyName('pollutionBar') as PollutionBar).addValue(truck.loadQuantity.toDouble() * 50 * (task.taskBuilding as Incinerator).pollutionReduction);

              if (!(task.taskBuilding as Incinerator).isRecycler) {
                (task.taskBuilding as Incinerator).incineratorSmoke.resumeSmokeForDuration(const Duration(seconds: 5));
              }
            }

            (task.taskBuilding as Incinerator).showGarbageProcessedTick(quantity: (truck.loadQuantity));

            await Future.delayed(const Duration(seconds: 1));
            if (!(game.currentIncinerator?.isRecycler ?? false)) {
              (task.taskBuilding as Incinerator).showPollutionTick(quantity: (truck.loadQuantity.toDouble() * 50).round());
            }
            truck.loadQuantity = 0;

            truck.currentTask = null;
            truck.isCompletingTask = false;
          }

          break;
      }
    }
  }

  double _accumulator = 0;
  double refreshDelay = 1;

  @override
  void update(double dt) {
    super.update(dt);

    _accumulator += dt;
    if (_accumulator >= refreshDelay) {
      _accumulator = 0;
      tryToMatchTaskWithVehicule();
    }
  }
}

///
///
/// Definition of [Task] and its enum
class Task {
  String id;
  TaskType taskType;
  Point<int> taskCoordinate;
  int taskPriority;
  List<TaskRestriction> taskRestrictions;
  List<TaskReward> taskReward;
  String? linkedTaskId;
  List<String> vehiculeAffected;
  Building? taskBuilding;
  BuildingType? taskBuildingType;

  Task({
    required this.id,
    required this.taskType,
    required this.taskCoordinate,
    required this.taskPriority,
    required this.taskRestrictions,
    required this.taskReward,
    required this.linkedTaskId,
    required this.vehiculeAffected,
    required this.taskBuilding,
    required this.taskBuildingType,
  });
}

enum TaskType {
  collection,
  delivery,
}

///
///
/// Definition of [TaskRestriction] and its enum
class TaskRestriction {
  TaskRestrictionType taskRestrictionType;
  int? loadQuantity;
  LoadType? loadType;
  VehiculeType? vehiculeType;
  int? vehiculeQuantity;

  TaskRestriction({required this.taskRestrictionType, this.loadQuantity, this.loadType, this.vehiculeType, this.vehiculeQuantity});

  TaskRestriction.simpleCollect()
      : taskRestrictionType = TaskRestrictionType.loadMaxQuantity,
        loadQuantity = 0;

  TaskRestriction.simpleDelivery()
      : taskRestrictionType = TaskRestrictionType.loadMinQuantity,
        loadQuantity = 1;
}

enum TaskRestrictionType {
  loadMaxQuantity,
  loadMinQuantity,
  loadType,
  vehiculeType,
  vehiculeQuantity,
}

enum LoadType {
  garbageCan,
}

enum VehiculeType {
  truck,
}

enum TaskReward {
  loadWaste,
  unloadWaste,
  unloadAll,
}
