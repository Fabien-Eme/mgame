import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mgame/flame_game/menu/dialog_button.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<MGame>, RiverpodComponentMixin {
  late final World world;
  late final CameraComponent cameraComponent;

  late final DialogButton playButton;
  late final DialogButton settingsButton;
  late final DialogButton achievementsButton;
  late final DialogButton oraganizeEventButton;
  late final DialogButton viewEventsbutton;

  late final DialogButton connectButton;
  late final DialogButton disconnectButton;

  late final TextComponent userEmailComponent;

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
      position: Vector2(0, -150),
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
      position: Vector2(0, -50),
    );

    oraganizeEventButton = DialogButton(
      text: 'Organize IRL Event',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('organizeEvent');
      },
      buttonSize: Vector2(275, 50),
      position: Vector2(-175, 50),
    );

    viewEventsbutton = DialogButton(
      text: 'View IRL Events',
      onPressed: () {
        game.mouseCursor = SystemMouseCursors.basic;
        game.overlays.add('viewEvents');
      },
      buttonSize: Vector2(250, 50),
      position: Vector2(175, 50),
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
      position: Vector2(0, 290),
    );

    world.addAll([
      settingsButton,
      userEmailComponent,
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
    updateMenu();
  }

  void updateMenu() {
    if (user == null) {
      if (playButton.isMounted) world.remove(playButton);
      if (disconnectButton.isMounted) world.remove(disconnectButton);
      if (achievementsButton.isMounted) world.remove(achievementsButton);
      userEmailComponent.text = '';

      world.add(connectButton);
    } else {
      if (connectButton.isMounted) world.remove(connectButton);

      userEmailComponent.text = user!.email ?? "";
      world.add(playButton);
      world.add(disconnectButton);
      world.add(achievementsButton);
      world.add(oraganizeEventButton);
      world.add(viewEventsbutton);
    }
  }
}
