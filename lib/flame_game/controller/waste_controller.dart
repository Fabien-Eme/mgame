import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/buildings/city/city.dart';
import 'package:mgame/flame_game/waste/waste.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:uuid/uuid.dart';

import '../buildings/building.dart';
import '../game.dart';

class WasteController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  double timeElapsedToAddWaste = 0;
  final double deltaTimeToAddWaste = 1;

  Map<String, double> mapTimeElapsed = {};
  Map<String, double> mapDeltaTime = {};

  final double durationOfWasteMovement = 0.8;

  List<WasteAnimated> listWasteAnimated = [];

  Map<String, WasteStack> mapWasteStack = {};

  ///
  ///
  ///Create the stack wich will receive [Waste]
  void createWasteStack({required Building building, required double wasteRate, required WasteType wasteType, required int startingValue}) async {
    Waste waste = Waste(wasteType: wasteType, anchorBuilding: building, hasNumber: true, startingValue: startingValue);
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    WasteStack wasteStack = WasteStack(id: id, component: waste, stackQuantity: startingValue, anchorBuilding: building, wasteRate: wasteRate, wasteType: wasteType);

    mapWasteStack[id] = wasteStack;
    mapTimeElapsed[id] = 0;
    mapDeltaTime[id] = 1 / wasteRate;

    building.listWasteStackId.add(id);
    await world.add(waste);
    waste.position = (building as City).mapWastePosition[wasteType]!;
  }

  WasteType? getWasteStackType(String wasteStackId) {
    return mapWasteStack[wasteStackId]?.wasteType;
  }

  void updateWasteStackWasteRate({required String wasteStackId, required double wasteRate}) {
    mapDeltaTime[wasteStackId] = 1 / wasteRate;
  }

  void stopPollutionGeneration({required String wasteStackId}) {
    mapWasteStack[wasteStackId]!.stopPollutionGeneration();
  }

  void updateWasteStackPriority({required Building anchorBuilding, required int priority}) {
    for (WasteStack wasteStack in mapWasteStack.values) {
      if (wasteStack.anchorBuilding == anchorBuilding) {
        wasteStack.component.updatePriority(priority);
      }
    }
  }

  WasteStack? getHighestWasteStackFromList({required List<String> listWasteStackId}) {
    if (listWasteStackId.isEmpty) return null;

    WasteStack? highestWasteStack;
    int wasteStackQuantity = 0;
    for (String wasteStackId in listWasteStackId) {
      int currentStackQuantity = mapWasteStack[wasteStackId]?.stackQuantity ?? 0;
      if (currentStackQuantity > wasteStackQuantity) {
        wasteStackQuantity = currentStackQuantity;
        highestWasteStack = mapWasteStack[wasteStackId];
      }
    }
    return highestWasteStack;
  }

  ///
  ///
  /// Generate Waste

  void addWaste({required WasteStack wasteStack}) {
    wasteStack.changeStackQuantity(1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// Generate Waste periodically
    timeElapsedToAddWaste += dt;
    for (String key in mapTimeElapsed.keys) {
      mapTimeElapsed[key] = mapTimeElapsed[key]! + dt;
    }

    for (String key in mapDeltaTime.keys) {
      if (mapTimeElapsed[key]! >= mapDeltaTime[key]!) {
        addWaste(wasteStack: mapWasteStack[key]!);

        mapTimeElapsed[key] = mapTimeElapsed[key]! - mapDeltaTime[key]!;
      }
    }
  }

  // }
}

///
///
/// [Waste] that spawns, move to stack and get removed
class WasteAnimated {
  Waste component;
  double timeElapsed;
  Vector2 startingPosition;
  String wasteStackId;

  WasteAnimated({required this.component, required this.timeElapsed, required this.startingPosition, required this.wasteStackId});
}

///
///
/// [Waste] receiver, holds [stackQuantity]
class WasteStack {
  String id;
  Waste component;
  int stackQuantity;
  Building anchorBuilding;
  double wasteRate;
  WasteType wasteType;

  WasteStack({
    required this.id,
    required this.component,
    required this.stackQuantity,
    required this.anchorBuilding,
    required this.wasteRate,
    required this.wasteType,
  });

  void changeStackQuantity(int i) {
    stackQuantity += i;
    component.changeNumber(stackQuantity);
  }

  void stopPollutionGeneration() {
    component.stopPollutionGeneration();
  }
}
