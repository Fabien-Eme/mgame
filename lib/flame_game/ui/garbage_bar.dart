import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/progress_bar.dart';

import '../game.dart';

class GarbageBar extends ProgressBar {
  GarbageBar({
    super.progressBarType = ProgressBarType.garbageProcessed,
    required super.totalBarValue,
    required super.title,
    super.onComplete,
  }) : super(key: ComponentKey.named('garbageBar'));

  @override
  FutureOr<void> onLoad() {
    position = Vector2(MGame.gameWidth / 2 - 400, 32);
    return super.onLoad();
  }
}
