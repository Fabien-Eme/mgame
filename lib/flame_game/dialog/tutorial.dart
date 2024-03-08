import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:mgame/flame_game/dialog/highlight_circle.dart';

import 'package:mgame/flame_game/game.dart';

import 'dialog_bdd.dart';
import 'dialog_window.dart';

class Tutorial extends Component with HasGameReference<MGame> {
  late final World world;
  late final CameraComponent cameraComponent;
  late final HighlightCircle highlightCircle;

  @override
  void onLoad() {
    add(world = World());
    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
      viewfinder: Viewfinder()..anchor = Anchor.topLeft,
    ));

    world.add(highlightCircle = HighlightCircle(
      position: Vector2(250, 110),
      radius: 175,
    ));

    world.add(
      DialogWindow(
        dialogTextFromBDD: DialogBDD.tutorial,
      ),
    );

    game.router.previousRoute?.stopTime();
  }
}
