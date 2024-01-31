import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/audio/audio_controller.dart';
import 'package:mgame/audio/sounds.dart';
import 'package:mgame/settings/settings.dart';
import 'package:mgame/style/menu/menu_text.dart';
import 'package:mgame/style/palette.dart';

import '../game/game_ui_controller.dart';
import '../narrative/narrative_controller.dart';
import '../style/menu/menu_gap.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ref.watch(paletteProvider).backgroundMain,
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(400, 800)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MenuVerticalGap(maxHeight: constraints.maxHeight),
                const MenuText(text: "M-GAME", style: MenuTextStyle.title),
                MenuVerticalGap(maxHeight: constraints.maxHeight),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _MenuLine('PLAY', onSelected: () {
                            if (ref.read(settingsProvider).skipIntro) {
                              ref.read(gameUiControllerProvider.notifier).load(gameUiType: GameUiType.game);

                              context.go('/game');
                            } else {
                              ref.read(audioControllerProvider.notifier).stopAllSound();
                              ref.read(audioControllerProvider.notifier).playSfx(SfxType.clickPlay);

                              ref.read(narrativeControllerProvider.notifier).load(title: 'intro');
                              ref.read(gameUiControllerProvider.notifier).load(gameUiType: GameUiType.narrative);

                              context.go('/narrative');
                            }
                          }),
                          _MenuLine('SETTINGS', onSelected: () {
                            ref.read(audioControllerProvider.notifier).playSfx(SfxType.buttonTap);
                            context.push('/settings');
                          }),
                          getQuitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                MenuVerticalGapLarge(maxHeight: constraints.maxHeight),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _MenuLine extends ConsumerWidget {
  final String title;

  final VoidCallback? onSelected;

  const _MenuLine(this.title, {this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkResponse(
      containedInkWell: true,
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: MenuText(text: title, style: MenuTextStyle.item),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getQuitButton() {
  if (kIsWeb) {
    return Container();
  } else if (Platform.isAndroid) {
    return _MenuLine('QUIT', onSelected: () {
      exit(0);
    });
  } else if (Platform.isIOS) {
    return Container();
  } else if (Platform.isWindows) {
    return _MenuLine('QUIT', onSelected: () {
      exit(0);
    });
  } else if (Platform.isMacOS) {
    return Container();
  } else if (Platform.isLinux) {
    return _MenuLine('QUIT', onSelected: () {
      exit(0);
    });
  } else {
    return Container();
  }
}
