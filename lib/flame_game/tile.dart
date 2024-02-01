import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';

import '../gen/assets.gen.dart';
import 'game.dart';

class Tile extends SpriteComponent with HasGameRef<MGame> {
  TileType tileType;
  Point<int> coordinates;
  bool isDebugMode;
  Tile({required this.tileType, required this.coordinates, required this.isDebugMode, required super.position, super.size});

  bool isConstructible = true;
  bool isDestructible = false;
  BuildingType? buildingType;
  ColorEffect? colorEffect;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(tileType.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    if (isDebugMode) add(TextBoxComponent(text: '[${coordinates.x}, ${coordinates.y}]', scale: Vector2.all(0.6), position: Vector2(25, 12)));
    return super.onLoad();
  }

  void determineRoadType() {
    ///
  }

  void highlight() {
    paint.colorFilter = const ColorFilter.mode(Color.fromARGB(100, 255, 255, 255), BlendMode.srcATop);
  }

  void removeHighlight() {
    paint.colorFilter = null;
  }

  void changeTileTo(BuildingType buildingType) {
    if (isConstructible) {
      sprite = Sprite(game.images.fromCache(TileType.values.firstWhere((element) => element.name == buildingType.name).path));
      paint.colorFilter = ColorFilter.mode((isConstructible) ? const Color.fromARGB(98, 0, 255, 38) : const Color.fromARGB(97, 250, 40, 40), BlendMode.srcATop);
    } else {
      highlight();
    }
  }

  void construct({required BuildingType buildingType, bool isMouseDragging = false}) {
    if (isConstructible) {
      buildingType = buildingType;
      tileType = TileType.values.firstWhere((element) => element.name == buildingType.name);
      sprite = Sprite(game.images.fromCache(tileType.path));
      isConstructible = false;
      isDestructible = true;
      if (!isMouseDragging) highlight();
    }
  }

  void changeTileToWantToDestroy() {
    if (!isConstructible && isDestructible) {
      paint.colorFilter = const ColorFilter.mode(Color.fromARGB(97, 250, 40, 40), BlendMode.srcATop);
    } else {
      highlight();
    }
  }

  void destroy({bool isMouseDragging = false}) {
    if (!isConstructible && isDestructible) {
      isConstructible = true;
      isDestructible = false;
      buildingType = null;
      tileType = TileType.grass;
      sprite = Sprite(game.images.fromCache(tileType.path));
      if (!isMouseDragging) highlight();
    }
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
