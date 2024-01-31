import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../style/palette.dart';

class ForwardButton extends ConsumerWidget {
  const ForwardButton({
    this.light = false,
    this.function,
    this.pulsating = false,
    super.key,
  });

  final bool light;
  final Function? function;
  final bool pulsating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Palette palette = ref.watch(paletteProvider);

    final Widget iconForward = Icon(
      Icons.arrow_forward_ios,
      color: (light) ? palette.textWhite : palette.primary,
      size: 40,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 20.0, left: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            function?.call();
          },
          child: (pulsating)
              ? Animate(
                  key: UniqueKey(),
                  onPlay: (controller) => controller.repeat(reverse: true),
                  effects: [
                    FadeEffect(
                      begin: 0,
                      end: 1,
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                    )
                  ],
                  child: iconForward,
                )
              : iconForward,
        ),
      ),
    );
  }
}
