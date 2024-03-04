import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../../gen/assets.gen.dart';

class SliderComponent extends PositionComponent with HasGameReference {
  int numberOfSteps;
  void Function(double) callback;
  double initialValue;

  SliderComponent({required this.numberOfSteps, required this.callback, required this.initialValue, super.position});

  late SelectorCursor selector;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2(28 + 36 + 49 * (numberOfSteps - 2), 16);

    final sliderStart = StepNode(sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeStart.path)), position: Vector2(0, 0), onPressed: () => onNodePressed(0));

    final sliderFirstBar = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddleBar.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      position: Vector2(14, 3),
    );
    final sliderEnd =
        StepNode(sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeEnd.path)), position: Vector2(size.x - 14, 0), onPressed: () => onNodePressed(numberOfSteps - 1));

    List<SpriteComponent> listSliderMiddle = [];
    for (int i = 0; i < numberOfSteps - 2; i++) {
      listSliderMiddle
          .add(StepNode(sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddlePoint.path)), position: Vector2(50 + i * 49, 0), onPressed: () => onNodePressed(i + 1)));

      listSliderMiddle.add(SpriteComponent(
        sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddleBar.path)),
        paint: Paint()..filterQuality = FilterQuality.low,
        position: Vector2(63 + i * 49, 3),
      ));
    }

    addAll([
      sliderStart,
      sliderFirstBar,
      ...listSliderMiddle,
      sliderEnd,
      selector = SelectorCursor(),
    ]);

    selector.position = Vector2(-7 + initialValue * 4 * 49, -30);

    return super.onLoad();
  }

  void onNodePressed(int index) {
    selector.position = Vector2(-7 + index * 49, -30);
    callback.call(index.toDouble() / (numberOfSteps - 1));
  }

  void changeSelectorPosition(double x) {
    selector.position.x += x;
    if (selector.position.x <= -7 && x < 0) {
      selector.position.x = -7;
    }

    if (selector.position.x >= -7 + (numberOfSteps - 1) * 49 && x > 0) {
      selector.position.x = -7 + (numberOfSteps - 1) * 49;
    }
    callback.call((selector.position.x + 7) / ((numberOfSteps - 1) * 49));
  }
}

class StepNode extends SpriteComponent with TapCallbacks {
  void Function() onPressed;
  StepNode({required super.sprite, required super.position, required this.onPressed});

  @override
  FutureOr<void> onLoad() {
    paint = Paint()..filterQuality = FilterQuality.low;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed.call();
    super.onTapDown(event);
  }
}

class SelectorCursor extends SpriteComponent with HasGameReference {
  SelectorCursor({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorCursor.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    scale = Vector2.all(0.8);
    return super.onLoad();
  }
}
