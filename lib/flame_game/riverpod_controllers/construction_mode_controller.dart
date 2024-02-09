import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../buildings/building.dart';
import '../tile.dart';

part 'construction_mode_controller.g.dart';
part 'construction_mode_controller.freezed.dart';

@Riverpod(keepAlive: true)
class ConstructionModeController extends _$ConstructionModeController {
  @override
  ConstructionState build() {
    return ConstructionState(status: ConstructionMode.initial);
  }

  void enterConstructionMode({BuildingType? buildingType, TileType? tileType}) {
    state = state.copyWith(status: ConstructionMode.construct, tileType: tileType, buildingType: buildingType);
  }

  void exitConstructionMode() {
    state = state.copyWith(status: ConstructionMode.idle);
  }

  void enterDestructionMode() {
    state = state.copyWith(status: ConstructionMode.destruct);
  }

  void exitDestructionMode() {
    state = state.copyWith(status: ConstructionMode.idle);
  }
}

@freezed
class ConstructionState with _$ConstructionState {
  factory ConstructionState({
    required ConstructionMode status,
    TileType? tileType,
    BuildingType? buildingType,
  }) = _ConstructionState;
}

enum ConstructionMode {
  initial,
  idle,
  construct,
  destruct,
}
