import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class AddonToggleAcceptWaste extends PositionComponent with HasGameReference<MGame> {
  AddonToggleAcceptWaste({super.position});

  late final ToggleButton checkToggle;
  late final ToggleButton crossToggle;

  bool isCheckOn = true;
  bool isCrossOn = false;

  @override
  FutureOr<void> onLoad() {
    isCheckOn = game.currentlySelectedBuilding?.isAcceptingWaste ?? true;
    isCrossOn = !isCheckOn;

    add(
      NineTileBoxComponent(
        nineTileBox: NineTileBox(
          Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)),
          tileSize: 50,
          destTileSize: 50,
        ),
        size: Vector2(350, 75),
        anchor: Anchor.topCenter,
      ),
    );

    add(
      TextComponent(
        text: "Accept Waste ?",
        textRenderer: MyTextStyle.textBold,
        anchor: Anchor.centerLeft,
        position: Vector2(-150, 37.5),
      ),
    );

    add(checkToggle = ToggleButton(isCross: false, isOn: isCheckOn, position: Vector2(50, 37.5), callback: () => toggle(true)));
    add(crossToggle = ToggleButton(isCross: true, isOn: isCrossOn, position: Vector2(125, 37.5), callback: () => toggle(false)));

    return super.onLoad();
  }

  void toggle(bool isToggleFromCheck) {
    if ((isToggleFromCheck && !isCheckOn) || (!isToggleFromCheck && !isCrossOn)) {
      isCheckOn = !isCheckOn;
      isCrossOn = !isCrossOn;

      checkToggle.toggle(isCheckOn);
      crossToggle.toggle(isCrossOn);

      game.currentlySelectedBuilding?.changeWasteAcceptance(isCheckOn);
    }
  }
}

class ToggleButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, HoverCallbacks {
  bool isCross;
  bool isOn;
  Function() callback;

  ToggleButton({required this.isCross, required this.isOn, required this.callback, super.position});

  @override
  FutureOr<void> onLoad() {
    updateSprite();
    paint = Paint()..filterQuality = FilterQuality.low;
    anchor = Anchor.center;
    scale = Vector2(0.6, 0.6);

    return super.onLoad();
  }

  void toggle(bool onOff) {
    isOn = onOff;
    updateSprite();
  }

  void updateSprite() {
    if (isCross) {
      if (isOn) {
        sprite = Sprite(game.images.fromCache(Assets.images.ui.cross.path));
      } else {
        sprite = Sprite(game.images.fromCache(Assets.images.ui.crossGrey.path));
      }
    } else {
      if (isOn) {
        sprite = Sprite(game.images.fromCache(Assets.images.ui.checkmark.path));
      } else {
        sprite = Sprite(game.images.fromCache(Assets.images.ui.checkmarkGrey.path));
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    callback.call();
    super.onTapDown(event);
  }

  @override
  void onHoverEnter() {
    game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}
