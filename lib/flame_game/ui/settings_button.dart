import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game.dart';

import '../../gen/assets.gen.dart';
import '../riverpod_controllers/overlay_controller.dart';
import 'overlay/overlay_dialog.dart';

class SettingsButton extends SpriteComponent with HasGameReference<MGame>, RiverpodComponentMixin, TapCallbacks {
  SettingsButton({super.position});
  @override
  FutureOr<void> onLoad() {
    priority = 400;
    size = Vector2.all(50);
    position = Vector2(MGame.gameWidth - size.x - 20, 20);

    sprite = Sprite(game.images.fromCache(Assets.images.ui.settings.path));

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.audioController.playClickButton();
    ref.read(overlayControllerProvider.notifier).overlayOpen(overlayDialogType: OverlayDialogType.settings);
    super.onTapDown(event);
  }
}
