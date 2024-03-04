import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../gen/assets.gen.dart';
import '../buildings/building.dart';
import '../tile/tile_helper.dart';
import '../utils/convert_rotations.dart';
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
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.garbageLoader, buildingDirection: Directions.S);
        }
      case ButtonType.recycler:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.recycler, buildingDirection: Directions.S);
        }
      case ButtonType.incinerator:
        if (state == buttonType) {
          ref.read(constructionModeControllerProvider.notifier).exitConstructionMode();
        } else {
          ref.read(constructionModeControllerProvider.notifier).enterConstructionMode(buildingType: BuildingType.incinerator, buildingDirection: Directions.S);
        }
    }
  }

  void resetButtons() {
    state = null;
  }

  void onSecondaryTapUp() {
    if (state == null) {
      gotTapped(ButtonType.trash);
    } else {
      gotTapped(state!);
    }
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
