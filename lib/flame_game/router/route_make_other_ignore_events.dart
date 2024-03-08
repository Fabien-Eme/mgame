import 'package:flame/game.dart';

import 'route_can_ignore_events.dart';

class RouteMakeOtherIgnoreEvents extends Route {
  bool doesPutGameInPause;
  RouteMakeOtherIgnoreEvents(super.builder, {this.doesPutGameInPause = true, super.transparent, super.maintainState});

  @override
  void onPush(Route? previousRoute) {
    (previousRoute as RouteCanIgnoreEvents?)?.ignoreEvents = true;
    if (doesPutGameInPause) previousRoute?.stopTime();
    super.onPush(previousRoute);
  }

  @override
  void onPop(Route nextRoute) {
    (nextRoute as RouteCanIgnoreEvents).ignoreEvents = false;
    if (doesPutGameInPause) nextRoute.resumeTime();
    super.onPop(nextRoute);
  }
}
