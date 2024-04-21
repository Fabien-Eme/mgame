import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/utils/palette.dart';

class FillIndicator extends PositionComponent {
  FillIndicator({super.position});

  double fillAmount = 0;

  late RectangleComponent fillRectangle;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    addAll(
      [
        RectangleComponent.fromRect(
          const Rect.fromLTWH(2, 0, 50, 2),
          paint: Paint()..color = Palette.darkGrey,
        ),
        RectangleComponent.fromRect(
          const Rect.fromLTWH(2, 10, 50, 2),
          paint: Paint()..color = Palette.darkGrey,
        ),
        RectangleComponent.fromRect(
          const Rect.fromLTWH(0, 0, 2, 12),
          paint: Paint()..color = Palette.darkGrey,
        ),
        RectangleComponent.fromRect(
          const Rect.fromLTWH(52, 0, 2, 12),
          paint: Paint()..color = Palette.darkGrey,
        ),
        RectangleComponent.fromRect(
          const Rect.fromLTWH(2, 2, 50, 8),
          paint: Paint()..color = Palette.whiteTransparent,
        ),
        fillRectangle = RectangleComponent.fromRect(
          const Rect.fromLTWH(2, 2, 0, 8),
          paint: Paint()..color = Palette.green,
        ),
      ],
    );

    return super.onLoad();
  }

  void changeFillAmount(double newFillAmount) {
    fillAmount = newFillAmount;

    Color color = Palette.green;

    if (fillAmount > 0.5) color = Palette.yellow;
    if (fillAmount > 0.75) color = Palette.red;
    if (fillAmount == 1) color = Palette.darkGrey;

    fillRectangle.width = (50 * fillAmount);
    fillRectangle.paint.color = color;
  }
}
