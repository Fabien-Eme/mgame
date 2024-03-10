import 'dart:async';

import 'package:flame/components.dart';

import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';

class Money extends PositionComponent {
  double startingAmount;
  Money({required this.startingAmount});

  late final TextComponent moneyTextComponent;
  List<TextComponent> listDroppedMoney = [];

  List<double> valueToAdd = [];
  double valueAdded = 0.0;

  double currentValue = 0.0;
  double realValue = 0.0;

  @override
  FutureOr<void> onLoad() {
    currentValue = startingAmount;
    realValue = startingAmount;
    anchor = Anchor.center;
    position = Vector2(MGame.gameWidth / 2, 32);

    add(moneyTextComponent = TextComponent(
      text: getText(currentValue),
      textRenderer: MyTextStyle.money,
      anchor: Anchor.center,
    ));
    return super.onLoad();
  }

  void addValue(double value, [bool hideMoney = false]) {
    valueToAdd.add(value);
    realValue += value;

    if (!hideMoney) {
      if (value < 0) {
        dropMoney(value);
      }
    }
  }

  void updateValue(double value) {
    currentValue += value;
    currentValue = currentValue.clamp(0, 1000000000);

    moneyTextComponent.text = getText(currentValue);
  }

  void consolidateValue() {
    currentValue = realValue;
    moneyTextComponent.text = getText(currentValue);
  }

  String getText(double value) {
    return '${(value / 1000).toStringAsFixed(2)} K\$';
  }

  void dropMoney(double value) {
    TextComponent textComponent = TextComponent(
      text: getText(value),
      textRenderer: MyTextStyle.moneyNegative,
      anchor: Anchor.center,
    );
    listDroppedMoney.add(textComponent);
    add(textComponent);
  }

  bool isEnoughMoney(double value) {
    if (value <= realValue) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void update(double dt) {
    /// Add or substract money
    if (valueToAdd.isNotEmpty) {
      if ((valueToAdd.first >= 0 && valueAdded < valueToAdd.first) || (valueToAdd.first < 0 && valueAdded > valueToAdd.first)) {
        if (valueToAdd.first < 1000 && valueToAdd.first > -1000) {
          valueAdded += valueToAdd.first;
          updateValue(valueToAdd.first);
        } else {
          valueAdded += valueToAdd.first * dt;
          updateValue(valueToAdd.first * dt);
        }
      } else {
        valueAdded = 0;
        valueToAdd.remove(valueToAdd.first);
      }
    } else {
      consolidateValue();
    }

    /// Animate money drop
    if (listDroppedMoney.isNotEmpty) {
      List<TextComponent> listComponentToRemove = [];
      for (TextComponent component in listDroppedMoney) {
        if (component.isMounted) {
          component.position.y += 50 * dt;
          component.textRenderer = TextPaint(
            style: (component.textRenderer as TextPaint).style.copyWith(
                  color: (component.textRenderer as TextPaint).style.color?.withOpacity((1 - component.position.y / 50).clamp(0, 1)),
                ),
          );
          if (component.position.y >= 50) {
            listComponentToRemove.add(component);
          }
        }
      }
      for (TextComponent component in listComponentToRemove) {
        listDroppedMoney.remove(component);
      }
      removeAll(listComponentToRemove);
    }
    super.update(dt);
  }
}
