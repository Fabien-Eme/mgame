import 'package:flame/components.dart';
import 'package:flame/game.dart';

class RouteCanIgnoreEvents extends Route with IgnoreEvents {
  RouteCanIgnoreEvents(super.builder, {super.transparent, super.maintainState = false}) {
    ignoreEvents = false;
  }
}

class RouteIgnoreEvents extends Route with IgnoreEvents {
  RouteIgnoreEvents(super.builder, {super.transparent, super.maintainState = false});
}
