import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgame/flame_game/flame_game_widget.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  initialLocation: '/game',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
        path: '/game',
        pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('game'),
              child: FlameGameWidget(),
            )),
  ],
);
