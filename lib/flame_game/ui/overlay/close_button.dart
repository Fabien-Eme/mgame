import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../mouse_cursor.dart';

class CloseButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks {
  CloseButton({super.position});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2.all(50);
    sprite = Sprite(game.images.fromCache(Assets.images.ui.dialog.close.path));
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.router.pop();
  }

  // @override
  // void onHoverEnter() {
  //   game.myMouseCursor.hoverEnterButton();
  //   super.onHoverEnter();
  // }

  // @override
  // void onHoverExit() {
  //   game.myMouseCursor.hoverExitButton();
  //   super.onHoverExit();
  // }
}
