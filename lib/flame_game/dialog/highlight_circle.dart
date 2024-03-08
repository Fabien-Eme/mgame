import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/game.dart';

import '../utils/palette.dart';

class HighlightCircle extends Component with HasGameReference<MGame> {
  Vector2 position;
  double radius;
  HighlightCircle({required this.position, required this.radius});

  Path combinedPath = Path();

  @override
  FutureOr<void> onLoad() {
    updatePath();
    return super.onLoad();
  }

  void updatePath() {
    combinedPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(const Rect.fromLTWH(0, 0, MGame.gameWidth, MGame.gameHeight)),
      Path()..addOval(Rect.fromCircle(center: Offset(position.x, position.y), radius: radius)),
    );
  }

  void updatePosition(Vector2 position) {
    position = position;
    updatePath();
  }

  void updateRadius(double radius) {
    radius = radius;
    updatePath();
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
