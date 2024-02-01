part of 'game_bloc.dart';

enum GameStatus {
  initial,
  idle,
  construct,
  destruct,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initial,
    this.buildingType,
  });

  final GameStatus status;
  final BuildingType? buildingType;

  GameState copyWith({
    GameStatus? status,
    BuildingType? buildingType,
  }) {
    return GameState(
      status: status ?? this.status,
      buildingType: buildingType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        buildingType,
      ];
}
