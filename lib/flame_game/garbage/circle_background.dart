import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

import '../utils/palette.dart';

class CircleBackground extends PositionComponent {
  double radius;
  CircleBackground({required this.radius});
  late final CircleComponent circleComponent;

  @override
  FutureOr<void> onLoad() {
    priority = 159;
    circleComponent = CircleComponent(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()..color = Palette.white,
    );
    add(circleComponent);
    decorator.addLast(PaintDecorator.blur(5));

    return super.onLoad();
  }
}
