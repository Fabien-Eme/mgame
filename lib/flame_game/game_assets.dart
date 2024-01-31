import 'package:flame/extensions.dart';
import 'package:mgame/flame_game/game.dart';

import '../gen/assets.gen.dart';

extension MGameAssets on MGame {
  List<Future<Image> Function()> preLoadAssets() {
    return [
      () => images.load(Assets.images.tiles.roadNE.path),
      () => images.load(Assets.images.tiles.roadSE.path),
      () => images.load(Assets.images.tiles.roadSN.path),
      () => images.load(Assets.images.tiles.roadSW.path),
      () => images.load(Assets.images.tiles.roadWE.path),
      () => images.load(Assets.images.tiles.roadWN.path),
      () => images.load(Assets.images.tiles.grass.path),
      () => images.load(Assets.images.tiles.cursor.path),
      () => images.load(Assets.images.ui.uiButton.path),
      () => images.load(Assets.images.ui.uiButtonPressed.path),
      () => images.load(Assets.images.ui.uiRoad.path),
      () => images.load(Assets.images.ui.cursor.path),
      () => images.load(Assets.images.ui.uiTrash.path),
    ];
  }
}
