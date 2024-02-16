import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/riverpod_controllers/rotation_controller.dart';

import '../../gen/assets.gen.dart';

class UIRotate extends PositionComponent with HasGameRef<MGame>, RiverpodComponentMixin {
  @override
  Future<void> onLoad() async {
    priority = 500;
    size = Vector2(200, 100);
    position = Vector2(MGame.gameWidth - size.x, MGame.gameHeight - size.y);
    super.onLoad();
  }

  @override
  void onMount() {
    addAll([
      UIRotateButton(rotateDirection: RotateDirection.left, size: Vector2.all(75), position: Vector2(100 * 0 + 12.5, 0 + 12.5)),
      UIRotateButton(rotateDirection: RotateDirection.right, size: Vector2.all(75), position: Vector2(100 * 1 + 12.5, 0 + 12.5)),
    ]);
    super.onMount();
  }

  // @override
  // void onHoverEnter() {
  //   game.isMouseHoveringUI = true;
  //   super.onHoverEnter();
  // }

  // @override
  // void onHoverExit() {
  //   game.isMouseHoveringUI = false;
  //   super.onHoverExit();
  // }
}

class UIRotateButton extends SpriteComponent with HasGameReference, RiverpodComponentMixin, TapCallbacks {
  RotateDirection rotateDirection;
  UIRotateButton({required this.rotateDirection, required super.size, super.position});

  @override
  void onMount() async {
    sprite = (rotateDirection == RotateDirection.left) ? Sprite(game.images.fromCache(Assets.images.ui.rotateLEFT.path)) : Sprite(game.images.fromCache(Assets.images.ui.rotateRIGHT.path));
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    ref.read(rotationControllerProvider.notifier).rotate(rotateDirection);
    super.onTapDown(event);
  }
}

enum RotateDirection { left, right }
