import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/style/menu/menu_text.dart';
import 'package:mgame/style/palette.dart';

import '../style/menu/menu_button.dart';
import '../style/menu/menu_gap.dart';
import 'settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({this.isFromGame = false, super.key});

  final bool isFromGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsValues settings = ref.watch(settingsProvider);

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
                const MenuText(text: "SETTINGS", style: MenuTextStyle.title),
                MenuVerticalGap(maxHeight: constraints.maxHeight),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _SettingsLine(
                            'Music',
                            settings.musicOn ? Icons.music_note : Icons.music_off,
                            onSelected: () {
                              ref.read(settingsProvider.notifier).toggleMusic();
                            },
                          ),
                          MenuVerticalGap(maxHeight: constraints.maxHeight),
                          _SettingsLine(
                            'Sound FX',
                            settings.soundsOn ? Icons.graphic_eq : Icons.volume_off,
                            onSelected: () {
                              ref.read(settingsProvider.notifier).toggleSounds();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MenuVerticalGap(maxHeight: constraints.maxHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isFromGame)
                      MenuButton(
                          text: 'QUIT GAME',
                          buttonType: ButtonType.quit,
                          onPressed: () {
                            context.go('/');
                          }),
                    MenuButton(
                        text: 'BACK',
                        buttonType: ButtonType.standard,
                        onPressed: () {
                          context.pop();
                        }),
                  ],
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

class _SettingsLine extends StatelessWidget {
  final String title;

  final IconData iconData;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.iconData, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      containedInkWell: true,
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: MenuText(text: title, style: MenuTextStyle.item),
              ),
            ),
            Icon(
              iconData,
              size: 35,
            ),
          ],
        ),
      ),
    );
  }
}
