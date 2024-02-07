import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_controller.g.dart';
part 'game_controller.freezed.dart';

@Riverpod(keepAlive: true)
class GameController extends _$GameController {
  @override
  GameState build() {
    return GameState(status: GameStatus.initial);
  }
}

@freezed
class GameState with _$GameState {
  factory GameState({
    required GameStatus status,
  }) = _GameState;
}

enum GameStatus {
  initial,
  idle,
  construct,
  destruct,
}
