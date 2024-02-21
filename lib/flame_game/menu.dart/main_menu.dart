import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';

import '../game.dart';
import '../riverpod_controllers/overlay_controller.dart';
import '../ui/overlay/overlay_dialog.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  MainMenu({super.position});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    add(DialogButton(
      text: 'Play',
      onPressed: () => game.gameController.startGame(),
      buttonSize: Vector2(150, 50),
      position: Vector2(0, 0),
    ));
    add(DialogButton(
      text: 'Settings',
      onPressed: () => ref.read(overlayControllerProvider.notifier).overlayOpen(overlayDialogType: OverlayDialogType.settings),
      buttonSize: Vector2(150, 50),
      position: Vector2(0, 100),
    ));

    return super.onLoad();
  }
}
