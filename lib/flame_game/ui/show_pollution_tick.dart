import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';
import '../utils/my_text_style.dart';

class ShowPollutionTick extends PositionComponent with HasGameReference<MGame>, IgnoreEvents {
  int quantity;
  ShowPollutionTick({required this.quantity, super.position});

  late TextComponent textComponent;
  bool mustBeRemoved = false;

  @override
  FutureOr<void> onLoad() {
    textComponent = TextComponent(
      text: '+$quantity pollution',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.center,
    );
    add(textComponent);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!mustBeRemoved) {
      textComponent.position.y -= 100 * dt / 2;
      textComponent.textRenderer = TextPaint(
        style: (textComponent.textRenderer as TextPaint).style.copyWith(
              color: (textComponent.textRenderer as TextPaint).style.color?.withOpacity((1 + textComponent.position.y / 50).clamp(0, 1)),
            ),
      );
      if (textComponent.position.y <= -100) {
        mustBeRemoved = true;
      }
    } else {
      removeFromParent();
    }

    super.update(dt);
  }
}
