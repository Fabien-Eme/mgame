import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';

class Root extends Component with HasGameReference<MGame> {
  @override
  FutureOr<void> onLoad() {
    game.router.pushNamed('levelBackground');
    game.router.pushNamed('mainMenu');
    return super.onLoad();
  }
}
