import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../game.dart';
import '../truck/truck.dart';

class TruckController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  Map<String, Truck> mapTruck = {};

  void buyTruck() {
    ///TODO You are here moron
  }
}
