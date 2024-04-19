import 'package:flame/components.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../level.dart';
import 'close_button.dart';

class MenuWithoutTabs extends PositionComponent with HasGameReference<MGame> {
  final bool isCloseButtonShown;
  Vector2 boxSize;
  MenuWithoutTabs({required this.boxSize, this.isCloseButtonShown = true});

  late final World world;
  late final CameraComponent cameraComponent;

  @override
  void onLoad() {
    add(world = World());
    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
    ));

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

    if (isCloseButtonShown) world.add(CloseButton(position: Vector2(boxSize.x / 2 - 40, -boxSize.y / 2 + 40)));
  }

  @override
  void onRemove() {
    (game.findByKeyName('level') as Level?)?.levelWorld.buildings.forEach((element) {
      element.deselect();
    });
    super.onRemove();
  }
}
