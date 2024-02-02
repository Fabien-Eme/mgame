import 'dart:async';

import 'package:flame/components.dart';

import '../gen/assets.gen.dart';

class Truck extends SpriteComponent with HasGameRef {
  Truck({super.position, required this.asset});

  String asset;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(asset));
    scale = Vector2.all(0.8);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (asset == Assets.images.truckBR.path) {
      position.x += 0.4;
      position.y += 0.2;
    } else if (asset == Assets.images.truckTL.path) {
      position.x -= 0.4;
      position.y -= 0.2;
    }

    super.update(dt);
  }
}
