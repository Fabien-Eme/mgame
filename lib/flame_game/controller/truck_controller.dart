import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../game.dart';
import '../truck/truck.dart';

class TruckController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  Map<String, Truck> mapTruck = {};

  @override
  FutureOr<void> onLoad() {
    Uuid uuid = const Uuid();

    String id = uuid.v4();

    return super.onLoad();
  }
}
