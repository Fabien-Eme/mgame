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
    this.tileType,
    this.buildingType,
  });

  final GameStatus status;
  final TileType? tileType;
  final BuildingType? buildingType;

  GameState copyWith({
    GameStatus? status,
    TileType? tileType,
    BuildingType? buildingType,
  }) {
    return GameState(
      status: status ?? this.status,
      tileType: tileType,
      buildingType: buildingType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tileType,
        buildingType,
      ];
}
