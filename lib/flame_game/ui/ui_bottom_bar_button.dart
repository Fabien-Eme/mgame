import 'dart:ui';

import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';
import '../level.dart';
import '../riverpod_controllers/ui_controller.dart';

class UIBottomBarButton extends SpriteButtonComponent with HasGameReference, RiverpodComponentMixin {
  ButtonType buttonType;
  UIBottomBarButton({required this.buttonType, required super.size, super.position});

  bool isActive = false;

  @override
  void onMount() async {
    addToGameWidgetBuild(() {
      isActive = ref.watch(activeUIButtonControllerProvider) == buttonType;
      button = getButtonSprite(false);
      buttonDown = getButtonSprite(true);
    });
    button = getButtonSprite(false);
    buttonDown = getButtonSprite(true);

    await add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache(buttonType.path)),
        paint: Paint()..filterQuality = FilterQuality.low,
        position: size / 2,
        anchor: Anchor.center,
      ),
    );

    if (buttonType.displayCost > 0.0) {
      String typeCost = "";
      if (buttonType.displayCost < 1) {
        typeCost = '${buttonType.displayCost.toStringAsFixed(2)}K\$';
      } else {
        typeCost = '${buttonType.displayCost.toInt()}K\$';
      }
      add(
        TextComponent(
          text: typeCost,
          textRenderer: MyTextStyle.uiButtonBorder,
          anchor: Anchor.center,
          position: Vector2(size.x / 2, size.y - 20),
        ),
      );
      add(
        TextComponent(
          text: typeCost,
          textRenderer: MyTextStyle.uiButton,
          anchor: Anchor.center,
          position: Vector2(size.x / 2, size.y - 20),
        ),
      );
    }

    super.onMount();
  }

  @override
  void onTapDown(_) {
    if ((game.findByKeyName('level') as Level).money.hasEnoughMoney(buttonType.cost)) {
      ref.read(activeUIButtonControllerProvider.notifier).gotTapped(buttonType);
    }
    super.onTapDown(_);
  }

  Sprite getButtonSprite(bool isForButtonDown) {
    if (isActive) {
      if (buttonType == ButtonType.trash) {
        return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedRed.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonRed.path));
      } else {
        return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedGreen.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonGreen.path));
      }
    } else {
      return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedWhite.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonWhite.path));
    }
  }
}
