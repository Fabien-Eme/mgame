import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class MiniTopDrawer extends SpriteComponent with HasGameReference<MGame> {
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topCenter;
    sprite = Sprite(game.images.fromCache(Assets.images.ui.topDrawer.path));
    position = Vector2(MGame.gameWidth / 2, 65);
    size = Vector2(250, 50);
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }
}
