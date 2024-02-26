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
    ref.read(allTrucksControllerProvider.notifier).removeTruck(truckType);
  }
}
