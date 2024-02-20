import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/audio/flutter_audio_controller.dart';
import '../game/game_ui_controller.dart';
import '../game/game_ui_widget.dart';
import '../narrative/narrative_controller.dart';
import '../style/palette.dart';
import 'animated_narrative.dart';
import 'narrative.dart';

class NarrativeScreen extends ConsumerWidget {
  const NarrativeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Palette palette = ref.watch(paletteProvider);

    final Narrative narrative = ref.watch(narrativeControllerProvider)!;
    final int textIndex = narrative.textIndex;
    final List<String>? textLines = narrative.text[textIndex.toString()] as List<String>?;
    final List<String>? previousTextLines = narrative.text[(textIndex - 1).toString()] as List<String>?;
    final Duration initialDelayTime = (narrative.textIndex == 1) ? const Duration(seconds: 4) : const Duration(seconds: 1);

    if (textIndex == 1) Future.delayed(const Duration(seconds: 4)).then((_) => ref.read(flutterAudioControllerProvider.notifier).resetMusic());

    return Scaffold(
      backgroundColor: palette.backgroundDark,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Center(
              child: AnimatedNarrative(
                key: ValueKey(textLines),
                textLines: textLines,
                previousTextLines: previousTextLines,
                initialDelayTime: initialDelayTime,
                onAnimationEnd: () {
                  if (narrative.hasFinishedNarrative) {
                    context.go('/game');
                  } else {
                    if (narrative.autoPlay && !narrative.isOver) {
                      ref.read(narrativeControllerProvider.notifier).forward();
                    } else {
                      ref.read(gameUiControllerProvider.notifier).setFunctionToGameUiElement(
                            gameUiElement: GameUiElement.forward,
                            gameUiFunction: GameUiFunction.forwardNarrative,
                          );
                      ref.read(gameUiControllerProvider.notifier).showGameUiElement(GameUiElement.forward);
                    }
                  }
                },
              ),
            ),
            const GameUiWidget(gameUiType: GameUiType.narrative),
          ],
        );
      }),
    );
  }
}
