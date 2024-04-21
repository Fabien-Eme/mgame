import 'dart:ui';

class Palette {
  static const Color red = Color.fromARGB(255, 250, 40, 40);
  static const Color darkRed = Color.fromARGB(255, 147, 1, 1);
  static const Color redTransparent = Color.fromARGB(100, 250, 40, 40);
  static const Color green = Color.fromARGB(255, 0, 255, 38);
  static const Color darkGreen = Color.fromARGB(255, 0, 158, 58);
  static const Color greenTransparent = Color.fromARGB(100, 0, 255, 38);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color darkGrey = Color.fromARGB(255, 124, 124, 124);
  static const Color grey = Color.fromARGB(255, 183, 183, 183);
  static const Color backGroundMenu = Color.fromARGB(0, 0, 0, 0);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color whiteTransparent = Color.fromARGB(200, 255, 255, 255);
  static const Color darkBlue = Color.fromARGB(255, 36, 80, 225);
  static const Color blackTransparent = Color.fromARGB(75, 0, 0, 0);
  static const Color blackAlmostOpaque = Color.fromARGB(200, 0, 0, 0);
  static const Color yellow = Color.fromARGB(255, 255, 234, 0);
  static const Color darkYellow = Color.fromARGB(255, 206, 172, 0);

  static const Color globalExcellent = Color.fromARGB(255, 0, 158, 58);
  static const Color globalGood = Color.fromARGB(255, 132, 207, 51);
  static const Color globalModerate = Color.fromARGB(255, 255, 255, 0);
  static const Color globalLow = Color.fromARGB(255, 255, 140, 0);
  static const Color globalPoor = Color.fromARGB(255, 255, 0, 0);
  static const Color globalVeryPoor = Color.fromARGB(255, 128, 0, 0);
}

Color convertGlobalAirQualityColor(String string) {
  switch (string) {
    case '009E3A':
      return Palette.globalExcellent;
    case '84CF33':
      return Palette.globalGood;
    case 'FFFF00':
      return Palette.globalModerate;
    case 'FF8C00':
      return Palette.globalLow;
    case 'FF0000':
      return Palette.globalPoor;
    case '800000':
      return Palette.globalVeryPoor;
    default:
      return Palette.white;
  }
}
