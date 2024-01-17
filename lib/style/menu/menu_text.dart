import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/style/palette.dart';

import '../font_family.dart';

enum MenuTextStyle { title, item, button }

enum MenuTextColor { white, black }

class MenuText extends ConsumerWidget {
  const MenuText({required this.text, required this.style, this.color, super.key});

  final String text;
  final MenuTextStyle style;
  final MenuTextColor? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = switch (style) {
      MenuTextStyle.title => 70,
      MenuTextStyle.item => 40,
      MenuTextStyle.button => 25,
    };

    Color textColor = switch (color) {
      null => ref.watch(paletteProvider).text,
      MenuTextColor.white => ref.watch(paletteProvider).textWhite,
      MenuTextColor.black => ref.watch(paletteProvider).text,
    };

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: fontSize,
        height: 1,
      ),
    );
  }
}
