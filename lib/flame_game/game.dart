import 'dart:async';
import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:mgame/flame_game/level_world.dart';

import 'package:mgame/flame_game/menu/main_menu.dart';
import 'package:mgame/flame_game/router/route_can_ignore_events.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import 'package:mgame/flame_game/utils/game_assets.dart';

import '../gen/assets.gen.dart';
import 'controller/audio_controller.dart';

import 'level.dart';
import 'ui/mouse_cursor.dart';
import 'utils/palette.dart';

class MGame extends FlameGame with MouseMovementDetector, ScrollDetector, MultiTouchDragDetector, TapDetector, SecondaryTapDetector, TertiaryTapDetector, KeyboardEvents, RiverpodGameMixin {
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
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
            viewfinder: Viewfinder()..anchor = Anchor.topLeft,
          ),
        );

  Color customBackgroundColor = Palette.backGroundMenu;

  Vector2 mousePosition = Vector2.zero();

  double musicVolume = 0.0;
  double soundVolume = 0.4;

  bool isMouseDragging = false;
  bool isMouseHoveringUI = false;
  bool isMouseHoveringBuilding = false;
  bool isMouseHoveringOverlay = false;
  bool isMouseHoveringOverlayButton = false;

  bool isMainMenu = true;

  late MainMenu mainMenu;

  OverlayDialog? overlayDialog;

  //final GameController gameController = GameController();

  final MyMouseCursor myMouseCursor = MyMouseCursor();
  final AudioController audioController = AudioController();

  late final RouterComponent router;

  ///
  ///
  /// Game Load
  ///
  @override
  FutureOr<void> onLoad() async {
    /// Load Sounds
    await preLoadAudio();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(Assets.music.forestal).then((value) => FlameAudio.bgm.audioPlayer.setVolume(musicVolume));

    /// Preload all images
    images.prefix = '';
    final futurePreLoadImages = preLoadAssetsImages().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadImages);

    children.register<LevelWorld>();

    /// Hide system mouse cursor before adding custom one
    mouseCursor = SystemMouseCursors.none;

    /// Add Custom Mouse Cursor
    camera.viewport.add(myMouseCursor);

    /// Add Audio controller
    add(audioController);

    add(
      router = RouterComponent(
        routes: {
          //'splash': Route(SplashScreenPage.new),
          'mainMenu': RouteCanIgnoreEvents(MainMenu.new, maintainState: false),
          'level1': RouteCanIgnoreEvents(() => Level(1), maintainState: false),
        },
        initialRoute: 'mainMenu',
      ),
    );

    add(FpsTextComponent());

    //gameController.startGame();
    return super.onLoad();
  }

  ///
  ///
  /// Move [myMouseCursor] to follow mouse
  ///
  void moveMouseCursor(Vector2 pos) {
    Vector2 futureMouseCursorPosition = camera.globalToLocal(pos);

    if (futureMouseCursorPosition.x < 0) futureMouseCursorPosition.x = 0;
    if (futureMouseCursorPosition.x > gameWidth - 5) futureMouseCursorPosition.x = gameWidth - 5;
    if (futureMouseCursorPosition.y < 0) futureMouseCursorPosition.y = 0;
    if (futureMouseCursorPosition.y > gameHeight - 5) futureMouseCursorPosition.y = gameHeight - 5;

    myMouseCursor.updatePosition(futureMouseCursorPosition);
  }

  ///
  ///
  /// Handle Keyboard

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    // Return handled to prevent macOS noises.
    return KeyEventResult.handled;
  }

  ///
  ///
  /// Handle Taps

  @override
  void onTertiaryTapDown(TapDownInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.tapController.onTertiaryTapDown(info);
    }
    super.onTertiaryTapDown(info);
  }

  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.tapController.onSecondaryTapUp(info);
    }
    super.onSecondaryTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.tapController.onTapDown(info);
    }
    super.onTapDown(info);
  }

  ///
  ///
  /// Forward Mouse movement to Controller
  ///
  @override
  void onMouseMove(PointerHoverInfo info) {
    if (isDesktop) moveMouseCursor(info.eventPosition.global);
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.mouseController.onMouseMove(info);
    }
    super.onMouseMove(info);
  }

  ///
  ///
  /// Forward Scroll to Controller

  @override
  void onScroll(PointerScrollInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onScroll(info);
    }
    super.onScroll(info);
  }

  ///
  ///
  /// Forward Drag to Controller

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onDragStart(pointerId, info);
    }
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onDragUpdate(pointerId, info);
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onDragEnd(pointerId, info);
    }
  }

  @override
  void onDragCancel(int pointerId) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onDragCancel(pointerId);
    }
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (router.currentRoute.children.first as Level).levelWorld.dragZoomController.onSecondaryButtonDragUpdate(details);
    }
  }

  ///
  ///
  /// Game Background
  @override
  Color backgroundColor() {
    return customBackgroundColor;
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
/// overlay settings : 990