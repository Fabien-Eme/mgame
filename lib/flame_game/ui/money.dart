import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/snackbar.dart';

import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';
import '../level.dart';

class Money extends PositionComponent with HasGameReference<MGame> {
  double startingAmount;
  bool isHidden;
  Money({required this.startingAmount, this.isHidden = false});

  late final TextComponent moneyTextComponent;
  List<TextComponent> listDroppedMoney = [];

  List<double> valueToAdd = [];
  double valueAdded = 0.0;

  double currentValue = 0.0;
  double realValue = 0.0;

  bool isBlinking = false;
  double timeBlinked = 0.0;
  double timeElapsedBlink = 0.0;

  @override
  FutureOr<void> onLoad() {
    currentValue = startingAmount;
    realValue = startingAmount;
    anchor = Anchor.center;
    position = Vector2(MGame.gameWidth / 2, 32);

    if (!isHidden) {
      add(moneyTextComponent = TextComponent(
        text: getText(currentValue),
        textRenderer: MyTextStyle.money,
        anchor: Anchor.center,
      ));
    } else {
      moneyTextComponent = TextBoxComponent();
    }
    return super.onLoad();
  }

  void addValue(double value, [bool hideMoney = false]) {
    valueToAdd.add(value);
    realValue += value;

    if (!hideMoney && !isHidden) {
      dropMoney(value);
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
    late TextComponent textComponent;
    if (value < 0) {
      textComponent = TextComponent(
        text: getText(value),
        textRenderer: MyTextStyle.moneyNegative,
        anchor: Anchor.center,
      );
    } else {
      textComponent = TextComponent(
        text: getText(value),
        textRenderer: MyTextStyle.moneyPositive,
        anchor: Anchor.center,
      );
    }
    listDroppedMoney.add(textComponent);
    add(textComponent);
  }

  bool hasEnoughMoney(double value) {
    if (value <= realValue) {
      return true;
    } else {
      isBlinking = true;
      (game.findByKeyName('level') as Level?)?.snackbarController.addSnackbar(snackbarType: SnackbarType.notEnoughMoney);
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

    /// Make money total blink
    if (isBlinking) {
      if (timeBlinked < 8) {
        timeElapsedBlink += dt;
        if (timeElapsedBlink >= 0.1) {
          timeElapsedBlink = 0.0;
          timeBlinked++;
          if (moneyTextComponent.textRenderer == MyTextStyle.money) {
            moneyTextComponent.textRenderer = MyTextStyle.moneyNegative;
          } else {
            moneyTextComponent.textRenderer = MyTextStyle.money;
          }
        }
      } else {
        isBlinking = false;
        timeElapsedBlink = 0.0;
        timeBlinked = 0;
      }
    }

    super.update(dt);
  }
}
