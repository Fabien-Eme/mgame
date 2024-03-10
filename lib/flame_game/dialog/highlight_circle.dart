import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/game.dart';

import '../utils/palette.dart';

class HighlightCircle extends Component with HasGameReference<MGame> {
  Vector2 position;
  double radius;
  HighlightCircle({required this.position, required this.radius, super.priority});

  Path combinedPath = Path();

  @override
  FutureOr<void> onLoad() {
    combinedPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(const Rect.fromLTWH(0, 0, MGame.gameWidth, MGame.gameHeight)),
      Path()..addOval(Rect.fromCircle(center: Offset(position.x, position.y), radius: radius)),
    );
    combinedPath.fillType = PathFillType.evenOdd;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(
      combinedPath,
      Paint()..color = Palette.blackAlmostOpaque,
    );
    super.render(canvas);
  }
}
