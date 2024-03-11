import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/garbage/garbage.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:uuid/uuid.dart';

import '../buildings/building.dart';
import '../game.dart';

class GarbageController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  double timeElapsedToAddGarbage = 0;
  final double deltaTimeToAddGarbage = 2;

  final double durationOfGarbageMovement = 0.8;

  List<GarbageAnimated> listGarbageAnimated = [];

  Map<String, GarbageStack> listGarbageStack = {};

  ///
  ///
  ///Create the stack wich will receive [Garbage]
  void createGarbageStack({required Building building}) async {
    Garbage garbage = createGarbage(garbageType: GarbageType.garbageCan, anchorBuilding: building, hasNumber: true);
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    GarbageStack garbageStack = GarbageStack(id: id, component: garbage, stackQuantity: 0, anchorBuilding: building);
    listGarbageStack[id] = garbageStack;
    building.garbageStackId = id;
    await world.add(garbage);
    garbage.position = building.finalGarbagePosition;
  }

  ///
  ///
  /// Generate Garbage
  void addGarbage({required GarbageType garbageType, required Building anchorBuilding, required Vector2 position}) async {
    Garbage garbage = createGarbage(garbageType: garbageType, anchorBuilding: anchorBuilding);

    await world.add(garbage);
    garbage.position = position;
    listGarbageAnimated.add(GarbageAnimated(
        component: garbage,
        timeElapsed: 0,
        startingPosition: position,
        garbageStackId: listGarbageStack.values
            .firstWhere((GarbageStack garbageStack) => garbageStack.component.garbageType == GarbageType.garbageCan && garbageStack.anchorBuilding == garbage.anchorBuilding)
            .id));
  }

  @override
  void update(double dt) {
    super.update(dt);

    /// Generate Garbage periodically
    timeElapsedToAddGarbage += dt;

    if (timeElapsedToAddGarbage >= deltaTimeToAddGarbage) {
      for (GarbageStack garbageStack in listGarbageStack.values) {
        addGarbage(
          garbageType: GarbageType.garbageCan,
          anchorBuilding: garbageStack.anchorBuilding,
          position: getRandomVectorInList(
            garbageStack.anchorBuilding.listInitialGarbagePosition,
          ),
        );
      }

      timeElapsedToAddGarbage -= deltaTimeToAddGarbage;
    }

    /// Animate generated garbage and remove if end
    for (int i = listGarbageAnimated.length - 1; i >= 0; i--) {
      GarbageAnimated garbageAnimated = listGarbageAnimated[i];
      garbageAnimated.timeElapsed += dt;

      final double progress = garbageAnimated.timeElapsed / durationOfGarbageMovement;
      final double clampedProgress = progress.clamp(0.0, 1.0);

      moveGarbageFromTo(garbageAnimated.component, garbageAnimated.startingPosition, garbageAnimated.component.anchorBuilding.finalGarbagePosition, clampedProgress);

      if (clampedProgress >= 1) {
        listGarbageStack[garbageAnimated.garbageStackId]?.changeStackQuantity(1);
        listGarbageAnimated.remove(garbageAnimated);
        world.remove(garbageAnimated.component);
      }
    }
  }

  ///
  ///
  /// Select random anchor for garbage generation
  Vector2 getRandomVectorInList(List<Vector2> list) {
    final random = Random();
    int index = random.nextInt(list.length);
    return list[index];
  }

  ///
  ///
  /// Interpolate movement
  void moveGarbageFromTo(Garbage garbage, Vector2 startingPosition, Vector2 targetPosition, double progress) {
    Vector2 offset = Vector2(
      ((targetPosition.x - startingPosition.x) * pow(progress, 5)),
      ((targetPosition.y - startingPosition.y) * pow(progress, 5)),
    );
    garbage.position = startingPosition + offset;
  }
  // }
}

///
///
/// [Garbage] that spawns, move to stack and get removed
class GarbageAnimated {
  Garbage component;
  double timeElapsed;
  Vector2 startingPosition;
  String garbageStackId;

  GarbageAnimated({required this.component, required this.timeElapsed, required this.startingPosition, required this.garbageStackId});
}

///
///
/// [Garbage] receiver, holds [stackQuantity]
class GarbageStack {
  String id;
  Garbage component;
  int stackQuantity;
  Building anchorBuilding;

  GarbageStack({required this.id, required this.component, required this.stackQuantity, required this.anchorBuilding});

  void changeStackQuantity(int i) {
    stackQuantity += i;
    component.changeNumber(stackQuantity);
  }
}
