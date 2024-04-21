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
      for (AssetGenImage element in Assets.images.tiles.forest.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.tiles.arrows.values) () => images.load(element.path),

      ///
      /// UI
      for (AssetGenImage element in Assets.images.ui.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.ui.dialog.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.ui.priorityBox.values) () => images.load(element.path),

      ///
      /// TRUCK
      for (AssetGenImage element in Assets.images.trucks.values) () => images.load(element.path),
      for (AssetGenImage element in Assets.images.trucks.stacked.values) () => images.load(element.path),

      ///
      /// BUILDINGS
      for (AssetGenImage element in Assets.images.buildings.composter.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.buryer.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.city.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.garbageConveyor.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.garbageLoader.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.recycler.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.incinerator.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.garage.values) () => images.load(element.path),

      for (AssetGenImage element in Assets.images.buildings.values) () => images.load(element.path),

      ///
      /// WASTE
      for (AssetGenImage element in Assets.images.waste.values) () => images.load(element.path),

      ///
      /// UTILS
      () => images.load(Assets.images.buildings.empty.path),

      ///
      /// POLLUTION
      for (AssetGenImage element in Assets.images.pollution.values) () => images.load(element.path),

      ///
      /// AVATAR
      for (AssetGenImage element in Assets.images.avatar.values) () => images.load(element.path),

      ///
      /// EMOTE
      for (AssetGenImage element in Assets.images.emote.values) () => images.load(element.path),

      ///
      /// ACHIEVEMENTS
      for (AssetGenImage element in Assets.images.achievements.values) () => images.load(element.path),
    ];
  }

  Future<void> preLoadAudio() async {
    await FlameAudio.audioCache.load('button.mp3');
    await FlameAudio.audioCache.load('button_back.mp3');
    await FlameAudio.audioCache.load('Wallpaper.mp3');
  }
}
