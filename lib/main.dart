import 'dart:io';
// import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/flame_game/flame_game_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // html.window.document.onContextMenu.listen((evt) => evt.preventDefault());

  bool isMobile = false;

  if (kIsWeb) {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      isMobile = true;
    }
  } else {
    if (Platform.isAndroid || Platform.isIOS) {
      isMobile = true;
    }
  }
  if (isMobile) {
    WakelockPlus.enable();
  }
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to landscape mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const ProviderScope(child: FlameGameWidget()));
}
