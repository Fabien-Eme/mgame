import 'package:flame/components.dart';
import 'package:mgame/flame_game/menu/dialog_tabs.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../level.dart';
import 'close_button.dart';

class MenuWithTabs extends PositionComponent with HasGameReference<MGame> {
  final Vector2 boxSize;
  final Map<String, Component Function()> mapDialogTab;
  MenuWithTabs({required this.boxSize, required this.mapDialogTab});

  late final World world;
  late final CameraComponent cameraComponent;

  Component? currentTabComponent;

  @override
  void onLoad() {
    super.onLoad();
    add(world = World());
    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
    ));

    int currentTabCount = 0;
    for (String tabTitle in mapDialogTab.keys) {
      world.add(
        DialogTab(
          tabTitle: tabTitle,
          onPressed: () {
            selectTab(tabTitle);
          },
          position: Vector2(-boxSize.x / 2 - 50, -boxSize.y / 2 + 40 + 50 * currentTabCount),
        ),
      );
      currentTabCount++;
    }

    world.add(
      NineTileBoxComponent(
        nineTileBox: NineTileBox(
          Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)),
          tileSize: 50,
          destTileSize: 50,
        ),
        size: boxSize,
        anchor: Anchor.center,
      ),
    );

    world.add(CloseButton(position: Vector2(boxSize.x / 2 - 40, -boxSize.y / 2 + 40)));

    selectTab(mapDialogTab.keys.first);
  }

  void selectTab(String tabTitle) async {
    if (currentTabComponent != null) world.remove(currentTabComponent!);

    await currentTabComponent?.removed;

    currentTabComponent = mapDialogTab[tabTitle]!();
    world.add(currentTabComponent!);

    world.children.whereType<DialogTab>().forEach((DialogTab dialogTab) {
      if (dialogTab.tabTitle == tabTitle) {
        dialogTab.select();
      } else {
        dialogTab.deSelect();
      }
    });
  }

  @override
  void onRemove() {
    (game.findByKeyName('level') as Level?)?.levelWorld.buildings.forEach((element) {
      element.deselect();
    });
    super.onRemove();
  }
}
