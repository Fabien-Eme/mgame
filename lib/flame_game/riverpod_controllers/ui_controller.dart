import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../gen/assets.gen.dart';
import '../buildings/building.dart';
import '../tile.dart';
import 'construction_mode_controller.dart';

part 'ui_controller.g.dart';

@Riverpod(keepAlive: true)
class ActiveUIButtonController extends _$ActiveUIButtonController {
  @override
  ButtonType? build() {
    return null;
  }

  void gotTapped(ButtonType buttonType) {
    callButtonAction(buttonType);
    if (state == buttonType) {
      state = null;
    } else {
      state = buttonType;
    }
  }

  void callButtonAction(ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.road:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(tileType: TileType.road);
        }
      case ButtonType.trash:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitDestructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterDestructionMode();
        }
      case ButtonType.garbageLoader:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.garbageLoader);
        }
      case ButtonType.recycler:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.recycler);
        }
      case ButtonType.incinerator:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.incinerator);
        }
    }
  }

  void onSecondaryTapUp() {
    gotTapped(ButtonType.trash);
  }
}

enum ButtonType {
  road,
  trash,
  garbageLoader,
  recycler,
  incinerator;

  String get path {
    return switch (this) {
      ButtonType.road => Assets.images.ui.uiRoadSN.path,
      ButtonType.trash => Assets.images.ui.uiTrash.path,
      ButtonType.garbageLoader => Assets.images.ui.uiGarbageLoader.path,
      ButtonType.recycler => Assets.images.ui.uiRecycler.path,
      ButtonType.incinerator => Assets.images.ui.uiIncinerator.path,
    };
  }
}
