import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../gen/assets.gen.dart';
import 'game.dart';

class Tile extends SpriteComponent with HasGameRef<MGame> {
  Tile({required this.tileType, required super.position, super.size});

  TileType tileType;
  ColorEffect? colorEffect;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    return super.onLoad();
  }

  void highlight() {
    paint.colorFilter = const ColorFilter.mode(Color.fromARGB(100, 255, 255, 255), BlendMode.srcATop);
  }

  void removeHighlight() {
    paint.colorFilter = null;
  }

  void changeTileTo(TileType tileType) {
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint.colorFilter ??= const ColorFilter.mode(Color.fromARGB(98, 0, 255, 38), BlendMode.srcATop);
  }

  void resetTile() {
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint.colorFilter = null;
  }
}

enum TileType {
  roadNE,
  roadSE,
  roadSN,
  roadSW,
  roadWE,
  roadWN,
  grass;

  String get path {
    return switch (this) {
      TileType.roadNE => Assets.images.tiles.roadNE.path,
      TileType.roadSE => Assets.images.tiles.roadSE.path,
      TileType.roadSN => Assets.images.tiles.roadSN.path,
      TileType.roadSW => Assets.images.tiles.roadSW.path,
      TileType.roadWE => Assets.images.tiles.roadWE.path,
      TileType.roadWN => Assets.images.tiles.roadWN.path,
      TileType.grass => Assets.images.tiles.grass.path,
    };
  }
}
