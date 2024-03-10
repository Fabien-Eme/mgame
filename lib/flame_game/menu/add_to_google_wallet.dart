import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/gen/assets.gen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../game.dart';

class AddToGoogleWallet extends SpriteComponent with HasGameReference<MGame>, TapCallbacks, HoverCallbacks {
  String achievementName;
  String userMail;
  AddToGoogleWallet({required this.achievementName, required this.userMail, super.position});

  bool isCallingCloud = false;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(Assets.images.ui.addToGoogleWalletButton.path));
    paint = Paint()..filterQuality = FilterQuality.low;
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) async {
    String response = "";
    if (!isCallingCloud) {
      isCallingCloud = true;
      String userName = userMail.replaceAll(RegExp('[^A-Za-z0-9]'), '');

      final url = Uri.https('us-west1-mgame-8c88b.cloudfunctions.net', 'createAchievementPass');
      final res = await http.post(url, body: {'objectSuffix': achievementName, 'userName': userName});
      response = res.body;
    }
    isCallingCloud = false;
    if (response.isNotEmpty) launch(response);
    super.onTapDown(event);
  }

  void launch(String url) {
    final Uri uri = Uri.parse(url);
    launchUrl(uri);
  }

  @override
  void onHoverEnter() {
    game.myMouseCursor.hoverEnterButton();
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.myMouseCursor.hoverExitButton();
    super.onHoverExit();
  }
}
