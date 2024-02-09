import 'dart:io';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'game.dart';

final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey = GlobalKey<RiverpodAwareGameWidgetState>();

class FlameGameWidget extends StatelessWidget {
  const FlameGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
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

    MGame game = MGame(
      isMobile: isMobile,
      isDesktop: !isMobile,
    );

    return RawGestureDetector(
      gestures: {
        PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          () => PanGestureRecognizer(
            debugOwner: this,
            allowedButtonsFilter: (int buttons) => buttons & kSecondaryButton != 0,
          ),
          (PanGestureRecognizer instance) {
            instance
              ..dragStartBehavior = DragStartBehavior.down
              ..onStart = (DragStartDetails details) {}
              ..onUpdate = (DragUpdateDetails details) {
                game.onSecondaryButtonDragUpdate(details);
              }
              ..onEnd = (DragEndDetails details) {};
          },
        ),
      },
      child: RiverpodAwareGameWidget(
        key: gameWidgetKey,
        game: game,
      ),
    );
  }
}
