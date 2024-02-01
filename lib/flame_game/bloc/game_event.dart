part of 'game_bloc.dart';

enum BuildingType { roadSN, roadWE, factory }

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class ConstructionModePressed extends GameEvent {
  const ConstructionModePressed({required this.buildingType});
  final BuildingType buildingType;

  @override
  List<Object> get props => [buildingType];
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
