import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class TopDrawer extends SpriteComponent with HasGameReference<MGame> {
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topCenter;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.topDrawer.path));
    position = Vector2(MGame.gameWidth / 2, -1);
    size = Vector2(1400, 70);
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}
