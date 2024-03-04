import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';

import '../game.dart';
import '../riverpod_controllers/overlay_controller.dart';
import '../ui/overlay/overlay_dialog.dart';
import 'menu_settings.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  late final DialogButton playButton;
  late final DialogButton settingsButton;
  late final DialogButton achievementsButton;

  @override
  FutureOr<void> onLoad() {
    add(world = World());

    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      viewfinder: Viewfinder(),
      world: world,
    ));

    world.addAll([
      playButton = DialogButton(
        text: 'Play',
        buttonSize: Vector2(100, 50),
        onPressed: () {
          game.router.pushNamed('level1');
        },
        position: Vector2(0, -50),
      ),
      settingsButton = DialogButton(
        text: 'Settings',
        onPressed: () {
          game.router.pushRoute(MenuSettingsRoute());
        },
        buttonSize: Vector2(150, 50),
        position: Vector2(0, 50),
      ),
      achievementsButton = DialogButton(
        text: 'Achievements',
        onPressed: () => ref.read(overlayControllerProvider.notifier).overlayOpen(overlayDialogType: OverlayDialogType.achievements),
        buttonSize: Vector2(225, 50),
        position: Vector2(0, 150),
      ),
    ]);
    return super.onLoad();
  }
}
