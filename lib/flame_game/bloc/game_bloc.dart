import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<ConstructionModePressed>(
      (event, emit) {
        emit(state.copyWith(
          status: GameStatus.construct,
          buildingType: event.buildingType,
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
