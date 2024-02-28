import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/game.dart';

import '../riverpod_controllers/ui_controller.dart';
import '../utils/palette.dart';
import 'ui_bottom_bar_button.dart';

class UIBottomBar extends PositionComponent with HasGameRef<MGame> {
  @override
  Future<void> onLoad() async {
    priority = 400;
    size = Vector2(400, 100);
    position = Vector2(0, MGame.gameHeight - size.y);
    super.onLoad();
  }

  @override
  void onMount() {
    add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(MGame.gameWidth - 225, 100),
      paint: Paint()..color = Palette.blackTransparent,
    ));

    addAll([
      UIBottomBarButton(buttonType: ButtonType.trash, size: Vector2.all(100), position: Vector2(100 * 0, 0)),
      UIBottomBarButton(buttonType: ButtonType.road, size: Vector2.all(100), position: Vector2(100 * 1, 0)),
      UIBottomBarButton(buttonType: ButtonType.garbageLoader, size: Vector2.all(100), position: Vector2(100 * 2, 0)),
      UIBottomBarButton(buttonType: ButtonType.incinerator, size: Vector2.all(100), position: Vector2(100 * 3, 0)),
    ]);
    super.onMount();
  }
}
