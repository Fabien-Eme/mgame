import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/game_session/game_screen.dart';
import 'package:mgame/style/page_transition.dart';
import '../main_menu/main_menu_screen.dart';
import '../narrative/intro_narrative_screen.dart';
import '../settings/settings_screen.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(),
      routes: [
        GoRoute(
            path: 'game',
            pageBuilder: (context, state) => const NoTransitionPage(
                  key: ValueKey('game'),
                  child: GameScreen(),
                )),
        GoRoute(
            path: 'introNarrative',
            pageBuilder: (context, state) => IntroNarrativeFadeTransitionPage(
                  key: const ValueKey('introNarrative'),
                  child: const IntroNarrativeScreen(),
                )),
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) {
            final bool isFromGame = state.extra as bool? ?? false;
            return MyCustomFadeTransitionPage(
              key: const ValueKey('settings'),
              child: SettingsScreen(isFromGame: isFromGame),
            );
          },
        ),
      ],
    ),
  ],
);
