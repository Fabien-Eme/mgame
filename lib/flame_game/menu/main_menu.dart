import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mgame/flame_game/menu/dialog_button.dart';
import 'package:mgame/flame_game/riverpod_controllers/game_user_controller.dart';
import 'package:mgame/flame_game/ui/settings_button.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/utils/palette.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  late final DialogButton playButton;
  late final SettingsButton settingsButton;
  late final DialogButton achievementsButton;
  late final DialogButton oraganizeEventButton;
  late final DialogButton viewEventsButton;
  late final DialogButton viewMyEventsButton;
  late final DialogButton validateParticipationButton;

  late final DialogButton connectButton;
  late final DialogButton disconnectButton;

  late final TextComponent userEmailComponent;
  late final TextComponent ecoCreditsComponent;

  late final RectangleComponent globalAirQualityComponent;
  late final TextBoxComponent globalAirQualityTextComponent;

  bool isLevelLoading = false;

  GameUser? user;

  @override
  FutureOr<void> onLoad() {
    add(world = World());

    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
    ));

    game.currentLevel = 0;

    world.add(RectangleComponent.fromRect(
      Rect.fromCenter(center: const Offset(0, -25), width: 750, height: 450),
      paint: Paint()..color = Palette.blackTransparent,
    ));
    world.add(RectangleComponent.fromRect(
      Rect.fromCenter(center: const Offset(0, 330), width: 350, height: 210),
      paint: Paint()..color = Palette.blackTransparent,
    ));

    world.add(RectangleComponent.fromRect(
      Rect.fromCenter(center: const Offset(0, 300), width: 275, height: 80),
      paint: Paint()..color = Palette.whiteTransparent,
    ));

    playButton = DialogButton(
      text: 'Select Level',
      textStyle: MyTextStyle.bigButton,
      buttonSize: Vector2(300, 75),
      onPressed: () {
        game.router.pushNamed('menuSelectLevel');
      },
      position: Vector2(0, -187.5),
    );

    connectButton = DialogButton(
      text: 'Login / Sign Up',
      buttonSize: Vector2(250, 50),
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('signInUp');
      },
      position: Vector2(0, 380),
    );

    settingsButton = SettingsButton(
      position: Vector2(MGame.gameWidth / 2 - 30, -MGame.gameHeight / 2 + 20),
    );

    achievementsButton = DialogButton(
      text: 'Achievements',
      onPressed: () {
        if (user == null || user!.isLocal) {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('signInUp');
        } else {
          game.router.pushNamed('menuAchievements');
        }
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(0, -100),
    );

    oraganizeEventButton = DialogButton(
      text: 'Organize IRL Event',
      onPressed: () {
        if (user == null || user!.isLocal) {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('signInUp');
        } else {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('organizeEvent');
        }
      },
      buttonSize: Vector2(275, 50),
      position: Vector2(-175, 25),
    );

    viewEventsButton = DialogButton(
      text: 'View all IRL Events',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('viewEvents');
      },
      buttonSize: Vector2(275, 50),
      position: Vector2(-175, 115),
    );

    viewMyEventsButton = DialogButton(
      text: 'My Events',
      onPressed: () {
        if (user == null || user!.isLocal) {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('signInUp');
        } else {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('viewMyEvents');
        }
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(175, 25),
    );

    validateParticipationButton = DialogButton(
      text: 'Validate Participation',
      onPressed: () {
        if (user == null || user!.isLocal) {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('signInUp');
        } else {
          game.mouseCursor = SystemMouseCursors.basic;
          game.overlays.add('validateParticipation');
        }
      },
      buttonSize: Vector2(225, 75),
      position: Vector2(175, 127.5),
    );

    disconnectButton = DialogButton(
      text: 'Disconnect',
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(0, 380),
    );

    userEmailComponent = TextComponent(
      text: "",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(0, 280),
    );

    ecoCreditsComponent = TextComponent(
      text: "",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(0, 315),
    );

    world.add(RectangleComponent.fromRect(
      Rect.fromCenter(center: const Offset(-MGame.gameWidth / 2 + 270, MGame.gameHeight / 2 - 80), width: 500, height: 110),
      paint: Paint()..color = Palette.whiteTransparent,
    ));

    world.add(TextComponent(
      text: "Fabien Eme: Programming - Game Desgin\nSebastien Eme: Game Design - Testing\nKenney.nl: Assets",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-MGame.gameWidth / 2 + 270, MGame.gameHeight / 2 - 80),
    ));

    final whiteRectComponent = RectangleComponent.fromRect(
      const Rect.fromLTWH(-180, -MGame.gameHeight / 2 - 20, 360, 155),
      paint: Paint()..color = Colors.white,
    );

    globalAirQualityComponent = RectangleComponent.fromRect(
      const Rect.fromLTWH(-175, -MGame.gameHeight / 2 - 10, 350, 140),
      children: [
        globalAirQualityTextComponent = TextBoxComponent(
          text: "",
          align: Anchor.center,
          textRenderer: MyTextStyle.airInfo,
          size: Vector2(350, 150),
          position: Vector2(0, 0),
        )
      ],
    );

    world.addAll([
      settingsButton,
      userEmailComponent,
      ecoCreditsComponent,
      whiteRectComponent,
      globalAirQualityComponent,
    ]);

    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(gameUserControllerProvider, (previous, userStatus) {
          if (userStatus.hasValue) {
            user = userStatus.value;
            updateMenu();
          }
        }));
    super.onMount();

    AsyncValue<GameUser?> userStatus = ref.read(gameUserControllerProvider);
    if (userStatus.hasValue) user = userStatus.value;
    updateGlobalAirQuality();
    updateMenu();
  }

  void updateMenu() {
    if (user == null) {
      if (playButton.isMounted) world.remove(playButton);
      if (achievementsButton.isMounted) world.remove(achievementsButton);
      if (oraganizeEventButton.isMounted) world.remove(oraganizeEventButton);
      if (viewEventsButton.isMounted) world.remove(viewEventsButton);
      if (viewMyEventsButton.isMounted) world.remove(viewMyEventsButton);
      if (validateParticipationButton.isMounted) world.remove(validateParticipationButton);
      if (ecoCreditsComponent.isMounted) world.remove(ecoCreditsComponent);
      userEmailComponent.text = '';
    } else {
      ecoCreditsComponent.text = "${user!.ecoCredits} EcoCredits";
      userEmailComponent.text = user!.email ?? 'Local User';

      world.add(playButton);
      world.add(achievementsButton);
      world.add(oraganizeEventButton);
      world.add(viewEventsButton);
      world.add(viewMyEventsButton);
      world.add(validateParticipationButton);
      world.add(ecoCreditsComponent);

      if (user!.isLocal) {
        world.add(connectButton);
        if (disconnectButton.isMounted) world.remove(disconnectButton);
      } else {
        if (connectButton.isMounted) world.remove(connectButton);
        world.add(disconnectButton);
      }
    }
  }

  Future<void> updateGlobalAirQuality() async {
    if (game.globalAirQualityString == "") {
      await game.getGlobalAirQuality();
    }
    globalAirQualityTextComponent.text = "Universal AQI: ${game.globalAirQualityValue}/100\n\nWorld air quality: ${game.globalAirQualityString}";
    globalAirQualityComponent.paint = Paint()..color = convertGlobalAirQualityColor(game.globalAirQualityColor);
  }
}
