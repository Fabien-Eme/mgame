import 'package:flame/extensions.dart';
import 'package:mgame/flame_game/game.dart';

import '../../gen/assets.gen.dart';

extension MGameAssets on MGame {
  List<Future<Image> Function()> preLoadAssets() {
    return [
      ///
      /// TILES
      () => images.load(Assets.images.tiles.road.path),
      () => images.load(Assets.images.tiles.roadS.path),
      () => images.load(Assets.images.tiles.roadW.path),
      () => images.load(Assets.images.tiles.roadN.path),
      () => images.load(Assets.images.tiles.roadE.path),
      () => images.load(Assets.images.tiles.roadNE.path),
      () => images.load(Assets.images.tiles.roadSE.path),
      () => images.load(Assets.images.tiles.roadSN.path),
      () => images.load(Assets.images.tiles.roadSW.path),
      () => images.load(Assets.images.tiles.roadWE.path),
      () => images.load(Assets.images.tiles.roadWN.path),
      () => images.load(Assets.images.tiles.roadESW.path),
      () => images.load(Assets.images.tiles.roadNES.path),
      () => images.load(Assets.images.tiles.roadSWN.path),
      () => images.load(Assets.images.tiles.roadWNE.path),
      () => images.load(Assets.images.tiles.roadSWNE.path),
      () => images.load(Assets.images.tiles.grass.path),

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

      () => images.load(Assets.images.ui.mouseCursor.path),
      () => images.load(Assets.images.ui.mouseCursorAdd.path),
      () => images.load(Assets.images.ui.mouseCursorTrash.path),
      () => images.load(Assets.images.ui.mouseCursorHand.path),

      () => images.load(Assets.images.ui.tileCursor.path),
      () => images.load(Assets.images.ui.tileCursorBackground.path),

      () => images.load(Assets.images.ui.uiTrash.path),
      () => images.load(Assets.images.ui.uiGarbageLoader.path),
      () => images.load(Assets.images.ui.uiRecycler.path),
      () => images.load(Assets.images.ui.uiIncinerator.path),

      () => images.load(Assets.images.ui.rotateLEFT.path),
      () => images.load(Assets.images.ui.rotateRIGHT.path),

      ///
      /// TRUCK
      () => images.load(Assets.images.truckBR.path),
      () => images.load(Assets.images.truckTL.path),

      ///
      /// BUILDINGS
      () => images.load(Assets.images.buildings.garbageConveyor.garbageConveyorBack.path),
      () => images.load(Assets.images.buildings.garbageConveyor.garbageConveyorFront.path),

      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderEINSpritesheet.path),
      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderEOUTSpritesheet.path),
      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderSINSpritesheet.path),
      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderSOUTSpritesheet.path),
      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderEBack.path),
      () => images.load(Assets.images.buildings.garbageLoader.garbageLoaderSBack.path),

      () => images.load(Assets.images.buildings.recycler.recyclerEFront.path),
      () => images.load(Assets.images.buildings.recycler.recyclerEBack.path),
      () => images.load(Assets.images.buildings.recycler.recyclerSFront.path),
      () => images.load(Assets.images.buildings.recycler.recyclerSBack.path),

      () => images.load(Assets.images.buildings.incinerator.incineratorEFront.path),
      () => images.load(Assets.images.buildings.incinerator.incineratorEBack.path),
      () => images.load(Assets.images.buildings.incinerator.incineratorSFront.path),
      () => images.load(Assets.images.buildings.incinerator.incineratorSBack.path),
      () => images.load(Assets.images.buildings.incinerator.incineratorWFront.path),
      () => images.load(Assets.images.buildings.incinerator.incineratorNFront.path),
      () => images.load(Assets.images.buildings.incinerator.doorESpritesheet.path),
      () => images.load(Assets.images.buildings.incinerator.doorSSpritesheet.path),

      () => images.load(Assets.images.buildings.garage.garageEFront.path),
      () => images.load(Assets.images.buildings.garage.garageEBack.path),
      () => images.load(Assets.images.buildings.garage.garageEDoorSpritesheet.path),
      () => images.load(Assets.images.buildings.garage.garageSFront.path),
      () => images.load(Assets.images.buildings.garage.garageSBack.path),
      () => images.load(Assets.images.buildings.garage.garageSDoorSpritesheet.path),
      () => images.load(Assets.images.buildings.garage.garageWFront.path),
      () => images.load(Assets.images.buildings.garage.garageNFront.path),

      () => images.load(Assets.images.buildings.beltSN.path),
      () => images.load(Assets.images.buildings.beltWE.path),

      ///
      /// UTILS
      () => images.load(Assets.images.buildings.empty.path),
    ];
  }
}
