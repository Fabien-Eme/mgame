import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/dialog/dialog_emote.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class Avatar extends SpriteComponent with HasGameReference<MGame> {
  Avatar({super.position});

  final DialogEmote dialogEmote = DialogEmote();

  List<Sprite> listSprite = [];
  bool isTalking = false;
  bool isExclamation = false;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topLeft;
    size = Vector2(78, 102);

    dialogEmote.position = position + Vector2(size.x / 2, 0) - Vector2(19, 0);
    add(dialogEmote);

    listSprite.addAll([
      Sprite(game.images.fromCache(Assets.images.avatar.avatarMouthClose.path)),
      Sprite(game.images.fromCache(Assets.images.avatar.avatarMouthOpen.path)),
      Sprite(game.images.fromCache(Assets.images.avatar.avatarMouthWideOpen.path)),
    ]);
    sprite = listSprite[0];
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  void openCloseMouth() {
    if (sprite == listSprite[0]) {
      sprite = listSprite[1];
    } else {
      sprite = listSprite[0];
    }
  }

  void showEmote(EmoteType emoteType) {
    dialogEmote.showEmote(emoteType);
  }

  void talk() {
    isTalking = true;
  }

  void stopTalking() {
    isTalking = false;
    sprite = listSprite[0];
  }

  double delayOpenCloseMouth = 0.1;
  double timeElapsed = 0.0;

  @override
  void update(double dt) {
    if (isTalking) {
      timeElapsed += dt;
      if (timeElapsed >= delayOpenCloseMouth) {
        timeElapsed = 0.0;
        delayOpenCloseMouth = Random().nextDouble() * 0.2 + 0.05;
        openCloseMouth();
      }
    } else {
      timeElapsed = 0;
    }
    super.update(dt);
  }
}
