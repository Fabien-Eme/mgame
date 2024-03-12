import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:mgame/flame_game/buildings/city/city.dart';
import 'package:mgame/flame_game/dialog/dialog_window.dart';
import 'package:mgame/flame_game/level_world.dart';

// ignore: implementation_imports
import 'package:flame/src/events/flame_game_mixins/multi_drag_dispatcher.dart';

import 'package:mgame/flame_game/menu/main_menu.dart';
import 'package:mgame/flame_game/menu/menu_garage/menu_garage.dart';
import 'package:mgame/flame_game/menu/menu_incinerator.dart';
import 'package:mgame/flame_game/router/route_can_ignore_events.dart';

import 'package:mgame/flame_game/utils/game_assets.dart';

import 'buildings/building.dart';
import 'buildings/incinerator/incinerator.dart';
import 'controller/audio_controller.dart';

import 'dialog/tutorial.dart';
import 'level.dart';
import 'menu/briefing.dart';
import 'menu/menu_achievement.dart';
import 'menu/menu_city.dart';
import 'menu/menu_game_won.dart';
import 'menu/menu_level_lost.dart';
import 'menu/menu_level_won.dart';
import 'menu/menu_settings.dart';
import 'menu/root.dart';
import 'router/route_make_other_ignore_events.dart';
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
  final bool isWeb;

  MGame({
    required this.isMobile,
    required this.isDesktop,
    required this.isWeb,
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
            viewfinder: Viewfinder()..anchor = Anchor.topLeft,
          ),
        );

  Color customBackgroundColor = Palette.backGroundMenu;

  Vector2 mousePosition = Vector2.zero();

  bool hasAudioBeenActivatedOnWeb = false;
  double musicVolume = 0.2;
  double soundVolume = 0.4;

  bool isMouseDragging = false;
  bool isMouseHoveringUI = false;
  Building? isMouseHoveringBuilding;
  bool isMouseHoveringOverlay = false;
  bool isMouseHoveringOverlayButton = false;

  City? currentCity;
  Incinerator? currentIncinerator;

  final MyMouseCursor myMouseCursor = MyMouseCursor();
  final AudioController audioController = AudioController();

  late final RouterComponent router;

  int lastLevelCompleted = 0;
  int currentLevel = 0;

  bool isAudioEnabled = true;

  double globalAirQualityValue = 0;
  String globalAirQualityString = "";
  String globalAirQualityColor = "";

  Point<int>? mobileTempCurrentMouseTilePos;
  BuildingType? mobileTempBuildingType;

  ///
  ///
  /// Game Load
  ///
  @override
  FutureOr<void> onLoad() async {
    /// Load Sounds

    if (isAudioEnabled) {
      await preLoadAudio();

      FlameAudio.bgm.initialize();
      if (!isWeb) FlameAudio.bgm.play('Wallpaper.mp3').then((value) => FlameAudio.bgm.audioPlayer.setVolume(musicVolume));
    }

    /// Preload all images
    images.prefix = '';
    final futurePreLoadImages = preLoadAssetsImages().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadImages);

    children.register<LevelWorld>();

    /// Hide system mouse cursor before adding custom one
    mouseCursor = SystemMouseCursors.none;

    /// Add Custom Mouse Cursor
    if (!isMobile) camera.viewport.add(myMouseCursor);

    /// Add Audio controller
    add(audioController);

    children.register<Level>();

    add(
      router = RouterComponent(
        routes: {
          'root': RouteCanIgnoreEvents(Root.new, maintainState: false),

          ///
          'mainMenu': RouteCanIgnoreEvents(MainMenu.new, transparent: true, maintainState: false),
          'menuSettings': RouteMakeOtherIgnoreEvents(MenuSettings.new, transparent: true, maintainState: false),
          'menuAchievements': RouteMakeOtherIgnoreEvents(MenuAchievement.new, transparent: true, maintainState: false),

          ///
          'levelBackground': RouteIgnoreEvents(() => Level(level: 0, key: ComponentKey.named('level')), maintainState: false),
          'level1': RouteCanIgnoreEvents(() => Level(level: 1, key: ComponentKey.named('level')), maintainState: false),
          'level2': RouteCanIgnoreEvents(() => Level(level: 2, key: ComponentKey.named('level')), maintainState: false),
          'level3': RouteCanIgnoreEvents(() => Level(level: 3, key: ComponentKey.named('level')), maintainState: false),

          ///
          'levelWon': RouteMakeOtherIgnoreEvents(MenuLevelWon.new, transparent: true, maintainState: false),
          'gameWon': RouteMakeOtherIgnoreEvents(MenuGameWon.new, transparent: true, maintainState: false),
          'levelLost': RouteMakeOtherIgnoreEvents(MenuLevelLost.new, transparent: true, maintainState: false),
          'tutorial': RouteMakeOtherIgnoreEvents(Tutorial.new, transparent: true, maintainState: false),
          'briefing': RouteMakeOtherIgnoreEvents(Briefing.new, transparent: true, maintainState: false),

          ///
          'menuGarage': RouteMakeOtherIgnoreEvents(MenuGarage.new, doesPutGameInPause: false, transparent: true, maintainState: false),
          'menuCity': RouteMakeOtherIgnoreEvents(MenuCity.new, doesPutGameInPause: false, transparent: true, maintainState: false),
          'menuIncinerator': RouteMakeOtherIgnoreEvents(MenuIncinerator.new, doesPutGameInPause: false, transparent: true, maintainState: false),
        },
        initialRoute: 'root',
      ),
    );

    // add(FpsTextComponent());

    return super.onLoad();
  }

  ///
  ///
  /// Retrieve Global Air Quality
  Future<void> getGlobalAirQuality() async {
    final doc = await FirebaseFirestore.instance.collection('air_quality').doc('current').get();
    final map = doc.data();
    globalAirQualityValue = double.tryParse(map?['globalNumber'] as String? ?? "") ?? 0;
    globalAirQualityString = (map?['globalText'] as String?) ?? "";
    globalAirQualityColor = (map?['globalColor'] as String?) ?? "";
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
      (findByKeyName('level') as Level?)?.levelWorld.tapController.onTertiaryTapDown(info);
    }
    super.onTertiaryTapDown(info);
  }

  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.tapController.onSecondaryTapUp(info);
    }
    super.onSecondaryTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.tapController.onTapDown(info);
    }
    (findByKeyName('dialogWindow') as DialogWindow?)?.advanceDialog();

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
      (findByKeyName('level') as Level?)?.levelWorld.mouseController.onMouseMove(info);
    }
    super.onMouseMove(info);
  }

  ///
  ///
  /// Forward Scroll to Controller

  @override
  void onScroll(PointerScrollInfo info) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onScroll(info);
    }
    super.onScroll(info);
  }

  ///
  ///
  /// Forward Drag to Controller

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    // Forward the event down the tree. This will lead to a PR in the future
    // ignore: invalid_use_of_internal_member
    findByKey<MultiDragDispatcher>(const MultiDragDispatcherKey())?.handleDragStart(pointerId, info.raw);

    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onDragStart(pointerId, info);
    }
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (isDesktop) moveMouseCursor(info.eventPosition.global);

    // Forward the event down the tree. This will lead to a PR in the future
    // ignore: invalid_use_of_internal_member
    findByKey<MultiDragDispatcher>(const MultiDragDispatcherKey())?.handleDragUpdate(pointerId, info.raw);

    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onDragUpdate(pointerId, info);
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // Forward the event down the tree. This will lead to a PR in the future
    // ignore: invalid_use_of_internal_member
    findByKey<MultiDragDispatcher>(const MultiDragDispatcherKey())?.handleDragEnd(pointerId, info.raw);

    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onDragEnd(pointerId, info);
    }
  }

  @override
  void onDragCancel(int pointerId) {
    // Forward the event down the tree. This will lead to a PR in the future
    // ignore: invalid_use_of_internal_member
    findByKey<MultiDragDispatcher>(const MultiDragDispatcherKey())?.handleDragCancel(pointerId);

    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onDragCancel(pointerId);
    }
  }

  void onSecondaryButtonDragUpdate(DragUpdateDetails details) {
    if (router.currentRoute.name?.contains('level') ?? false) {
      (findByKeyName('level') as Level?)?.levelWorld.dragZoomController.onSecondaryButtonDragUpdate(details);
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
/// 
/// 
/// 
/// 
/// "Wallpaper" Kevin MacLeod (incompetech.com)
/// Licensed under Creative Commons: By Attribution 4.0 License
/// http://creativecommons.org/licenses/by/4.0/