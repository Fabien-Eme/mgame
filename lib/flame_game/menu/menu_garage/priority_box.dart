import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/waste/waste.dart';

import '../../../gen/assets.gen.dart';
import '../../truck/truck.dart';

class PriorityBox extends PositionComponent with HasGameReference<MGame>, HasWorldReference, RiverpodComponentMixin, TapCallbacks, HoverCallbacks {
  final Truck truck;
  final WasteType wasteType;
  PriorityBox({required this.truck, required this.wasteType, required super.position});

  late final SpriteComponent spriteComponent;
  late final TextComponent textComponent;
  late Sprite sprite;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedGreen.path));

    size = Vector2(40, 40);
    anchor = Anchor.center;

    spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()..filterQuality = FilterQuality.low,
    );

    updateSprite();

    textComponent = TextComponent(
      text: truck.mapWastePriorities[wasteType].toString(),
      textRenderer: MyTextStyle.textBold,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(spriteComponent);
    add(textComponent);
    return super.onLoad();
  }

  void updateSprite() {
    if (truck.mapWastePriorities[wasteType]! > 0) {
      sprite = Sprite(game.images.fromCache(Assets.images.ui.priorityBox.priorityBoxGreen.path));
    } else {
      sprite = Sprite(game.images.fromCache(Assets.images.ui.priorityBox.priorityBoxRed.path));
    }

    spriteComponent.sprite = sprite;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (truck.mapWastePriorities[wasteType] == 4) {
      truck.mapWastePriorities[wasteType] = 0;
      truck.currentTask = null;
      truck.stopMovement();
    } else {
      truck.mapWastePriorities[wasteType] = truck.mapWastePriorities[wasteType]! + 1;
      truck.currentTask = null;
      truck.stopMovement();
    }

    textComponent.text = truck.mapWastePriorities[wasteType].toString();
    updateSprite();
    super.onTapDown(event);
  }

  @override
  void onHoverEnter() {
    game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}
