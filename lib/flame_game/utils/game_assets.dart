import 'package:flame/extensions.dart';
import 'package:mgame/flame_game/game.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../gen/assets.gen.dart';

extension MGameAssets on MGame {
  List<Future<Image> Function()> preLoadAssetsImages() {
    return [
      ///
      /// TILES
      for (AssetGenImage element in Assets.images.tiles.values) () => images.load(element.path),

      ///
      /// UI
      for (AssetGenImage element in Assets.images.ui.values) () => images.load(element.path),

      ///
      /// DIALOG
      for (AssetGenImage element in Assets.images.ui.dialog.values) () => images.load(element.path),

      ///
      /// TRUCK
      for (AssetGenImage element in Assets.images.trucks.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.trucks.stacked.values) () => images.load(element.path),

      ///
      /// BUILDINGS
      for (AssetGenImage element in Assets.images.buildings.garbageConveyor.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.garbageLoader.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.recycler.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.incinerator.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.garage.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.values) () => images.load(element.path),

      ///
      /// UTILS
      () => images.load(Assets.images.buildings.empty.path),
    ];
  }

  Future<void> preLoadAudio() async {
    FlameAudio.updatePrefix('');
    for (String element in Assets.music.values) {
      () => FlameAudio.audioCache.load(element);
    }
    for (String element in Assets.sfx.values) {
      () => FlameAudio.audioCache.load(element);
    }
  }
}
