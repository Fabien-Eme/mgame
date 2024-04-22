import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/buryer/buryer.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/truck/truck.dart';
import 'package:mgame/flame_game/ui/snackbar.dart';
import 'package:mgame/flame_game/waste/waste.dart';
import 'package:uuid/uuid.dart';

import '../buildings/city/city.dart';
import '../buildings/composter/composter.dart';
import '../buildings/garage/garage.dart';
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

  void buildingBuilt(Building? building) {
    if (building == null) return;

    switch (building.buildingType) {
      case BuildingType.city:
        break;
      case BuildingType.garbageLoader:
        for (City city in world.buildings.whereType<City>()) {
          if (city.loadTileCoordinate == building.anchorTile) {
            createTask(
              taskType: TaskType.collection,
              taskCoordinate: city.loadTileCoordinate,
              taskRestrictions: [TaskRestriction.emptyLoad()],
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
                taskPriority: 1,
                taskCoordinate: buryer.unLoadTileCoordinate,
                taskRestrictions: [TaskRestriction.hasLoad()],
                taskReward: [TaskReward.unloadAll],
                taskBuilding: buryer,
                taskBuildingType: BuildingType.buryer,
              );
            }
          }
        }

        for (Composter composter in world.buildings.whereType<Composter>()) {
          if (composter.unLoadTileCoordinate == building.anchorTile) {
            if (!composter.isComposterFull) {
              createTask(
                taskType: TaskType.delivery,
                taskPriority: 10,
                taskCoordinate: composter.unLoadTileCoordinate,
                taskRestrictions: [TaskRestriction.hasLoad(), TaskRestriction.loadIsOrganic()],
                taskReward: [TaskReward.unloadAll],
                taskBuilding: composter,
                taskBuildingType: BuildingType.composter,
              );
            }
          }
        }
      case BuildingType.recycler:
        createTask(
          taskType: TaskType.delivery,
          taskPriority: 10,
          taskCoordinate: (building as Incinerator).deliveryPointDimetric,
          taskRestrictions: [TaskRestriction.hasLoad(), TaskRestriction.loadIsRecyclable()],
          taskReward: [TaskReward.unloadAll],
          taskBuilding: building,
          taskBuildingType: BuildingType.recycler,
        );
        break;
      case BuildingType.incinerator:
        createTask(
          taskType: TaskType.delivery,
          taskPriority: 5,
          taskCoordinate: (building as Incinerator).deliveryPointDimetric,
          taskRestrictions: [TaskRestriction.hasLoad(), TaskRestriction.loadIsNotToxic()],
          taskReward: [TaskReward.unloadAll],
          taskBuilding: building,
          taskBuildingType: BuildingType.incinerator,
        );
        break;
      case BuildingType.garage:
        break;
      case BuildingType.buryer:
        break;
      case BuildingType.composter:
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

  bool doesTruckSatisfyRestriction({required Truck truck, required List<TaskRestriction> restrictions}) {
    for (TaskRestriction taskRestriction in restrictions) {
      switch (taskRestriction.taskRestrictionType) {
        case TaskRestrictionType.loadMinQuantity:
          if (truck.loadQuantity < taskRestriction.loadQuantity!) return false;
        case TaskRestrictionType.loadMaxQuantity:
          if (truck.loadQuantity > taskRestriction.loadQuantity!) return false;
        case TaskRestrictionType.loadType:
          if (truck.loadType != taskRestriction.loadType!) return false;
        case TaskRestrictionType.forbiddenLoadType:
          if (truck.loadType == taskRestriction.loadType!) return false;
        case TaskRestrictionType.vehiculeType:
          if (truck.vehiculeType != taskRestriction.vehiculeType!) return false;
        case TaskRestrictionType.vehiculeQuantity:
          break;
      }
    }
    return true;
  }

  void tryToMatchTaskWithVehicule() {
    ///
    /// Find task for empty truck according to their priority

    List<Truck> listEmptyTrucksAvailable = world.truckController.getAvailableTrucks(onlyTruckEmpty: true);
    List<Task> allTaskAvailableForEmptyTruck = [];
    for (Task task in globalMapTask.values) {
      for (TaskRestriction taskRestriction in task.taskRestrictions) {
        if (taskRestriction.taskRestrictionType == TaskRestrictionType.loadMaxQuantity && taskRestriction.loadQuantity == 0) {
          allTaskAvailableForEmptyTruck.add(task);
        }
      }
    }
    for (Truck truck in listEmptyTrucksAvailable) {
      if (truck.doIHavePriorityWaste()) {
        int priority = 4;
        List<WasteStack> listHighestWasteTackForMyPriority = [];

        while (priority > 0 && listHighestWasteTackForMyPriority.isEmpty) {
          for (Task task in allTaskAvailableForEmptyTruck) {
            WasteStack? wasteStack = getHighestWasteStackWithTruckPriority(truck: truck, task: task, specificPriority: priority);
            if (wasteStack != null) listHighestWasteTackForMyPriority.add(wasteStack);
          }
          priority--;
        }

        WasteStack? highestWasteStack;
        for (WasteStack wasteStack in listHighestWasteTackForMyPriority) {
          if (wasteStack.stackQuantity > (highestWasteStack?.stackQuantity ?? 0)) highestWasteStack = wasteStack;
        }
        if (highestWasteStack != null) {
          City city = highestWasteStack.anchorBuilding as City;
          for (Task task in globalMapTask.values) {
            if (task.taskBuilding == city) truck.affectTask(task);
          }
        }
      }
    }

    ///
    /// Find non-empty truck for prioritary task
    bool isMatchPossible = true;
    bool hasMatched = false;

    while (isMatchPossible) {
      List<Task> allTaskAvailableOrdered = getAllTaskAvailableOrdered();
      if (allTaskAvailableOrdered.isNotEmpty) {
        do {
          List<Truck> listTrucksAvailable = world.truckController.getAvailableTrucks();
          if (listTrucksAvailable.isEmpty) isMatchPossible = false;

          Task task = allTaskAvailableOrdered.first;
          List<Truck> listTruck = listTrucksAvailable.where((Truck truck) {
            if (doesTruckSatisfyRestriction(truck: truck, restrictions: task.taskRestrictions) == true) {
              if (task.taskBuildingType == BuildingType.city) {
                return doesCityHasWasteForTruck(truck: truck, task: task);
              } else {
                return true;
              }
            } else {
              return false;
            }
          }).toList();

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

  bool doesCityHasWasteForTruck({required Truck truck, required Task task}) {
    List<WasteType> listWasteTypeTruckAccepts = [];
    for (WasteType wasteType in truck.mapWastePriorities.keys) {
      if (truck.mapWastePriorities[wasteType] != 0) {
        listWasteTypeTruckAccepts.add(wasteType);
      }
    }

    bool doesCityHaveWasteForMe = false;
    for (WasteType wasteType in listWasteTypeTruckAccepts) {
      if ((task.taskBuilding as City).cityType.wasteRate(wasteType) > 0) doesCityHaveWasteForMe = true;
    }

    return doesCityHaveWasteForMe;
  }

  int getLoadingTaskTotalWaste({required Task task}) {
    int totalWaste = 0;
    for (String wasteStackId in task.taskBuilding?.listWasteStackId ?? []) {
      totalWaste += world.wasteController.mapWasteStack[wasteStackId]?.stackQuantity ?? 0;
    }
    return totalWaste;
  }

  WasteStack? getHighestWasteStackWithTruckPriority({required Truck truck, required Task task, int? specificPriority}) {
    int priority = 4;
    List<WasteType> listMostPrioritaryWasteTypeOfTruck = [];

    if (specificPriority == null) {
      while (priority > 0 && listMostPrioritaryWasteTypeOfTruck.isEmpty) {
        for (WasteType wasteType in truck.mapWastePriorities.keys) {
          if (truck.mapWastePriorities[wasteType] == priority) {
            listMostPrioritaryWasteTypeOfTruck.add(wasteType);
          }
        }
        priority--;
      }
    } else {
      for (WasteType wasteType in truck.mapWastePriorities.keys) {
        if (truck.mapWastePriorities[wasteType] == specificPriority) {
          listMostPrioritaryWasteTypeOfTruck.add(wasteType);
        }
      }
    }

    List<String> listWasteStackId = [];
    listWasteStackId.addAll(task.taskBuilding?.listWasteStackId ?? []);

    List<String> wasteStackIdToRemove = [];

    for (String wasteStackId in listWasteStackId) {
      if (!listMostPrioritaryWasteTypeOfTruck.contains(world.wasteController.getWasteStackType(wasteStackId))) {
        wasteStackIdToRemove.add(wasteStackId);
      }
    }

    for (String wasteStackId in wasteStackIdToRemove) {
      listWasteStackId.remove(wasteStackId);
    }

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

          WasteStack? wasteStack = getHighestWasteStackWithTruckPriority(truck: truck, task: task);
          if (wasteStack == null) {
            truck.isCompletingTask = false;
            truck.currentTask = null;
            break;
          }

          int stackMax = wasteStack.stackQuantity;

          int loadMax = truck.maxLoad;
          int load = min(stackMax, loadMax);

          world.wasteController.mapWasteStack[wasteStack.id]?.component.animateWasteTo(quantity: -load, to: task.taskCoordinate);

          await Future.delayed(const Duration(seconds: 1));
          world.wasteController.mapWasteStack[wasteStack.id]?.changeStackQuantity(-load);
          truck.loadQuantity = load;
          truck.loadType = wasteStack.wasteType;

          truck.currentTask = null;
          truck.isCompletingTask = false;
          break;
        case TaskReward.unloadWaste:
          break;
        case TaskReward.unloadAll:

          /// BURYER
          if (task.taskBuildingType == BuildingType.buryer) {
            task.taskBuilding?.isProcessingWaste = true;

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
              task.taskBuilding?.changeWasteAcceptance(false);
              (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.buryerFull);
            }

            Future.delayed(const Duration(seconds: 1)).then((_) => task.taskBuilding?.isProcessingWaste = false);
          }

          /// COMPOSTER
          else if (task.taskBuildingType == BuildingType.composter) {
            task.taskBuilding?.isProcessingWaste = true;

            await Future.delayed(const Duration(seconds: 1));
            int loadQuantityRefused = (task.taskBuilding as Composter).updateFillAmount(truck.loadQuantity);
            int loadQuantityAccepted = truck.loadQuantity - loadQuantityRefused;

            if (loadQuantityRefused != truck.loadQuantity) (task.taskBuilding as Composter).showGarbageProcessedTick(quantity: (loadQuantityAccepted));

            (game.findByKeyName('garbageBar') as GarbageBar).addValue(loadQuantityAccepted.toDouble());

            (game.findByKeyName('level') as Level).money.addValue(truck.loadQuantity.toDouble() * 200 * (task.taskBuilding as Composter).moneyBonus, false);

            Future.delayed(const Duration(milliseconds: 500))
                .then((_) => (task.taskBuilding as Composter).showMoneyGainedTick(quantity: (truck.loadQuantity.toDouble() * 200 * (task.taskBuilding as Composter).moneyBonus).toInt()));

            await Future.delayed(const Duration(seconds: 1));
            truck.loadQuantity = loadQuantityRefused;
            truck.currentTask = null;
            truck.isCompletingTask = false;

            if (loadQuantityRefused > 0) {
              task.taskBuilding?.changeWasteAcceptance(false);
              (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.composterFull);
              (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.composterDesactivated);
            }

            Future.delayed(const Duration(seconds: 1)).then((_) => task.taskBuilding?.isProcessingWaste = false);
          }

          /// INCINERATOR && RECYCLER
          else {
            task.taskBuilding?.isProcessingWaste = true;

            await Future.delayed(const Duration(seconds: 1));
            (game.findByKeyName('garbageBar') as GarbageBar).addValue(truck.loadQuantity.toDouble());

            int baseMoneyPerWaste = 150;
            if (!(task.taskBuilding as Incinerator).isRecycler) baseMoneyPerWaste = 200;
            (game.findByKeyName('level') as Level).money.addValue(truck.loadQuantity.toDouble() * baseMoneyPerWaste * (task.taskBuilding as Incinerator).moneyBonus, false);

            if (!(task.taskBuilding as Incinerator).isRecycler) {
              (game.findByKeyName('pollutionBar') as PollutionBar).addValue(truck.loadQuantity.toDouble() * 50 * (task.taskBuilding as Incinerator).pollutionReduction);
              (task.taskBuilding as Incinerator).incineratorSmoke.resumeSmokeForDuration(const Duration(seconds: 5));
            }

            (task.taskBuilding as Incinerator).showGarbageProcessedTick(quantity: (truck.loadQuantity));

            Future.delayed(const Duration(milliseconds: 500)).then(
                (_) => (task.taskBuilding as Incinerator).showMoneyGainedTick(quantity: (truck.loadQuantity.toDouble() * baseMoneyPerWaste * (task.taskBuilding as Incinerator).moneyBonus).toInt()));

            await Future.delayed(const Duration(seconds: 1));
            if (!(task.taskBuilding as Incinerator).isRecycler) {
              (task.taskBuilding as Incinerator).showPollutionTick(quantity: (truck.loadQuantity.toDouble() * 50).round());
            }
            truck.loadQuantity = 0;

            truck.currentTask = null;
            truck.isCompletingTask = false;

            Future.delayed(const Duration(seconds: 1)).then((_) => task.taskBuilding?.isProcessingWaste = false);
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

  void dumpLoad({required Truck truck}) {
    (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.dumpWasteInGarage);
    (game.findByKeyName('pollutionBar') as PollutionBar).addValue(truck.loadQuantity.toDouble() * 100);
    (world.buildings.firstWhere((building) => building is Garage) as Garage).showPollutionTick(quantity: (truck.loadQuantity.toDouble() * 100).round());

    truck.loadQuantity = 0;
  }

  void removeMyTask(Building building) {
    List<String> listTaskIdToRemove = [];
    for (Task task in globalMapTask.values) {
      if (task.taskBuilding == building) listTaskIdToRemove.add(task.id);
    }

    List<Truck> listAllTrucks = world.truckController.getAllTrucks();
    for (String id in listTaskIdToRemove) {
      for (Truck truck in listAllTrucks) {
        if (truck.currentTask?.id == id) truck.currentTask = null;
      }

      globalMapTask.remove(id);
    }
  }

  void addMyTask(Building building) {
    for (Task task in globalMapTask.values) {
      if (task.taskBuilding == building) return;
    }

    if (building.buildingType == BuildingType.incinerator || building.buildingType == BuildingType.recycler) {
      buildingBuilt(building);
    } else if (building.buildingType == BuildingType.buryer) {
      buildingBuilt(world.gridController.getBuildingOnTile((building as Buryer).unLoadTileCoordinate));
    } else if (building.buildingType == BuildingType.composter) {
      buildingBuilt(world.gridController.getBuildingOnTile((building as Composter).unLoadTileCoordinate));
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
  WasteType? loadType;
  VehiculeType? vehiculeType;
  int? vehiculeQuantity;

  TaskRestriction({required this.taskRestrictionType, this.loadQuantity, this.loadType, this.vehiculeType, this.vehiculeQuantity});

  TaskRestriction.emptyLoad()
      : taskRestrictionType = TaskRestrictionType.loadMaxQuantity,
        loadQuantity = 0;

  TaskRestriction.hasLoad()
      : taskRestrictionType = TaskRestrictionType.loadMinQuantity,
        loadQuantity = 1;

  TaskRestriction.loadIsNotToxic()
      : taskRestrictionType = TaskRestrictionType.forbiddenLoadType,
        loadType = WasteType.toxic;

  TaskRestriction.loadIsRecyclable()
      : taskRestrictionType = TaskRestrictionType.loadType,
        loadType = WasteType.recyclable;

  TaskRestriction.loadIsOrganic()
      : taskRestrictionType = TaskRestrictionType.loadType,
        loadType = WasteType.organic;
}

enum TaskRestrictionType {
  loadMaxQuantity,
  loadMinQuantity,
  loadType,
  vehiculeType,
  vehiculeQuantity,
  forbiddenLoadType,
}

enum VehiculeType {
  truck,
}

enum TaskReward {
  loadWaste,
  unloadWaste,
  unloadAll,
}
