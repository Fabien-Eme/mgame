import 'package:flame/components.dart';
import 'package:mgame/flame_game/game.dart';

import 'ui_bottom_bar_button.dart';

class UIBottomBar extends PositionComponent with HasGameRef<MGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2.all(100);
    position = Vector2(0, MGame.gameHeight - size.y);
    super.onLoad();
  }

  @override
  void onMount() {
    addAll([
      UIBottomBarButton(buttonType: ButtonType.trash, size: size, position: Vector2(100 * 0, 0)),
      UIBottomBarButton(buttonType: ButtonType.road, size: size, position: Vector2(100 * 1, 0)),
    ]);
    super.onMount();
  }
}
