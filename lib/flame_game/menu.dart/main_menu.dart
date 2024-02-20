import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame> {
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

    return super.onLoad();
  }
}
