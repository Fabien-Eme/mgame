import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../style/palette.dart';

class SettingsButton extends ConsumerWidget {
  const SettingsButton({
    this.light = false,
    super.key,
  });

  final bool light;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Palette palette = ref.watch(paletteProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            context.push('/settings', extra: true);
          },
          child: Icon(
            Icons.settings,
            color: (light) ? palette.textWhite : palette.primary,
            size: 40,
          ),
        ),
      ),
    );
  }
}
