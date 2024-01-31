import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';

import 'game.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameBloc(),
          key: UniqueKey(),
        ),
      ],
      child: Builder(builder: (context) {
        MGame game = MGame(
          isMobile: isMobile,
          isDesktop: !isMobile,
          gameBloc: context.read<GameBloc>(),
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
          child: GameWidget(
            game: game,
          ),
        );
      }),
    );
  }
}
