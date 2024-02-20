import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';
import 'package:mgame/flame_game/ui/overlay/slider_component.dart';
import 'package:mgame/flame_game/utils/convert_coordinates.dart';
import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../riverpod_controllers/overlay_controller.dart';
import '../../utils/my_text_style.dart';
import 'dialog_button.dart';

class ContentSettings extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  Vector2 boxSize;
  ContentSettings({required this.boxSize, super.position});

  late SliderComponent musicSlider;
  late SliderComponent soundSlider;

  SliderComponent? sliderCurrentlyDragged;

  @override
  FutureOr<void> onLoad() {
    final title = TextComponent(
      text: "SETTINGS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    add(title);

    final buttonConfirm = DialogButton(
      text: 'Confirm',
      onPressed: () {
        FlameAudio.bgm.audioPlayer.setVolume(game.musicVolume);
        ref.read(overlayControllerProvider.notifier).overlayClose();
      },
      buttonSize: Vector2(150, 50),
      position: Vector2(boxSize.x / 5, boxSize.y / 2 - 50),
    );
    add(buttonConfirm);
    (parent as OverlayDialog).listButtons.add({'coordinates': buttonConfirm.position, 'size': buttonConfirm.buttonSize});

    final buttonMenu = DialogButton(
      text: 'Main Menu',
      onPressed: () {
        print("Main Menu");
      },
      textStyle: MyTextStyle.buttonRed,
      buttonSize: Vector2(200, 50),
      isButtonBack: true,
      position: Vector2(-boxSize.x / 5, boxSize.y / 2 - 50),
    );
    add(buttonMenu);
    (parent as OverlayDialog).listButtons.add({'coordinates': buttonMenu.position, 'size': buttonMenu.buttonSize});

    ///
    ///
    /// MUSIC
    final musicHeader = TextComponent(
      text: "MUSIC",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 100),
    );
    add(musicHeader);

    final musicOff = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.musicOff.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(-175, -boxSize.y / 2 + 160),
    );
    add(musicOff);

    final musicOn = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.musicOn.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(175, -boxSize.y / 2 + 160),
    );
    add(musicOn);

    musicSlider = SliderComponent(
      numberOfSteps: 5,
      position: Vector2(0, -boxSize.y / 2 + 175),
      initialValue: game.musicVolume,
      callback: (double value) {
        game.musicVolume = value;
      },
    );
    add(musicSlider);

    ///
    ///
    /// Sound Effect
    final soundHeader = TextComponent(
      text: "SOUND EFFECT",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 250),
    );
    add(soundHeader);

    final soundOff = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.audioOff.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(-175, -boxSize.y / 2 + 310),
    );
    add(soundOff);

    final soundOn = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.audioOn.path)),
      paint: Paint()..filterQuality = FilterQuality.low,
      scale: Vector2.all(0.6),
      anchor: Anchor.center,
      position: Vector2(175, -boxSize.y / 2 + 310),
    );
    add(soundOn);

    soundSlider = SliderComponent(
      numberOfSteps: 5,
      position: Vector2(0, -boxSize.y / 2 + 325),
      initialValue: game.soundVolume,
      callback: (double value) {
        game.soundVolume = value;
      },
    );
    add(soundSlider);

    return super.onLoad();
  }

  void onDragStart(DragStartInfo info) {
    Vector2 touchPosition = game.camera.globalToLocal(info.eventPosition.global) - (parent as OverlayDialog).position;
    if (isVectorInsideObject(vector: touchPosition - musicSlider.position + musicSlider.size / 2, objectPosition: musicSlider.selector.position, objectSize: musicSlider.selector.size)) {
      sliderCurrentlyDragged = musicSlider;
    }
    if (isVectorInsideObject(vector: touchPosition - soundSlider.position + soundSlider.size / 2, objectPosition: soundSlider.selector.position, objectSize: soundSlider.selector.size)) {
      sliderCurrentlyDragged = soundSlider;
    }
  }

  void onDragUpdate(DragUpdateInfo info) {
    sliderCurrentlyDragged?.changeSelectorPosition(info.delta.global.x);
  }

  void onDragEnd(DragEndInfo info) {
    sliderCurrentlyDragged = null;
  }

  void onDragCancel() {
    sliderCurrentlyDragged = null;
  }
}
