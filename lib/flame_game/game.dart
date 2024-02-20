import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgame/flame_game/controller/building_controller.dart';
import 'package:mgame/flame_game/controller/truck_controller.dart';
import 'package:mgame/flame_game/listener/construction_mode_listener.dart';
import 'package:mgame/flame_game/controller/grid_controller.dart';
import 'package:mgame/flame_game/controller/mouse_controller.dart';
import 'package:mgame/flame_game/listener/overlay_listener.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';
import 'package:mgame/flame_game/ui/settings_button.dart';
import 'package:mgame/flame_game/ui/ui_rotate.dart';
import 'package:mgame/flame_game/utils/convert_rotations.dart';
import 'package:mgame/flame_game/utils/game_assets.dart';
import 'package:mgame/flame_game/ui/ui_bottom_bar.dart';
import 'package:mgame/settings/settings.dart';

import 'controller/construction_controller.dart';
import 'controller/cursor_controller.dart';
import 'controller/drag_zoom_controller.dart';
import 'controller/tap_controller.dart';
import 'game_world.dart';
import 'ui/mouse_cursor.dart';

class MGame extends FlameGame<GameWorld>
    with MouseMovementDetector, ScrollDetector, MultiTouchDragDetector, TapDetector, SecondaryTapDetector, TertiaryTapDetector, HasKeyboardHandlerComponents, RiverpodGameMixin {
  static const double gameWidth = 2000;
  static const double gameHeight = 1000;
  final Vector2 viewfinderInitialPosition = Vector2(gameWidth / 2, gameHeight / 2);
  static const double tileWidth = 100;
  static const double tileHeight = 50;
  static const double maxZoom = 3;
  static const double minZoom = 1;

  final bool isMobile;
  final bool isDesktop;
  MGame({
    required this.isMobile,
    required this.isDesktop,
  }) : super(
          world: GameWorld(),
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
            viewfinder: Viewfinder()
              ..position = Vector2(gameWidth / 2, gameHeight / 2)
              ..zoom = minZoom,
          ),
        );

  Point<int> currentMouseTilePos = const Point(0, 0);
  Vector2 mousePosition = Vector2.zero();

  bool isMouseDragging = false;
  bool isMouseHoveringUI = false;
  bool isMouseHoveringBuilding = false;
  bool isMouseHoveringOverlay = false;
  bool isMouseHoveringOverlayButton = false;

  OverlayDialog? overlayDialog;

  late final UIBottomBar uiBottomBar;
  late final UIRotate uiRotate;
  late final MyMouseCursor myMouseCursor;
  late final SettingsButton settingsButton;

  late final MouseController mouseController;
  late final DragZoomController dragZoomController;
  late final TapController tapController;
  late final GridController gridController;
  late final ConstructionController constructionController;
  late final CursorController cursorController;
  late final BuildingController buildingController;
  late final ConvertRotations convertRotations;
  late final TruckController truckController;

  ///
  ///
  /// Game Load
  ///
  @override
  FutureOr<void> onLoad() async {
    /// Preload all images
    images.prefix = '';
    final futures = preLoadAssets().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futures);

    /// Hide system mouse cursor before adding custom one
    mouseCursor = SystemMouseCursors.none;

    uiBottomBar = UIBottomBar();
    uiRotate = UIRotate();
    myMouseCursor = MyMouseCursor();
    settingsButton = SettingsButton();

    ///Adding Controllers
    mouseController = MouseController();
    dragZoomController = DragZoomController();
    tapController = TapController();
    gridController = GridController();
    constructionController = ConstructionController();
    cursorController = CursorController();
    buildingController = BuildingController();
    convertRotations = ConvertRotations();
    truckController = TruckController();

    world.addAll([
      mouseController,
      dragZoomController,
      tapController,
      gridController,
      constructionController,
      cursorController,
      buildingController,
      convertRotations,
      truckController,
    ]);

    world.addAll([
      ConstructionModeListener(),
      OverlayListener(),
    ]);

    return super.onLoad();
  }

  ///
  ///
  /// Game Mount
  ///
  @override
  void onMount() {
    /// Adding UI

    camera.viewport.addAll(
      [
        uiBottomBar,
        uiRotate,
        myMouseCursor,
        settingsButton,
        FpsTextComponent(),
      ],
    );
    super.onMount();
  }

  ///
  ///
  /// Handle Keyboard

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    // Return handled to prevent macOS noises.
    return KeyEventResult.handled;
  }

  ///
  ///
  /// Handle Taps

  @override
  void onTertiaryTapDown(TapDownInfo info) {
    tapController.onTertiaryTapDown(info);
    super.onTertiaryTapDown(info);
  }

  @override
  void onSecondaryTapUp(TapUpInfo info) {
    tapController.onSecondaryTapUp(info);
    super.onSecondaryTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    tapController.onTapDown(info);
    super.onTapDown(info);
  }

  ///
  ///
  /// Forward Mouse movement to Controller
  ///

  // @override
  @override
  void onMouseMove(PointerHoverInfo info) {
    mouseController.onMouseMove(info);
    super.onMouseMove(info);
  }

  ///
  ///
  /// Forward Scroll to Controller

  @override
  void onScroll(PointerScrollInfo info) {
    dragZoomController.onScroll(info);
    super.onScroll(info);
  }

  ///
  ///
  /// Forward Drag to Controller

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    dragZoomController.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    dragZoomController.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    dragZoomController.onDragEnd(pointerId, info);
  }

  @override
  void onDragCancel(int pointerId) {
    dragZoomController.onDragCancel(pointerId);
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    dragZoomController.onSecondaryButtonDragUpdate(details);
  }

  ///
  ///
  /// Game Background
  @override
  Color backgroundColor() {
    return const Color(0x0ff00000);
  }
}


///
///
///
/// Priority of Game
/// 
/// UI Rotate : 500
/// UI Bottom Bar : 400
/// 
/// Mouse : 1000
/// 
/// 
/// overlay dialog : 900