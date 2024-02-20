import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';

class ForwardBackwardButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, RiverpodComponentMixin {
  bool isForward;
  void Function() onPressed;
  ForwardBackwardButton({required this.isForward, required this.onPressed, super.position});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(32, 50);
    sprite = Sprite((isForward) ? game.images.fromCache(Assets.images.ui.dialog.forward.path) : game.images.fromCache(Assets.images.ui.dialog.backward.path));
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed.call();
  }
}
