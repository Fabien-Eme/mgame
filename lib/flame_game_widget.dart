import 'dart:io';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/overlays/organize_event.dart';
import 'package:mgame/overlays/overlay_sign_in_up.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';
import 'package:mgame/overlays/view_events.dart';

import 'flame_game/game.dart';
import 'overlays/validate_participation.dart';
import 'overlays/view_my_events.dart';

final GlobalKey<RiverpodAwareGameWidgetState<MGame>> gameWidgetKey = GlobalKey<RiverpodAwareGameWidgetState<MGame>>();

class FlameGameWidget extends ConsumerWidget {
  const FlameGameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMobile = false;
    bool isWeb = false;

    if (kIsWeb) {
      isWeb = true;
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
      isWeb: isWeb,
    );

    /// Make sure the provider will be mounted in first build of Flame Components
    ref.read(userControllerProvider);

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
      child: RiverpodAwareGameWidget<MGame>(
        key: gameWidgetKey,
        game: game,
        overlayBuilderMap: const {
          'signInUp': overlaySignInUp,
          'organizeEvent': organizeEvent,
          'viewEvents': viewEvents,
          'viewMyEvents': viewMyEvents,
          'validateParticipation': validateParticipation,
        },
      ),
    );
  }
}
