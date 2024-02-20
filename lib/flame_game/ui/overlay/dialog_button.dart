import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/events.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../../gen/assets.gen.dart';

class DialogButton extends PositionComponent with HasGameReference, TapCallbacks {
  String text;
  void Function() onPressed;
  Vector2 buttonSize;
  TextPaint? textStyle;
  DialogButton({required this.text, required this.onPressed, required this.buttonSize, this.textStyle, super.position});

  late NineTileBoxComponent button;
  late NineTileBoxComponent buttonDown;

  @override
  void onLoad() {
    anchor = Anchor.center;
    size = buttonSize;
    button = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.completeElevated.path)), tileSize: 50, destTileSize: 50),
      size: buttonSize,
      priority: 2,
    );
    buttonDown = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)), tileSize: 50, destTileSize: 50),
      size: buttonSize,
      priority: 1,
    );

    TextBoxComponent textComponent = TextBoxComponent(
      text: text.toUpperCase(),
      textRenderer: textStyle ?? MyTextStyle.button,
      priority: 3,
      align: Anchor.center,
      size: buttonSize,
    );

    addAll([
      button,
      buttonDown,
      textComponent,
    ]);
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed.call();
    button.priority = 1;
    buttonDown.priority = 2;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    button.priority = 2;
    buttonDown.priority = 1;
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    button.priority = 2;
    buttonDown.priority = 1;
    super.onTapCancel(event);
  }
}
