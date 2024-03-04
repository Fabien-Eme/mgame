import 'package:flame/game.dart';

import 'route_can_ignore_events.dart';

class RouteMakeOtherIgnoreEvents extends Route {
  RouteMakeOtherIgnoreEvents(super.builder, {super.transparent, super.maintainState});

  @override
  void onPush(Route? previousRoute) {
    (previousRoute as RouteCanIgnoreEvents?)?.ignoreEvents = true;
    super.onPush(previousRoute);
  }

  @override
  void onPop(Route nextRoute) {
    (nextRoute as RouteCanIgnoreEvents).ignoreEvents = false;
    super.onPop(nextRoute);
  }
}
