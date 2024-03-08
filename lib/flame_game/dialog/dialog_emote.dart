import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class DialogEmote extends PositionComponent with HasGameReference<MGame> {
  DialogEmote({super.position});

  SpriteComponent? spriteComponent;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(32);
    return super.onLoad();
  }

  void showEmote(EmoteType emoteType) {
    spriteComponent = SpriteComponent(
      sprite: Sprite(game.images.fromCache(emoteType.image)),
      anchor: Anchor.bottomCenter,
      size: size,
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.zero(),
    );
    add(spriteComponent!);
  }

  bool animationStarted = false;
  bool animationScaleUpFinished = false;
  bool animationFinished = false;
  double timeElapsedSinceFinished = 0;

  @override
  void update(double dt) {
    if (spriteComponent != null) {
      if (!animationStarted && !animationFinished && !animationScaleUpFinished) {
        spriteComponent!.scale += Vector2.all(dt * 10);
      }
      if (spriteComponent!.scale.x >= 1.7 && !animationScaleUpFinished) {
        animationScaleUpFinished = true;
      }
      if (animationScaleUpFinished) {
        spriteComponent!.scale -= Vector2.all(dt * 10);
      }
      if (animationScaleUpFinished && spriteComponent!.scale.x <= 1) {
        spriteComponent!.scale = Vector2.all(1);
        animationStarted = false;
        animationFinished = true;
      }
      if (animationFinished) {
        timeElapsedSinceFinished += dt;
        if (timeElapsedSinceFinished >= 2) {
          animationFinished = false;
          remove(spriteComponent!);
          spriteComponent = null;
        }
      }
    }
    super.update(dt);
  }
}

enum EmoteType {
  exclamation;

  String get image {
    switch (this) {
      case EmoteType.exclamation:
        return Assets.images.emote.emoteExclamation.path;
    }
  }
}
