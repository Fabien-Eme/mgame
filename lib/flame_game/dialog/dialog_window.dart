import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/dialog/avatar.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../../gen/assets.gen.dart';
import 'dialog_bdd.dart';
import 'dots.dart';

class DialogWindow extends PositionComponent with HasGameReference<MGame> {
  List<String> dialogTextFromBDD;
  void Function()? callback;

  DialogWindow({required this.dialogTextFromBDD, this.callback, super.priority})
      : super(
          key: ComponentKey.named('dialogWindow'),
        );

  late final Avatar avatar;
  late TextBoxComponent textBoxComponent;
  late final Dots dots;

  List<String> dialogText = [];
  List<Vector2> dialogPositions = [];

  @override
  FutureOr<void> onLoad() {
    dialogText.addAll(dialogTextFromBDD);
    if (dialogTextFromBDD == DialogBDD.tutorial) dialogPositions.addAll(DialogBDD.tutorialAvatarPositions);

    size = Vector2(500, 220);
    position = (dialogPositions.isEmpty) ? Vector2(625, 250) : dialogPositions.first;
    scale = Vector2.all(1.5);

    dots = Dots()..position = Vector2(size.x - 35, size.y - 15);

    add(avatar = Avatar(position: Vector2(20, 0)));

    add(
      NineTileBoxComponent(
        nineTileBox: NineTileBox(
          Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)),
          tileSize: 50,
          destTileSize: 50,
        ),
        anchor: Anchor.topLeft,
        size: size - Vector2(0, 100),
        position: Vector2(0, 100),
      ),
    );
    add(
      textBoxComponent = TextBoxComponent(
        text: dialogText.first,
        textRenderer: MyTextStyle.text,
        size: size,
        position: Vector2(0, 100),
        boxConfig: TextBoxConfig(
          maxWidth: 500,
          margins: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          timePerChar: 0.03,
        ),
      ),
    );

    return super.onLoad();
  }

  void advanceDialog() {
    if (textBoxComponent.finished) {
      if (dialogText.length > 1) {
        dialogText.removeAt(0);
        updateTextBox();

        if (dialogTextFromBDD == DialogBDD.tutorial) {
          dialogPositions.removeAt(0);
          position = dialogPositions.first;
        }
      }
      callback?.call();
    }
  }

  void updateTextBox() async {
    remove(textBoxComponent);
    await textBoxComponent.removed;
    textBoxComponent = TextBoxComponent(
      text: dialogText.first,
      textRenderer: MyTextStyle.text,
      size: size,
      position: Vector2(0, 100),
      boxConfig: TextBoxConfig(
        maxWidth: 500,
        margins: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        timePerChar: 0.03,
      ),
    );
    add(textBoxComponent);
  }

  @override
  void update(double dt) {
    if (!textBoxComponent.finished) {
      avatar.talk();
      if (dots.isMounted) remove(dots);
    } else {
      avatar.stopTalking();
      if (!dots.isMounted) add(dots);
    }
    super.update(dt);
  }
}
