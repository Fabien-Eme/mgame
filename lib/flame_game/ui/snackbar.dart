import 'dart:ui';

import 'package:flame/components.dart';

import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/ui/custom_ninetilebox.dart';
import 'package:mgame/flame_game/ui/custom_ninetilebox_component.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';

class SnackBar extends PositionComponent with HasGameReference<MGame> {
  final SnackbarType snackbarType;
  int rank;
  Function() callback;

  SnackBar({required this.snackbarType, required this.rank, required this.callback});

  late final TextComponent textComponent;

  late final CustomNineTileBoxComponent background;
  late final CustomNineTileBox nineTileBox;

  bool isDisplayed = false;
  bool isDisapearing = false;
  bool isChangingRank = false;

  double rankPosition = 0;

  double opacity = 1.0;

  final double snackbarWidth = 500;
  final double snackbarOffset = 25;
  late final double snackbarWidthWithOffset;

  @override
  void onLoad() {
    snackbarWidthWithOffset = snackbarWidth + snackbarOffset;
    position = Vector2(MGame.gameWidth, MGame.gameHeight / 3 + rank * 75);

    nineTileBox = CustomNineTileBox.withGrid(
      Sprite(game.images.fromCache(Assets.images.ui.dialog.snackbar.path)),
      leftWidth: 50,
      rightWidth: 50,
      topHeight: 50,
      bottomHeight: 50,
    );
    nineTileBox.sprite.paint.filterQuality = FilterQuality.low;

    background = CustomNineTileBoxComponent(
      nineTileBox: nineTileBox,
      size: Vector2(snackbarWidth, 50),
      anchor: Anchor.centerLeft,
    );

    add(background);

    textComponent = TextComponent(
      text: snackbarType.text,
      textRenderer: MyTextStyle.dialogText,
      position: Vector2(20, 0),
      anchor: Anchor.centerLeft,
    );

    add(textComponent);
    super.onLoad();
  }

  double timer = 0.0;

  @override
  void update(double dt) {
    if (position.x > MGame.gameWidth - snackbarWidthWithOffset && (position.x - snackbarWidthWithOffset * 10 * dt) >= (MGame.gameWidth - snackbarWidthWithOffset)) {
      position.x -= snackbarWidthWithOffset * 10 * dt;
    } else {
      position.x = MGame.gameWidth - snackbarWidthWithOffset;
      if (!isDisplayed) isDisplayed = true;
    }

    if (isDisplayed && !isDisapearing) {
      timer += dt;
      if (timer > 3) {
        isDisapearing = true;
      }
    }

    if (isDisplayed && isDisapearing) {
      opacity = clampDouble(opacity - 2 * dt, 0, 1);

      background.changeOpacity(opacity);
      textComponent.textRenderer = TextPaint(
        style: (textComponent.textRenderer as TextPaint).style.copyWith(
              color: (textComponent.textRenderer as TextPaint).style.color?.withOpacity(opacity),
            ),
      );

      if (opacity < 0.25) {
        isDisplayed = false;
        callback.call();
      }
    }

    if (isChangingRank) {
      if (position.y > rankPosition) {
        position.y -= 50 * 10 * dt;
      } else {
        isChangingRank = false;
      }
    }
    super.update(dt);
  }

  void updateRank(int newRank) {
    rank = newRank;
    rankPosition = MGame.gameHeight / 3 + rank * 75;
    isChangingRank = true;
  }
}

enum SnackbarType {
  notEnoughMoney,
  buildingIsProcessingWaste,
  dumpWasteInGarage,
  starLost,
  pollutionOverTreshold,
  cityGenreatePollution,
  composterFull,
  composterDesactivated,
  buryerFull;

  String get text {
    switch (this) {
      case SnackbarType.notEnoughMoney:
        return 'Insufficient funds';
      case SnackbarType.buildingIsProcessingWaste:
        return 'Building is processing waste';
      case SnackbarType.dumpWasteInGarage:
        return 'Waste has been dumped in the garage';
      case SnackbarType.starLost:
        return 'You have lost a star';
      case SnackbarType.pollutionOverTreshold:
        return 'Pollution reached 75%';
      case SnackbarType.cityGenreatePollution:
        return 'A city generated pollution';
      case SnackbarType.composterFull:
        return 'A composter is full';
      case SnackbarType.composterDesactivated:
        return 'Reactivate it when you can';
      case SnackbarType.buryerFull:
        return 'A buryer is full';
    }
  }
}
