import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:mgame/flame_game/dialog/highlight_circle.dart';

import 'package:mgame/flame_game/game.dart';
import 'package:mgame/flame_game/level.dart';

import '../buildings/building.dart';
import '../tile/tile_helper.dart';
import '../utils/convert_rotations.dart';
import 'dialog_bdd.dart';
import 'dialog_window.dart';

class Tutorial extends Component with HasGameReference<MGame> {
  late final World world;
  late final CameraComponent cameraComponent;
  late HighlightCircle highlightCircle;

  List<Vector2> dialogHighlightPositions = [];
  List<double> dialogHighlightRadius = [];

  @override
  void onLoad() {
    dialogHighlightPositions.addAll(DialogBDD.tutorialHighlightPositions);
    dialogHighlightRadius.addAll(DialogBDD.tutorialHighlightRadius);

    add(world = World());
    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
      viewfinder: Viewfinder()..anchor = Anchor.topLeft,
    ));

    world.add(highlightCircle = HighlightCircle(
      priority: 0,
      position: (dialogHighlightPositions.isEmpty) ? Vector2(0, 0) : dialogHighlightPositions.first,
      radius: (dialogHighlightRadius.isEmpty) ? 0 : dialogHighlightRadius.first,
    ));

    world.add(
      DialogWindow(
        priority: 1,
        dialogTextFromBDD: DialogBDD.tutorial,
        callback: advanceDialog,
      ),
    );

    game.router.previousRoute?.stopTime();
  }

  Future<void> advanceDialog() async {
    if (dialogHighlightPositions.length > 1) {
      dialogHighlightPositions.removeAt(0);
      dialogHighlightRadius.removeAt(0);

      world.remove(highlightCircle);
      world.add(highlightCircle = HighlightCircle(
        priority: 0,
        position: (dialogHighlightPositions.isEmpty) ? Vector2(0, 0) : dialogHighlightPositions.first,
        radius: (dialogHighlightRadius.isEmpty) ? 0 : dialogHighlightRadius.first,
      ));

      if (dialogHighlightPositions.length == 8) {
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          game.router.previousRoute?.resumeTime();
          (game.findByKeyName('level') as Level?)?.levelWorld.gridController.internalBuildOnTile(const Point<int>(31, 2), BuildingType.garbageLoader, Directions.S);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((_) => game.router.previousRoute?.stopTime());
      }

      if (dialogHighlightPositions.length == 7) {
        game.router.previousRoute?.resumeTime();
        Future.delayed(const Duration(milliseconds: 6000)).then((_) => game.router.previousRoute?.stopTime());
        for (int i = 0; i < 25; i++) {
          (game.findByKeyName('level') as Level?)?.levelWorld.constructionController.construct(posDimetric: Point<int>(7 + i, -1), tileType: TileType.road);
          await Future.delayed(const Duration(milliseconds: 100));
        }
        (game.findByKeyName('level') as Level?)?.levelWorld.constructionController.construct(posDimetric: const Point<int>(31, 0), tileType: TileType.road);
        await Future.delayed(const Duration(milliseconds: 100));
        (game.findByKeyName('level') as Level?)?.levelWorld.constructionController.construct(posDimetric: const Point<int>(31, 1), tileType: TileType.road);
      }

      if (dialogHighlightPositions.length == 3) {
        game.router.previousRoute?.resumeTime();
        Future.delayed(const Duration(milliseconds: 2500)).then((_) => game.router.previousRoute?.stopTime());
        Future.delayed(const Duration(seconds: 1)).then((_) {
          (game.findByKeyName('level') as Level?)?.levelWorld.gridController.internalBuildOnTile(const Point<int>(22, 2), BuildingType.incinerator, Directions.S);
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        (game.findByKeyName('level') as Level?)?.levelWorld.constructionController.construct(posDimetric: const Point<int>(21, 0), tileType: TileType.road);
        await Future.delayed(const Duration(milliseconds: 100));
        (game.findByKeyName('level') as Level?)?.levelWorld.constructionController.construct(posDimetric: const Point<int>(21, 1), tileType: TileType.road);
      }
    } else {
      game.router.pop();
    }
  }
}
