import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mgame/flame_game/menu/dialog_button.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';
import 'package:mgame/flame_game/utils/palette.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  late final DialogButton playButton;
  late final DialogButton settingsButton;
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

  bool isLevelLoading = false;

  User? user;

  @override
  FutureOr<void> onLoad() {
    add(world = World());

    add(cameraComponent = CameraComponent.withFixedResolution(
      width: MGame.gameWidth,
      height: MGame.gameHeight,
      world: world,
    ));

    playButton = DialogButton(
      text: 'Play',
      buttonSize: Vector2(100, 50),
      onPressed: () async {
        if (!isLevelLoading) {
          isLevelLoading = true;

          final doc = await FirebaseFirestore.instance.collection('users').doc(user?.email).get();
          Map<String, dynamic>? docData = doc.data();
          isLevelLoading = false;

          int lastLevelCompleted = 0;
          if (docData != null) {
            lastLevelCompleted = docData['lastLevelCompleted'] as int;
          } else {
            lastLevelCompleted = 0;
          }
          game.lastLevelCompleted = lastLevelCompleted;
          game.currentLevel = lastLevelCompleted + 1;

          game.router.pushNamed('level${lastLevelCompleted + 1}');
        }
        isLevelLoading = false;
      },
      position: Vector2(0, -200),
    );

    connectButton = DialogButton(
      text: 'Login / Sign Up',
      buttonSize: Vector2(250, 50),
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('signInUp');
      },
      position: Vector2(0, -200),
    );

    settingsButton = DialogButton(
      text: 'Settings',
      onPressed: () {
        game.router.pushNamed('menuSettings');
      },
      buttonSize: Vector2(150, 50),
      position: Vector2(0, 150),
    );

    achievementsButton = DialogButton(
      text: 'Achievements',
      onPressed: () {
        game.router.pushNamed('menuAchievements');
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(0, -100),
    );

    oraganizeEventButton = DialogButton(
      text: 'Organize IRL Event',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('organizeEvent');
      },
      buttonSize: Vector2(275, 50),
      position: Vector2(-175, -12.5),
    );

    viewEventsButton = DialogButton(
      text: 'View all IRL Events',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('viewEvents');
      },
      buttonSize: Vector2(275, 50),
      position: Vector2(-175, 67.5),
    );

    viewMyEventsButton = DialogButton(
      text: 'My Events',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('viewMyEvents');
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(175, -12.5),
    );

    validateParticipationButton = DialogButton(
      text: 'Validate Participation',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('validateParticipation');
      },
      buttonSize: Vector2(225, 75),
      position: Vector2(175, 67.5),
    );

    disconnectButton = DialogButton(
      text: 'Disconnect',
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      buttonSize: Vector2(225, 50),
      position: Vector2(0, 350),
    );

    userEmailComponent = TextComponent(
      text: "",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(0, 250),
    );

    ecoCreditsComponent = TextComponent(
      text: "- EcoCredits",
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(0, 285),
    );

    final whiteRectComponent = RectangleComponent.fromRect(
      const Rect.fromLTWH(MGame.gameWidth / 2 - 355, -MGame.gameHeight / 2 + 95, 310, 110),
      paint: Paint()..color = Colors.white,
    );

    globalAirQualityComponent = RectangleComponent.fromRect(
      const Rect.fromLTWH(MGame.gameWidth / 2 - 350, -MGame.gameHeight / 2 + 100, 300, 100),
      children: [
        TextBoxComponent(
          text: "",
          textRenderer: MyTextStyle.airInfo,
          size: Vector2(300, 150),
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
    addToGameWidgetBuild(() => ref.listen(userControllerProvider, (previous, userStatus) {
          user = userStatus;

          updateMenu();
        }));
    super.onMount();
    user = ref.read(userControllerProvider);
    updateGlobalAirQuality();
    updateMenu();
  }

  void updateMenu() {
    if (user == null) {
      if (playButton.isMounted) world.remove(playButton);
      if (disconnectButton.isMounted) world.remove(disconnectButton);
      if (achievementsButton.isMounted) world.remove(achievementsButton);
      if (oraganizeEventButton.isMounted) world.remove(oraganizeEventButton);
      if (viewEventsButton.isMounted) world.remove(viewEventsButton);
      if (viewMyEventsButton.isMounted) world.remove(viewMyEventsButton);
      if (validateParticipationButton.isMounted) world.remove(validateParticipationButton);
      userEmailComponent.text = '';

      world.add(connectButton);
    } else {
      if (connectButton.isMounted) world.remove(connectButton);
      getEcoCreditsCount();

      userEmailComponent.text = user!.email ?? "";
      world.add(playButton);
      world.add(disconnectButton);
      world.add(achievementsButton);
      world.add(oraganizeEventButton);
      world.add(viewEventsButton);
      world.add(viewMyEventsButton);
      world.add(validateParticipationButton);
    }
  }

  Future<void> getEcoCreditsCount() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.email).get();
    final map = doc.data();
    final count = map?['EcoCredits'] ?? 0;
    ecoCreditsComponent.text = "$count EcoCredits";

    FirebaseFirestore.instance.collection('users').doc(user!.email).snapshots().listen((event) {
      final currentCount = event.data()?['EcoCredits'];
      if (currentCount != null) ecoCreditsComponent.text = "$currentCount EcoCredits";
    });
  }

  Future<void> updateGlobalAirQuality() async {
    if (game.globalAirQualityString == "") {
      await game.getGlobalAirQuality();
      (globalAirQualityComponent.children.first as TextComponent).text = "Universal AQI: ${game.globalAirQualityValue}/100\n\nWorld air quality: ${game.globalAirQualityString}";
      globalAirQualityComponent.paint = Paint()..color = convertGlobalAirQualityColor(game.globalAirQualityColor);
    }
  }
}
