import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/events.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';

class DialogTab extends PositionComponent with HasGameReference, TapCallbacks {
  String tabTitle;
  void Function() onPressed;
  DialogTab({required this.tabTitle, required this.onPressed, super.position, super.priority});

  late NineTileBoxComponent tab;
  late NineTileBoxComponent tabSelected;

  @override
  void onLoad() {
    anchor = Anchor.center;
    final Vector2 tabSize = Vector2(150, 50);
    size = tabSize;
    tab = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)), tileSize: 50, destTileSize: 50),
      size: tabSize,
      priority: 2,
    );
    tabSelected = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.completeWhite.path)), tileSize: 50, destTileSize: 50),
      size: tabSize,
      priority: 1,
    );

    TextBoxComponent textComponent = TextBoxComponent(
      text: tabTitle.toUpperCase(),
      textRenderer: MyTextStyle.tab,
      priority: 3,
      align: Anchor.centerLeft,
      size: tabSize,
      position: Vector2(3, 0),
    );

    addAll([
      tab,
      tabSelected,
      textComponent,
    ]);
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed.call();
    super.onTapDown(event);
  }

  void deSelect() {
    tab.priority = 2;
    tabSelected.priority = 1;
  }

  void select() {
    tab.priority = 1;
    tabSelected.priority = 2;
  }
}
