import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';
import 'package:mgame/flame_game/controller/gamebloc_consumer.dart';
import 'package:mgame/flame_game/controller/grid_controller.dart';
import 'package:mgame/flame_game/controller/mouse_controller.dart';
import 'package:mgame/flame_game/utils/game_assets.dart';
import 'package:mgame/flame_game/ui/ui_bottom_bar.dart';

import 'controller/construction_controller.dart';
import 'controller/cursor_controller.dart';
import 'controller/drag_zoom_controller.dart';
import 'controller/tap_controller.dart';
import 'game_world.dart';
import 'ui/mouse_cursor.dart';

class MGame extends FlameGame
    with MouseMovementDetector, ScrollDetector, MultiTouchDragDetector, TapDetector, SecondaryTapDetector, TertiaryTapDetector, HasKeyboardHandlerComponents, RiverpodGameMixin {
  static const double gameWidth = 2000;
  static const double gameHeight = 900;
  final Vector2 viewfinderInitialPosition = Vector2(gameWidth / 2, gameHeight / 2);
  static const double tileWidth = 100;
  static const double tileHeight = 50;
  static const double maxZoom = 3;
  static const double minZoom = 1.06;

  final bool isMobile;
  final bool isDesktop;
  final GameBloc gameBloc;
  MGame({
    required this.isMobile,
    required this.isDesktop,
    required this.gameBloc,
  }) : super(
          world: GameWorld(gameBloc: gameBloc),
          camera: CameraComponent.withFixedResolution(
              width: gameWidth,
              height: gameHeight,
              viewfinder: Viewfinder()
                ..position = Vector2(gameWidth / 2, gameHeight / 2)
                ..zoom = minZoom),
        );

  Vector2 currentMouseTilePos = Vector2.zero();
  Vector2 mousePosition = Vector2.zero();

  bool hasConstructed = false;
  bool isMouseDragging = false;
  bool isMouseHoveringUI = false;

  late final UIBottomBar uiComponent;
  late final MyMouseCursor myMouseCursor;
  late final MouseController mouseController;
  late final DragZoomController dragZoomController;
  final TapController tapController = TapController();
  late final GridController gridController;
  late final ConstructionController constructionController;
  late final CursorController cursorController;

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

    uiComponent = UIBottomBar();
    myMouseCursor = MyMouseCursor();

    ///Adding Controllers
    mouseController = MouseController();
    dragZoomController = DragZoomController();
    // tapController = TapController();
    gridController = GridController();
    constructionController = ConstructionController();
    cursorController = CursorController();
    world.addAll([
      mouseController,
      dragZoomController,
      tapController,
      gridController,
      constructionController,
      cursorController,
    ]);

    return super.onLoad();
  }

  ///
  ///
  /// Game Mount
  ///
  @override
  void onMount() async {
    /// Adding UI

    await camera.viewport.add(FlameMultiBlocProvider(
      providers: [FlameBlocProvider<GameBloc, GameState>.value(value: gameBloc)],
      children: [
        uiComponent,
        myMouseCursor,
        GameBlocConsumer(),
      ],
    ));

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
