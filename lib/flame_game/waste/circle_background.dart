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
    circleComponent = CircleComponent(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()..color = Palette.white,
    );
    add(circleComponent);
    decorator.addLast(PaintDecorator.blur(3));

    return super.onLoad();
  }
}
