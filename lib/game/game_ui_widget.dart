import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game_components/forward_button.dart';

import '../game_components/settings_button.dart';
import 'game_ui.dart';
import 'game_ui_controller.dart';

class GameUiWidget extends ConsumerWidget {
  const GameUiWidget({required this.gameUiType, super.key});

  final GameUiType gameUiType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameUi gameUi = ref.watch(gameUiControllerProvider)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: gameUi.isVisibleSettings,
              child: const SettingsButton(light: false),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IgnorePointer(
              ignoring: !gameUi.isVisibleForward,
              child: AnimatedOpacity(
                opacity: (gameUi.isVisibleForward) ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: ForwardButton(
                    light: true,
                    pulsating: true,
                    function: () {
                      ref.read(gameUiControllerProvider.notifier).getGameUiElementFunction(GameUiElement.forward)?.call();
                      ref.read(gameUiControllerProvider.notifier).hideGameUiElement(GameUiElement.forward);
                    }),
              ),
            ),
          ],
        )
      ],
    );
  }
}
