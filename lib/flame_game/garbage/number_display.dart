import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';
import '../utils/palette.dart';

class NumberDisplay extends PositionComponent with HasGameReference<MGame>, HasWorldReference, RiverpodComponentMixin {
  double radius;

  NumberDisplay({required this.radius});

  late final CircleComponent circleComponent;
  late final TextComponent textComponent;
  int numberToDisplay = 0;

  @override
  FutureOr<void> onLoad() {
    priority = 900;

    circleComponent = CircleComponent(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()..color = Palette.darkBlue,
    );
    add(circleComponent);

    textComponent = TextComponent(
      text: numberToDisplay.toString(),
      textRenderer: MyTextStyle.numberDisplay,
      anchor: Anchor.center,
    );
    add(textComponent);

    return super.onLoad();
  }

  void changeNumber(int stackQuantity) {
    textComponent.text = stackQuantity.toString();
  }
}
