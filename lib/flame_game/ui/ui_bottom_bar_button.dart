import 'dart:ui';

import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../gen/assets.gen.dart';
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
    super.onMount();
  }

  @override
  void onTapDown(_) {
    ref.read(activeUIButtonControllerProvider.notifier).gotTapped(buttonType);

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
