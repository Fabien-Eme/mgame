import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_ui_controller.dart';

part 'game_ui.freezed.dart';

@freezed
class GameUi with _$GameUi {
  factory GameUi({
    required bool isVisibleSettings,
    required bool isVisibleForward,
    GameUiFunction? settingsFunction,
    GameUiFunction? forwardFunction,
  }) = _GameUi;

  factory GameUi.narrative() {
    return GameUi(isVisibleSettings: false, isVisibleForward: false);
  }
  factory GameUi.game() {
    return GameUi(isVisibleSettings: true, isVisibleForward: false);
  }

  factory GameUi.tutorial() {
    return GameUi(isVisibleSettings: false, isVisibleForward: false);
  }
}
