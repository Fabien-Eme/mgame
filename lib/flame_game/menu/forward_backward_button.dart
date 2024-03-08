import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class ForwardBackwardButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, HoverCallbacks {
  bool isForward;
  void Function() onPressed;
  bool isVertical;
  ForwardBackwardButton({required this.isForward, required this.onPressed, super.position, this.isVertical = false});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(32, 50);
    sprite = Sprite((isForward) ? game.images.fromCache(Assets.images.ui.dialog.forward.path) : game.images.fromCache(Assets.images.ui.dialog.backward.path));

    angle = (isVertical) ? pi / 2 : 0;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed.call();
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
