import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/truck/truck_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_trucks_controller.g.dart';
part 'all_trucks_controller.freezed.dart';

@Riverpod(keepAlive: true)
class AllTrucksController extends _$AllTrucksController {
  @override
  AllTrucks build() {
    return AllTrucks.initial();
  }

  addTruck(TruckType truckType) {
    Map<TruckType, int> trucksOwned = Map.of(state.trucksOwned);
    trucksOwned[truckType] = (trucksOwned[truckType] ?? 0) + 1;
    state = state.copyWith(trucksOwned: trucksOwned);
  }

  removeTruck(TruckType truckType) {
    Map<TruckType, int> trucksOwned = Map.of(state.trucksOwned);
    trucksOwned[truckType] = ((trucksOwned[truckType] ?? 0) - 1).clamp(0, 1000);
    state = state.copyWith(trucksOwned: trucksOwned);
  }
}

@freezed
class AllTrucks with _$AllTrucks {
  factory AllTrucks({
    required Map<TruckType, int> trucksOwned,
  }) = _AllTrucks;

  factory AllTrucks.initial() {
    return AllTrucks(trucksOwned: {});
  }
}
