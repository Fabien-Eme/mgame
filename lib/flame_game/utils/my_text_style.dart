import 'dart:ui';

import 'package:flame/text.dart';

import 'palette.dart';

class MyTextStyle {
  static TextPaint title = TextPaint(style: const TextStyle(fontSize: 48, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint button = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint buttonRed = TextPaint(style: const TextStyle(fontSize: 24, color: Palette.red, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint tab = TextPaint(style: const TextStyle(fontSize: 18, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint text = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w400));
  static TextPaint header = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.darkGrey, fontFamily: 'Play', fontWeight: FontWeight.w700));
  static TextPaint numberDisplay = TextPaint(style: const TextStyle(fontSize: 16, color: Palette.white, fontFamily: 'Play', fontWeight: FontWeight.w700));
}
