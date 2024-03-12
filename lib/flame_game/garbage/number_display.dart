import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/ui/show_pollution_tick.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';
import '../ui/pollution_bar.dart';
import '../utils/palette.dart';

class NumberDisplay extends PositionComponent with HasGameReference<MGame>, HasWorldReference, RiverpodComponentMixin {
  double radius;

  NumberDisplay({required this.radius});

  late final CircleComponent circleComponent;
  late final TextComponent textComponent;
  int numberToDisplay = 0;
  bool isGeneratingPollution = false;

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
    if (stackQuantity > 60) {
      isGeneratingPollution = true;
      changeColor(ColorType.pollution);
    } else if (stackQuantity > 40) {
      isGeneratingPollution = false;
      changeColor(ColorType.danger);
    } else if (stackQuantity > 20) {
      isGeneratingPollution = false;
      changeColor(ColorType.warning);
    } else {
      isGeneratingPollution = false;
      changeColor(ColorType.normal);
    }
  }

  void changeColor(ColorType colorType) {
    Color color = switch (colorType) {
      ColorType.normal => Palette.darkBlue,
      ColorType.warning => Palette.globalModerate,
      ColorType.danger => Palette.globalLow,
      ColorType.pollution => Palette.globalVeryPoor,
    };
    circleComponent.paint = Paint()..color = color;

    if (color == Palette.globalModerate) {
      textComponent.textRenderer = MyTextStyle.numberDisplayBlack;
    } else {
      textComponent.textRenderer = MyTextStyle.numberDisplay;
    }
  }

  double timeElapsed = 0.0;

  @override
  void update(double dt) {
    if (isGeneratingPollution) {
      timeElapsed += dt;

      if (timeElapsed >= 1) {
        (game.findByKeyName('pollutionBar') as PollutionBar).addValue(50);
        add(ShowPollutionTick(quantity: 50));
        timeElapsed = 0;
      }
    } else {
      timeElapsed = 0;
    }

    super.update(dt);
  }
}

enum ColorType { normal, warning, danger, pollution }
