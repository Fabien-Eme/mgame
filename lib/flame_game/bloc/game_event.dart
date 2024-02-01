part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class ConstructionModePressed extends GameEvent {
  const ConstructionModePressed({required this.tileType});
  final TileType tileType;

  @override
  List<Object> get props => [tileType];
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
