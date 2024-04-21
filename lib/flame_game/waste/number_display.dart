import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/score_controller.dart';
import 'package:mgame/flame_game/ui/show_pollution_tick.dart';
import 'package:mgame/flame_game/ui/snackbar.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/waste/waste.dart';

import '../game.dart';
import '../level.dart';
import '../level_world.dart';
import '../ui/pollution_bar.dart';
import '../utils/palette.dart';

class NumberDisplay extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  final double radius;
  final WasteType wasteType;

  NumberDisplay({required this.radius, required this.wasteType});

  late final CircleComponent circleComponent;
  late final TextComponent textComponent;
  int numberToDisplay = 0;
  bool isGeneratingPollution = false;
  bool canGeneratePollution = true;

  @override
  FutureOr<void> onLoad() {
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

    if (isGeneratingPollution && canGeneratePollution) {
      if (game.currentLevel != 0) {
        if (ref.read(scoreControllerProvider.notifier).cityHasGeneratedPollution()) {
          (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.starLost);
          (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.cityGenreatePollution);
        }
      }

      (game.findByKeyName('pollutionBar') as PollutionBar).addValue(50);
      add(ShowPollutionTick(quantity: wasteType.pollutionGenerated));
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

  void stopPollutionGeneration() {
    canGeneratePollution = false;
  }
}

enum ColorType { normal, warning, danger, pollution }
