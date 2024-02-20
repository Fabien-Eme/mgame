import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';

class CloseButton extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, RiverpodComponentMixin {
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
    ref.read(overlayControllerProvider.notifier).overlayClose();
  }
}
