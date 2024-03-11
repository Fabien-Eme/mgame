import 'dart:ui';

import 'package:flame/text.dart';

import 'palette.dart';

class MyTextStyle {
  static TextPaint title = TextPaint(style: const TextStyle(fontSize: 48, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint button = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint buttonRed = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.red, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint tab = TextPaint(style: const TextStyle(fontSize: 18, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint text = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w400));
  static TextPaint bigText = TextPaint(style: const TextStyle(fontSize: 40, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w400));
  static TextPaint header = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint numberDisplay = TextPaint(style: const TextStyle(fontSize: 16, color: Palette.white, fontFamily: 'Play', fontWeight: FontWeight.w700));

  static TextPaint money = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.darkYellow, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint moneyNegative = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.darkRed, fontFamily: 'Play', fontWeight: FontWeight.w700));

  static TextPaint nameBar = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint nameBarWhite = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.white, fontFamily: 'Play', fontWeight: FontWeight.w700));

  static TextPaint dialogText = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w400));
  static TextPaint smallText = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w400));

  static TextPaint levelTitleBorder = TextPaint(
    style: TextStyle(
      fontSize: 30,
      fontFamily: 'Play',
      fontWeight: FontWeight.w400,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Palette.darkGrey,
    ),
  );

  static TextPaint levelTitle = TextPaint(style: const TextStyle(fontSize: 30, color: Palette.white, fontFamily: 'Play', fontWeight: FontWeight.w400));

  static TextPaint debugGridNumber = TextPaint(style: const TextStyle(fontSize: 12, color: Palette.white, fontFamily: 'Play', fontWeight: FontWeight.w400));
}
