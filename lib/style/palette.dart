import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'palette.g.dart';

@Riverpod(keepAlive: true)
Palette palette(PaletteRef ref) {
  return Palette();
}

class Palette {
  Color get primary => const Color(0xFF182F46);
  Color get primaryLight => const Color(0xFF82B4AE);

  Color get secondary => const Color.fromARGB(255, 102, 127, 111);
  Color get secondaryDark => const Color.fromARGB(255, 72, 103, 96);

  Color get tertiary => const Color(0xFFB16C48);
  Color get tertiaryDark => const Color.fromARGB(255, 129, 78, 52);

  Color get quaternary => const Color(0xFFB8A975);

  Color get text => const Color(0xFF071A2F);
  Color get textWhite => const Color.fromARGB(255, 243, 246, 244);

  Color get backgroundMain => const Color(0xFFE0D9CB);
  Color get backgroundDark => const Color.fromARGB(255, 12, 24, 36);
}
