import 'package:flame/game.dart';

import 'route_can_ignore_events.dart';

class RouteMakeOtherIgnoreEvents extends Route {
  bool doesPutGameInPause;
  RouteMakeOtherIgnoreEvents(super.builder, {this.doesPutGameInPause = true, super.transparent, super.maintainState = false});

  @override
  void onPush(Route? previousRoute) {
    if (previousRoute.runtimeType == RouteCanIgnoreEvents) {
      (previousRoute as RouteCanIgnoreEvents?)?.ignoreEvents = true;
    }
    if (doesPutGameInPause) previousRoute?.stopTime();
    super.onPush(previousRoute);
  }

  @override
  void onPop(Route nextRoute) {
    if (nextRoute.runtimeType == RouteCanIgnoreEvents) {
      (nextRoute as RouteCanIgnoreEvents).ignoreEvents = false;
    }
    if (doesPutGameInPause) nextRoute.resumeTime();
    super.onPop(nextRoute);
  }
}
