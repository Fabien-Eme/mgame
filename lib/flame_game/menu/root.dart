import 'package:flame/components.dart';

import '../game.dart';

class Root extends Component with HasGameReference<MGame> {
  @override
  void onLoad() {
    super.onLoad();
    game.router.pushNamed('levelBackground');
    game.router.pushNamed('mainMenu');
  }
}
