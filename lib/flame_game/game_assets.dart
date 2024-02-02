import 'package:flame/extensions.dart';
import 'package:mgame/flame_game/game.dart';

import '../gen/assets.gen.dart';

extension MGameAssets on MGame {
  List<Future<Image> Function()> preLoadAssets() {
    return [
      ///
      /// TILES
      () => images.load(Assets.images.tiles.roadNE.path),
      () => images.load(Assets.images.tiles.roadSE.path),
      () => images.load(Assets.images.tiles.roadSN.path),
      () => images.load(Assets.images.tiles.roadSW.path),
      () => images.load(Assets.images.tiles.roadWE.path),
      () => images.load(Assets.images.tiles.roadWN.path),
      () => images.load(Assets.images.tiles.grass.path),
      () => images.load(Assets.images.tiles.cursor.path),

      ///
      /// UI
      () => images.load(Assets.images.ui.uiButtonWhite.path),
      () => images.load(Assets.images.ui.uiButtonPressedWhite.path),
      () => images.load(Assets.images.ui.uiButtonGreen.path),
      () => images.load(Assets.images.ui.uiButtonPressedGreen.path),
      () => images.load(Assets.images.ui.uiButtonRed.path),
      () => images.load(Assets.images.ui.uiButtonPressedRed.path),
      () => images.load(Assets.images.ui.uiRoadSN.path),
      () => images.load(Assets.images.ui.uiRoadWE.path),
      () => images.load(Assets.images.ui.cursor.path),
      () => images.load(Assets.images.ui.cursorAdd.path),
      () => images.load(Assets.images.ui.cursorTrash.path),
      () => images.load(Assets.images.ui.uiTrash.path),

      ///
      /// TRUCK
      () => images.load(Assets.images.truckBR.path),
      () => images.load(Assets.images.truckTL.path),
    ];
  }
}
