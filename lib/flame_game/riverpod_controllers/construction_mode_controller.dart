import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../buildings/building.dart';
import '../tile_helper.dart';
import '../utils/convert_rotations.dart';

part 'construction_mode_controller.g.dart';
part 'construction_mode_controller.freezed.dart';

@Riverpod(keepAlive: true)
class ConstructionModeController extends _$ConstructionModeController {
  @override
  ConstructionState build() {
    return ConstructionState(status: ConstructionMode.initial);
  }

  void enterConstructionMode({BuildingType? buildingType, Directions? buildingDirection, TileType? tileType}) {
    state = state.copyWith(status: ConstructionMode.construct, tileType: tileType, buildingType: buildingType, buildingDirection: buildingDirection);
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

  void rotateBuilding() {
    switch (state.buildingDirection) {
      case Directions.S:
        state = state.copyWith(buildingDirection: Directions.E);
      case Directions.W:
        state = state.copyWith(buildingDirection: Directions.S);
      case Directions.N:
        state = state.copyWith(buildingDirection: Directions.W);
      case Directions.E:
        state = state.copyWith(buildingDirection: Directions.N);
      case null:
        break;
    }
  }
}

@freezed
class ConstructionState with _$ConstructionState {
  factory ConstructionState({
    required ConstructionMode status,
    TileType? tileType,
    BuildingType? buildingType,
    Directions? buildingDirection,
  }) = _ConstructionState;
}

enum ConstructionMode {
  initial,
  idle,
  construct,
  destruct,
}
