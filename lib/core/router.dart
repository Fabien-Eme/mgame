import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/flame_game/flame_game_widget.dart';
import 'package:mgame/style/page_transition.dart';
import '../main_menu/main_menu_screen.dart';
import '../narrative/narrative_screen.dart';
import '../settings/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  initialLocation: '/game',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
        path: '/mainMenu',
        pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('mainMenu'),
              child: MainMenuScreen(),
            )),
    GoRoute(
        path: '/game',
        pageBuilder: (context, state) => CustomFadeTransitionPage(
              key: const ValueKey('game'),
              child: const FlameGameWidget(),
            )),
    GoRoute(
        path: '/narrative',
        pageBuilder: (context, state) => IntroNarrativeFadeTransitionPage(
              key: const ValueKey('narrative'),
              child: const NarrativeScreen(),
            )),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        final bool isFromGame = state.extra as bool? ?? false;
        return CustomFadeTransitionPage(
          key: const ValueKey('settings'),
          child: SettingsScreen(isFromGame: isFromGame),
        );
      },
    ),
  ],
);
