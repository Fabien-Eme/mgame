import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../narrative/narrative_controller.dart';
import 'game_ui.dart';

part 'game_ui_controller.g.dart';

enum GameUiType { narrative, game, tutorial }

enum GameUiElement { settings, forward }

enum GameUiFunction { forwardNarrative }

@Riverpod(keepAlive: true)
class GameUiController extends _$GameUiController {
  @override
  GameUi? build() {
    return null;
  }

  void load({required GameUiType gameUiType}) {
    state = switch (gameUiType) {
      GameUiType.narrative => GameUi.narrative(),
      GameUiType.game => GameUi.game(),
      GameUiType.tutorial => GameUi.tutorial(),
    };
  }

  void showGameUiElement(GameUiElement gameUiElement) {
    toggleGameUiElement(gameUiElement, true);
  }

  void hideGameUiElement(GameUiElement gameUiElement) {
    toggleGameUiElement(gameUiElement, false);
  }

  void toggleGameUiElement(GameUiElement gameUiElement, bool toggleOn) {
    switch (gameUiElement) {
      case GameUiElement.settings:
        state = state?.copyWith(isVisibleSettings: toggleOn);

      case GameUiElement.forward:
        state = state?.copyWith(isVisibleForward: toggleOn);
    }
  }

  setFunctionToGameUiElement({required GameUiElement gameUiElement, required GameUiFunction? gameUiFunction}) {
    switch (gameUiElement) {
      case GameUiElement.settings:
        state = state?.copyWith(settingsFunction: gameUiFunction);

      case GameUiElement.forward:
        state = state?.copyWith(forwardFunction: gameUiFunction);
    }
  }

  Function? getGameUiElementFunction(GameUiElement gameUiElement) {
    return switch (gameUiElement) {
      GameUiElement.settings => getFunction(state!.settingsFunction),
      GameUiElement.forward => getFunction(state!.forwardFunction),
    };
  }

  Function? getFunction(GameUiFunction? gameUiFunction) {
    return switch (gameUiFunction) {
      GameUiFunction.forwardNarrative => () => ref.read(narrativeControllerProvider.notifier).forward(),
      null => null,
    };
  }
}
