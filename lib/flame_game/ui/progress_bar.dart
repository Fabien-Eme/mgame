import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mgame/flame_game/riverpod_controllers/score_controller.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../level.dart';
import 'snackbar.dart';

const double barWidth = 500.0;
const double barHeight = 40.0;

class ProgressBar extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  double totalBarValue;
  String title;
  ProgressBarType progressBarType;
  void Function()? onComplete;
  bool isHidden;

  ProgressBar({required this.title, required this.totalBarValue, required this.progressBarType, this.onComplete, this.isHidden = false, super.key});

  late final ClipComponent clipFilledBar;
  late final ClipComponent clipEmptyBar;

  late final TextComponent titleComponent;
  late final TextComponent titleComponentWhite;
  late final TextComponent percentageComponent;
  late final TextComponent percentageComponentWhite;
  late final TextComponent currentValueComponent;
  late final TextComponent currentValueComponentWhite;

  double barProgress = 0.0;

  double valueToAdd = 0.0;
  double valueAdded = 0.0;

  double currentBarValue = 0.0;

  bool hasCalledOnComplete = false;
  bool hasCalledOnThreeQuarterComplete = false;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(barWidth, barHeight);

    if (!isHidden) {
      add(
        clipFilledBar = ClipComponent.rectangle(
          size: Vector2(0, barHeight),
          position: Vector2(0, 0),
          children: [
            FilledBar(progressBarType),
            titleComponentWhite = TextComponent(
              anchor: Anchor.center,
              text: title,
              textRenderer: MyTextStyle.nameBarWhite,
              size: Vector2(barWidth, barHeight),
              position: Vector2(barWidth / 2, barHeight / 2),
            ),
            percentageComponentWhite = TextComponent(
              anchor: Anchor.centerLeft,
              text: "0.00 %",
              textRenderer: MyTextStyle.nameBarWhite,
              size: Vector2(barWidth, barHeight),
              position: Vector2(20, barHeight / 2),
            ),
            currentValueComponentWhite = TextComponent(
              anchor: Anchor.centerRight,
              text: getCurrentValueText(),
              textRenderer: MyTextStyle.nameBarWhite,
              size: Vector2(barWidth, barHeight),
              position: Vector2(barWidth - 20, barHeight / 2),
            ),
          ],
        ),
      );
      add(
        clipEmptyBar = ClipComponent.rectangle(
          anchor: Anchor.topRight,
          size: Vector2(barWidth, barHeight),
          position: Vector2(barWidth, 0),
          children: [
            titleComponent = TextComponent(
              anchor: Anchor.center,
              text: title,
              textRenderer: MyTextStyle.nameBar,
              size: Vector2(barWidth, barHeight),
              position: Vector2(barWidth / 2, barHeight / 2),
            ),
            percentageComponent = TextComponent(
              anchor: Anchor.centerLeft,
              text: "0.00 %",
              textRenderer: MyTextStyle.nameBar,
              size: Vector2(barWidth, barHeight),
              position: Vector2(20, barHeight / 2),
            ),
            currentValueComponent = TextComponent(
              anchor: Anchor.centerRight,
              text: getCurrentValueText(),
              textRenderer: MyTextStyle.nameBar,
              size: Vector2(barWidth, barHeight),
              position: Vector2(barWidth - 20, barHeight / 2),
            ),
          ],
        ),
      );
      add(EmptyBar(progressBarType));
    }
    return super.onLoad();
  }

  void addValue(double value) {
    if (!isHidden) {
      valueToAdd += value;
    }
  }

  void updateValue(double value) {
    currentBarValue += value;
    currentBarValue = currentBarValue.clamp(0, totalBarValue);

    barProgress += value / totalBarValue;

    barProgress = barProgress.clamp(0, 1);
    updateBarProgress();

    if (barProgress >= 0.75) {
      if (!hasCalledOnThreeQuarterComplete) {
        hasCalledOnThreeQuarterComplete = true;
        if (progressBarType == ProgressBarType.pollution) {
          if (game.currentLevel != 0) {
            if (ref.read(scoreControllerProvider.notifier).pollutionHasGoneOverTreshold()) {
              (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.starLost);
              (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.pollutionOverTreshold);
            }
          }
        }
      }
    }

    if (barProgress >= 1) {
      if (!hasCalledOnComplete) {
        hasCalledOnComplete = true;
        onComplete?.call();
      }
    }
  }

  void updateBarProgress() {
    clipFilledBar.size = Vector2(barProgress * barWidth, barHeight);
    percentageComponentWhite.text = "${(barProgress * 100).toStringAsFixed(2)} %";
    currentValueComponentWhite.text = getCurrentValueText();

    clipEmptyBar.size = Vector2(barWidth - barProgress * barWidth, barHeight);
    titleComponent.position = Vector2(barWidth / 2 - barProgress * barWidth, barHeight / 2);
    percentageComponent.position = Vector2(20 - barProgress * barWidth, barHeight / 2);
    percentageComponent.text = "${(barProgress * 100).toStringAsFixed(2)} %";
    currentValueComponent.position = Vector2(barWidth - 20 - barProgress * barWidth, barHeight / 2);
    currentValueComponent.text = getCurrentValueText();
  }

  @override
  void update(double dt) {
    if ((valueToAdd > 0 && valueAdded < valueToAdd) || (valueToAdd < 0 && valueAdded > valueToAdd)) {
      valueAdded += valueToAdd * dt;
      updateValue(valueToAdd * dt);
    } else {
      valueAdded = 0;
      valueToAdd = 0;
    }

    super.update(dt);
  }

  String getCurrentValueText() {
    if (totalBarValue >= 1000) {
      return "${(currentBarValue / 1000).round()}K / ${(totalBarValue / 1000).round()}K";
    } else {
      return "${(currentBarValue).round()} / ${(totalBarValue).round()}";
    }
  }
}

class EmptyBar extends SpriteComponent with HasGameReference<MGame> {
  ProgressBarType progressBarType;
  EmptyBar(this.progressBarType);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(progressBarType.assetEmptyBar));
    size = Vector2(barWidth, barHeight);
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}

class FilledBar extends SpriteComponent with HasGameReference<MGame> {
  ProgressBarType progressBarType;
  FilledBar(this.progressBarType);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(progressBarType.assetFilledBar));
    size = Vector2(barWidth, barHeight);
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}

enum ProgressBarType {
  garbageProcessed,
  pollution;

  String get assetEmptyBar {
    switch (this) {
      case ProgressBarType.garbageProcessed:
        return Assets.images.ui.emptyGarbageProcessedBar.path;
      case ProgressBarType.pollution:
        return Assets.images.ui.emptyPollutionBar.path;
    }
  }

  String get assetFilledBar {
    switch (this) {
      case ProgressBarType.garbageProcessed:
        return Assets.images.ui.filledGarbageProcessedBar.path;
      case ProgressBarType.pollution:
        return Assets.images.ui.filledPollutionBar.path;
    }
  }
}
