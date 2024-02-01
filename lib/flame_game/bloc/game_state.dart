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
  });

  final GameStatus status;
  final TileType? tileType;

  GameState copyWith({
    GameStatus? status,
    TileType? tileType,
  }) {
    return GameState(
      status: status ?? this.status,
      tileType: tileType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tileType,
      ];
}
