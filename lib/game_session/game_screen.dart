import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_components/settings_button.dart';
import '../style/palette.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Palette palette = ref.watch(paletteProvider);

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SettingsButton(),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints.loose(const Size(400, 800)),
              child: const Text('Game Screen'),
            ),
          ],
        );
      }),
    );
  }
}
