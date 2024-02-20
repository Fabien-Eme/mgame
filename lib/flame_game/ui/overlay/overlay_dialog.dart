import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/truck/truck_stacked.dart';
import 'package:mgame/flame_game/ui/overlay/content_garage.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_button.dart';
import 'package:mgame/flame_game/ui/overlay/dialog_tabs.dart';
import 'package:mgame/flame_game/ui/overlay/forward_backward_button.dart';
import 'package:mgame/flame_game/ui/overlay/truck_selector.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/ui/overlay/close_button.dart';
import 'package:mgame/gen/assets.gen.dart';

import '../../game.dart';
import 'tabs_garage.dart';

enum OverlayDialogType { settings, garage, garbageLoader, recycler, incinerator }

class OverlayDialog extends PositionComponent with HasGameReference<MGame> {
  OverlayDialogType overlayDialogType;
  OverlayDialog({required this.overlayDialogType, super.position});

  late Vector2 boxSize;
  late CloseButton closeButton;
  late Sprite spriteNineTileBox;
  int tabSelected = 0;

  List<Map<String, Vector2>> listButtons = [];
  List<DialogTab> listTabs = [];

  ContentGarage? contentGarage;

  @override
  Future<void> onLoad() async {
    position = Vector2(MGame.gameWidth / 2, MGame.gameHeight / 2);
    priority = 900;
    spriteNineTileBox = Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path));
    boxSize = Vector2(900, 500);

    addTabs();
    add(
      NineTileBoxComponent(
        nineTileBox: NineTileBox(spriteNineTileBox, tileSize: 50, destTileSize: 50),
        size: boxSize,
        anchor: Anchor.center,
      ),
    );

    closeButton = CloseButton(position: Vector2(boxSize.x / 2 - 40, -boxSize.y / 2 + 40));
    listButtons.add({'coordinates': closeButton.position, 'size': closeButton.size});
    add(closeButton);

    addContent();
  }

  void addContent() {
    switch (overlayDialogType) {
      case OverlayDialogType.garage:
        contentGarage = ContentGarage(boxSize: boxSize);
        add(contentGarage!);

        break;
      default:
        break;
    }
  }

  void addTabs() {
    switch (overlayDialogType) {
      case OverlayDialogType.garage:
        add(TabsGarage(boxSize: boxSize));
        break;
      default:
        break;
    }
  }

  bool isCoordinatesOverButton(Vector2 coordinates) {
    coordinates -= position;
    bool isOver = false;

    for (Map<String, Vector2> button in listButtons) {
      if (coordinates.x < button['coordinates']!.x + button['size']!.x / 2 &&
          coordinates.x > button['coordinates']!.x - button['size']!.x / 2 &&
          coordinates.y > button['coordinates']!.y - button['size']!.y / 2 &&
          coordinates.y < button['coordinates']!.y + button['size']!.y / 2) {
        isOver = true;
      }
    }
    return isOver;
  }
}
