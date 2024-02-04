part of 'game_bloc.dart';

sealed class GameEvent {
  const GameEvent();
}

final class ConstructionModePressed extends GameEvent {
  const ConstructionModePressed({this.tileType, this.buildingType});
  final TileType? tileType;
  final BuildingType? buildingType;
}

final class ConstructionModeExited extends GameEvent {
  const ConstructionModeExited();
}

final class DestructionModePressed extends GameEvent {
  const DestructionModePressed();
}

final class DestructionModeExited extends GameEvent {
  const DestructionModeExited();
}
