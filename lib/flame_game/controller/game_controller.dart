import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/controller/garbage_controller.dart';
import 'package:mgame/flame_game/controller/task_controller.dart';
import 'package:mgame/flame_game/menu.dart/main_menu.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';

import '../game.dart';
import '../game_world.dart';
import '../listener/construction_mode_listener.dart';
import '../ui/settings_button.dart';
import '../ui/ui_bottom_bar.dart';
import '../ui/ui_rotate.dart';
import '../utils/convert_rotations.dart';
import 'building_controller.dart';
import 'construction_controller.dart';
import 'cursor_controller.dart';
import 'drag_zoom_controller.dart';
import 'grid_controller.dart';
import 'mouse_controller.dart';
import 'tap_controller.dart';
import 'truck_controller.dart';

class GameController extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  ///
  ///
  /// Start the Game
  void startGame() async {
    game.camera.viewport.remove(game.mainMenu);

    await addWorld();
    await addUi();
    Future.delayed(const Duration(milliseconds: 100)).then((value) => game.isMainMenu = false);

    ref.read(overlayControllerProvider.notifier).overlayClose();

    game.garbageController.createGarbageStack();
  }

  ///
  ///
  /// Display the [MainMenu]
  void goToMainMenu() async {
    game.isMainMenu = true;
    ref.read(overlayControllerProvider.notifier).overlayClose();
    await removeWorld();
    await removeUI();

    game.mainMenu = MainMenu(position: Vector2(MGame.gameWidth / 2, MGame.gameHeight / 2));
    game.camera.viewport.add(game.mainMenu);
  }

  ///
  ///
  /// Add the [GameWorld] and all its controllers
  Future<void> addWorld() async {
    game.world = GameWorld();

    game.uiBottomBar = UIBottomBar();
    game.uiRotate = UIRotate();
    game.settingsButton = SettingsButton();
    game.mouseController = MouseController();
    game.dragZoomController = DragZoomController();
    game.tapController = TapController();
    game.gridController = GridController();
    game.constructionController = ConstructionController();
    game.cursorController = CursorController();
    game.buildingController = BuildingController();
    game.convertRotations = ConvertRotations();
    game.truckController = TruckController();
    game.garbageController = GarbageController();
    game.taskController = TaskController();

    ///Adding Controllers
    await game.world.addAll([
      game.mouseController,
      game.dragZoomController,
      game.tapController,
      game.gridController,
      game.constructionController,
      game.cursorController,
      game.buildingController,
      game.convertRotations,
      game.truckController,
      game.garbageController,
      game.taskController,
    ]);

    await game.world.addAll([
      ConstructionModeListener(),
    ]);
  }

  ///
  ///
  ///Add the UI
  Future<void> addUi() async {
    await game.camera.viewport.addAll(
      [
        game.uiBottomBar,
        game.uiRotate,
        game.settingsButton,
        FpsTextComponent(),
      ],
    );
  }

  ///
  ///
  /// Remove World and all its components
  Future<void> removeWorld() async {
    game.world.removeAll(game.world.children);
    List<Future<void>> listFutures = [];
    for (Component component in game.world.children) {
      listFutures.add(component.removed);
    }
    await Future.wait(listFutures);
  }

  ///
  ///
  /// Remove the UI and all its components
  Future<void> removeUI() async {
    game.camera.viewport.removeAll([
      game.uiBottomBar,
      game.uiRotate,
      game.settingsButton,
    ]);
    List<Future<void>> listFutures = [
      game.uiBottomBar.removed,
      game.uiRotate.removed,
      game.settingsButton.removed,
    ];
    await Future.wait(listFutures);
  }
}
