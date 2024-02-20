import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame> {
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    add(DialogButton(text: 'Play', onPressed: () => print('Start Game'), buttonSize: Vector2(150, 50)));

    return super.onLoad();
  }
}
