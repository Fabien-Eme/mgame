import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../dialog/tutorial.dart';
import '../level.dart';
import '../menu/briefing.dart';
import '../menu/main_menu.dart';
import '../menu/menu_achievement.dart';
import '../menu/menu_city.dart';
import '../menu/menu_game_won.dart';
import '../menu/menu_garage/menu_garage.dart';
import '../menu/menu_incinerator.dart';
import '../menu/menu_level_lost.dart';
import '../menu/menu_level_won.dart';
import '../menu/menu_select_level.dart';
import '../menu/menu_settings.dart';
import '../menu/root.dart';
import 'route_can_ignore_events.dart';
import 'route_make_other_ignore_events.dart';

class GameRouter extends RouterComponent {
  GameRouter()
      : super(
          initialRoute: 'root',
          routes: {
            'root': RouteCanIgnoreEvents(Root.new),

            ///
            'mainMenu': RouteCanIgnoreEvents(MainMenu.new, transparent: true),
            'menuSettings': RouteMakeOtherIgnoreEvents(MenuSettings.new, transparent: true),
            'menuAchievements': RouteMakeOtherIgnoreEvents(MenuAchievement.new, transparent: true),
            'menuSelectLevel': RouteMakeOtherIgnoreEvents(MenuSelectLevel.new, transparent: true),

            ///
            'levelBackground': RouteIgnoreEvents(() => Level(level: 0, key: ComponentKey.named('level'))),
            'level1': RouteCanIgnoreEvents(() => Level(level: 1, key: ComponentKey.named('level'))),
            'level2': RouteCanIgnoreEvents(() => Level(level: 2, key: ComponentKey.named('level'))),
            'level3': RouteCanIgnoreEvents(() => Level(level: 3, key: ComponentKey.named('level'))),

            ///
            'levelWon': RouteMakeOtherIgnoreEvents(MenuLevelWon.new, transparent: true),
            'gameWon': RouteMakeOtherIgnoreEvents(MenuGameWon.new, transparent: true),
            'levelLost': RouteMakeOtherIgnoreEvents(MenuLevelLost.new, transparent: true),
            'tutorial': RouteMakeOtherIgnoreEvents(Tutorial.new, transparent: true),
            'briefing': RouteMakeOtherIgnoreEvents(Briefing.new, transparent: true),

            ///
            'menuGarage': RouteMakeOtherIgnoreEvents(MenuGarage.new, doesPutGameInPause: false, transparent: true),
            'menuCity': RouteMakeOtherIgnoreEvents(MenuCity.new, doesPutGameInPause: false, transparent: true),
            'menuIncinerator': RouteMakeOtherIgnoreEvents(MenuIncinerator.new, doesPutGameInPause: false, transparent: true),
          },
        );
}
