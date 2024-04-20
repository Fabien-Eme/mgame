import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/utils/palette.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class DialogLevelButton extends PositionComponent with HasGameReference<MGame>, TapCallbacks, HoverCallbacks {
  String level;
  String title;
  bool isCompleted;
  bool isAvailable;
  int score;
  Vector2 buttonSize;
  void Function() onPressed;

  DialogLevelButton({
    required this.level,
    required this.title,
    required this.isCompleted,
    required this.isAvailable,
    required this.score,
    required this.onPressed,
    super.position,
  }) : buttonSize = Vector2(150, 150);

  late NineTileBoxComponent button;
  late NineTileBoxComponent buttonDown;
  late TextBoxComponent titleTextComponent;
  late TextBoxComponent levelTextComponent;

  @override
  void onLoad() {
    anchor = Anchor.center;
    size = buttonSize;
    button = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.completeElevated.path)), tileSize: 50, destTileSize: 50),
      size: buttonSize,
      priority: (isAvailable) ? 2 : 1,
    );
    buttonDown = NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)), tileSize: 50, destTileSize: 50),
      size: buttonSize,
      priority: (isAvailable) ? 1 : 2,
    );

    titleTextComponent = TextBoxComponent(
      text: title,
      textRenderer: MyTextStyle.buttonLevelTitle,
      priority: 3,
      align: Anchor.center,
      size: Vector2(buttonSize.x, 60),
      position: Vector2(0, 0),
    );

    levelTextComponent = TextBoxComponent(
      text: level,
      textRenderer: MyTextStyle.buttonLevelNumber,
      priority: 3,
      align: Anchor.center,
      size: buttonSize,
    );

    addAll([
      button,
      buttonDown,
      titleTextComponent,
      levelTextComponent,
    ]);

    final Sprite starFullSprite = Sprite(game.images.fromCache(Assets.images.ui.starFull.path));
    final Sprite starEmptySprite = Sprite(game.images.fromCache(Assets.images.ui.starEmpty.path));

    add(SpriteComponent(
      sprite: (score >= 1) ? starFullSprite : starEmptySprite,
      anchor: Anchor.center,
      position: Vector2(40, 120),
      size: Vector2(30, 30),
      paint: Paint()..filterQuality = FilterQuality.low,
      priority: 10,
    ));
    add(SpriteComponent(
      sprite: (score >= 2) ? starFullSprite : starEmptySprite,
      anchor: Anchor.center,
      position: Vector2(75, 120),
      size: Vector2(30, 30),
      paint: Paint()..filterQuality = FilterQuality.low,
      priority: 10,
    ));
    add(SpriteComponent(
      sprite: (score >= 3) ? starFullSprite : starEmptySprite,
      anchor: Anchor.center,
      position: Vector2(110, 120),
      size: Vector2(30, 30),
      paint: Paint()..filterQuality = FilterQuality.low,
      priority: 10,
    ));

    if (!isAvailable) {
      add(RectangleComponent.fromRect(const Rect.fromLTWH(0, 0, 150, 150))
        ..paint.color = Palette.blackTransparent
        ..priority = 10);
    }

    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isAvailable) {
      if (game.isWeb) {
        if (!game.hasAudioBeenActivatedOnWeb) {
          game.hasAudioBeenActivatedOnWeb = true;
          FlameAudio.bgm.play('Wallpaper.mp3').then((value) => FlameAudio.bgm.audioPlayer.setVolume(game.musicVolume));
        }
      }

      game.audioController.playClickButton();

      onPressed.call();
      button.priority = 1;
      buttonDown.priority = 2;
    }
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (isAvailable) {
      button.priority = 2;
      buttonDown.priority = 1;
    }
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    if (isAvailable) {
      button.priority = 2;
      buttonDown.priority = 1;
    }
    super.onTapCancel(event);
  }

  @override
  void onHoverEnter() {
    if (isAvailable) game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    if (isAvailable) game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}
