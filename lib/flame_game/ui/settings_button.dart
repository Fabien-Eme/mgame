import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mgame/flame_game/game.dart';

import '../../gen/assets.gen.dart';

class SettingsButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, HoverCallbacks {
  SettingsButton({super.position});
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topRight;
    priority = 400;
    size = Vector2.all(50);
    //position = Vector2(MGame.gameWidth - 20, 15);

    sprite = Sprite(game.images.fromCache(Assets.images.ui.settings.path));

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.audioController.playClickButton();
    game.router.pushNamed('menuSettings');
    super.onTapDown(event);
  }

  @override
  void onHoverEnter() {
    game.isMouseHoveringUI = true;
    game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.isMouseHoveringUI = false;
    game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}
