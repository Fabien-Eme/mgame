import 'dart:async';

import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class Truck extends SpriteComponent with HasGameReference<MGame> {
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(Assets.images.trucks.truckY0.path));
    position = Vector2(200, 200);
    return super.onLoad();
  }
}
