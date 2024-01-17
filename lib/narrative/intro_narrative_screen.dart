import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_components/settings_button.dart';
import '../style/palette.dart';
import 'animated_narrative.dart';

class IntroNarrativeScreen extends ConsumerStatefulWidget {
  const IntroNarrativeScreen({super.key});

  @override
  ConsumerState<IntroNarrativeScreen> createState() => _IntroDialogScreenState();
}

class _IntroDialogScreenState extends ConsumerState<IntroNarrativeScreen> {
  bool isSettingsVisible = false;

  @override
  Widget build(BuildContext context) {
    final Palette palette = ref.watch(paletteProvider);

    return Scaffold(
      backgroundColor: palette.backgroundDark,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: isSettingsVisible,
                  child: const SettingsButton(light: true),
                ),
              ],
            ),
            const Center(
              child: AnimatedNarrative(
                textLines: [
                  'One day, a cataclysm will be inevitable.',
                  'That day has come.',
                  'Only you can prevent this.',
                ],
                initialDelayTime: Duration(seconds: 5),
              ),
            ),
          ],
        );
      }),
    );
  }
}
