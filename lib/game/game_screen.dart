import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../style/palette.dart';
import 'game_ui_controller.dart';
import 'game_ui_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Palette palette = ref.watch(paletteProvider);

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Center(
                  child: Stack(
                children: [
                  Image.asset('assets/images/cardboard.png'),
                ],
              )),
              const GameUiWidget(gameUiType: GameUiType.game),
            ],
          );
        }),
      ),
    );
  }
}
