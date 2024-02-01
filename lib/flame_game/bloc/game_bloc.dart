import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mgame/flame_game/tile.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<ConstructionModePressed>(
      (event, emit) {
        emit(state.copyWith(
          status: GameStatus.construct,
          tileType: event.tileType,
        ));
      },
    );
    on<ConstructionModeExited>(
      (event, emit) {
        emit(state.copyWith(
          status: GameStatus.idle,
        ));
      },
    );
    on<DestructionModePressed>(
      (event, emit) {
        emit(state.copyWith(
          status: GameStatus.destruct,
        ));
      },
    );
    on<DestructionModeExited>(
      (event, emit) {
        emit(state.copyWith(
          status: GameStatus.idle,
        ));
      },
    );
  }
}
