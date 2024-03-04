import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';

import '../game.dart';

class SubMenu extends Component with HasGameReference<MGame> {
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
        text: 'Back',
        buttonSize: Vector2(100, 50),
        onPressed: () => game.router.pop(),
        //onPressed: () => game.gameController.startGame(),
        position: Vector2(0, -50),
      ),
    ]);

    return super.onLoad();
  }
}
