import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../game.dart';

class TaskController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  Map<String, Task> mapTask = {};

  ///
  ///
  /// Create a [Task], generate a random Id
  void createTask({required TaskType taskType, required Point<int> taskCoordinate, int? taskPriority, List<TaskRestriction>? taskRestrictions, String? linkedTaskId, List<String>? vehiculeAffected}) {
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    Task task = Task(
        id: id,
        taskType: taskType,
        taskCoordinate: taskCoordinate,
        taskPriority: taskPriority ?? 0,
        taskRestrictions: taskRestrictions ?? [],
        linkedTaskId: linkedTaskId,
        vehiculeAffected: vehiculeAffected ?? []);

    mapTask[id] = task;
  }

  ///
  ///
  /// Remove a [Task] from map
  void completeTask({required String taskId}) {
    mapTask.remove(taskId);
  }

  ///
  ///
  /// Get a [Task] by its id
  Task? getTaskById({required String taskId}) {
    return mapTask[taskId];
  }

  ///
  ///
  /// Get the highest priority [Task], if they are more than one, select at random among them.
  /// Optionnal parameter [withoutVehiculeAffected] to get the highest priority [Task] without vehicule affected to it
  Task? getHighestPriorityTask({bool withoutVehiculeAffected = false}) {
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
  String? linkedTaskId;
  List<String> vehiculeAffected;

  Task({
    required this.id,
    required this.taskType,
    required this.taskCoordinate,
    required this.taskPriority,
    required this.taskRestrictions,
    required this.linkedTaskId,
    required this.vehiculeAffected,
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
}

enum TaskRestrictionType {
  loadQuantity,
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
