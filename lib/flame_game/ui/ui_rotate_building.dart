import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:mgame/flame_game/game.dart';

import '../../gen/assets.gen.dart';
import '../level.dart';

class UIRotateBuilding extends PositionComponent with HasGameRef<MGame>, HoverCallbacks {
  @override
  Future<void> onLoad() async {
    priority = 500;
    size = Vector2(100, 100);
    position = Vector2(500, MGame.gameHeight - size.y);

    addAll([
      UIRotateBuildingButton(size: Vector2(81, 75), position: Vector2(12.5, 12.5)),
    ]);
    super.onLoad();
  }

  @override
  void onHoverEnter() {
    game.isMouseHoveringUI = true;
    game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.isMouseHoveringUI = false;
    game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}

class UIRotateBuildingButton extends SpriteComponent with HasGameRef<MGame>, TapCallbacks {
  UIRotateBuildingButton({required super.size, super.position});

  @override
  void onMount() async {
    sprite = Sprite(game.images.fromCache(Assets.images.ui.rotateBuilding.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    (game.findByKeyName('level') as Level).levelWorld.tapController.onTertiaryTapDown();
    super.onTapDown(event);
  }
}

enum RotateDirection { left, right }
