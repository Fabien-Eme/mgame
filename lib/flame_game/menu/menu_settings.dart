import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/painting.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../riverpod_controllers/overlay_controller.dart';
import '../ui/overlay/close_button.dart';
import '../router/route_make_other_ignore_events.dart';
import '../ui/overlay/dialog_button.dart';
import '../ui/overlay/slider_component.dart';
import '../utils/convert_coordinates.dart';
import '../utils/my_text_style.dart';

class MenuSettingsRoute extends RouteMakeOtherIgnoreEvents {
  MenuSettingsRoute() : super(MenuSettings.new, transparent: true);
}

class MenuSettings extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  final Vector2 boxSize = Vector2(600, 500);
  late SliderComponent musicSlider;
  late SliderComponent soundSlider;

  SliderComponent? sliderCurrentlyDragged;

  @override
  FutureOr<void> onLoad() {
    add(world = World());
    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      viewfinder: Viewfinder(),
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

    world.add(CloseButton(position: Vector2(boxSize.x / 2 - 40, -boxSize.y / 2 + 40)));

    ///
    ///
    /// TITLE
    final title = TextComponent(
      text: "SETTINGS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    world.add(title);

    ///
    ///
    /// BUTTONS
    final buttonConfirm = DialogButton(
      text: 'Confirm',
      onPressed: () {
        FlameAudio.bgm.audioPlayer.setVolume(game.musicVolume);
        game.router.pop();
      },
      buttonSize: Vector2(150, 50),
      position: Vector2((game.router.previousRoute?.name == "mainMenu") ? 0 : boxSize.x / 5, boxSize.y / 2 - 50),
    );
    world.add(buttonConfirm);

    if (game.router.previousRoute?.name != "mainMenu") {
      final buttonMenu = DialogButton(
        text: 'Main Menu',
        onPressed: () {
          game.router.popUntilNamed('mainMenu');
        },
        textStyle: MyTextStyle.buttonRed,
        buttonSize: Vector2(200, 50),
        isButtonBack: true,
        position: Vector2(-boxSize.x / 5, boxSize.y / 2 - 50),
      );

      world.add(buttonMenu);
    }

    ///
    ///
    /// MUSIC
    final musicHeader = TextComponent(
      text: "MUSIC",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );
    world.add(musicHeader);

    final musicOff = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.musicOff.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(-175, -boxSize.y / 2 + 160),
    );
    world.add(musicOff);

    final musicOn = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.musicOn.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(175, -boxSize.y / 2 + 160),
    );
    world.add(musicOn);

    musicSlider = SliderComponent(
      numberOfSteps: 5,
      position: Vector2(0, -boxSize.y / 2 + 175),
      initialValue: game.musicVolume,
      callback: (double value) {
        game.musicVolume = value;
      },
    );
    world.add(musicSlider);

    ///
    ///
    /// SOUND EFFECT
    final soundHeader = TextComponent(
      text: "SOUND EFFECT",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 250),
    );
    world.add(soundHeader);

    final soundOff = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.audioOff.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(-175, -boxSize.y / 2 + 310),
    );
    world.add(soundOff);

    final soundOn = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.audioOn.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(175, -boxSize.y / 2 + 310),
    );
    world.add(soundOn);

    soundSlider = SliderComponent(
      numberOfSteps: 5,
      position: Vector2(0, -boxSize.y / 2 + 325),
      initialValue: game.soundVolume,
      callback: (double value) {
        game.soundVolume = value;
      },
    );
    world.add(soundSlider);

    return super.onLoad();
  }

  //   void onDragStart(DragStartInfo info) {
  //   Vector2 touchPosition = game.camera.globalToLocal(info.eventPosition.global) - (parent as OverlayDialog).position;
  //   if (isVectorInsideObject(vector: touchPosition - musicSlider.position + musicSlider.size / 2, objectPosition: musicSlider.selector.position, objectSize: musicSlider.selector.size)) {
  //     sliderCurrentlyDragged = musicSlider;
  //   }
  //   if (isVectorInsideObject(vector: touchPosition - soundSlider.position + soundSlider.size / 2, objectPosition: soundSlider.selector.position, objectSize: soundSlider.selector.size)) {
  //     sliderCurrentlyDragged = soundSlider;
  //   }
  // }

  // void onDragUpdate(DragUpdateInfo info) {
  //   sliderCurrentlyDragged?.changeSelectorPosition(info.delta.global.x);
  // }

  // void onDragEnd(DragEndInfo info) {
  //   sliderCurrentlyDragged = null;
  // }

  // void onDragCancel() {
  //   sliderCurrentlyDragged = null;
  // }
}
