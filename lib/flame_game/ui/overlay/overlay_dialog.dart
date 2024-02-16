import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/gen/assets.gen.dart';

class OverlayDialog extends PositionComponent with HasGameReference {
  OverlayDialogType overlayDialogType;
  OverlayDialog({required this.overlayDialogType, super.position});

  late NineTileBoxComponent nineTileBoxComponent;

  @override
  Future<void> onLoad() async {
    priority = 900;
    final sprite = Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path));
    final boxSize = Vector2(900, 500);
    final nineTileBox = NineTileBox(sprite, tileSize: 50, destTileSize: 50);
    add(
      nineTileBoxComponent = NineTileBoxComponent(
        nineTileBox: nineTileBox,
        position: size / 2,
        size: boxSize,
        anchor: Anchor.center,
      ),
    );
  }
}

enum OverlayDialogType {
  settings,
  garage,
  garbageLoader,
  recycler,
  incinerator,
}
