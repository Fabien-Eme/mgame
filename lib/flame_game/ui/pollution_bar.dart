import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/progress_bar.dart';

import '../game.dart';

class PollutionBar extends ProgressBar {
  PollutionBar({
    super.progressBarType = ProgressBarType.pollution,
    required super.totalBarValue,
    required super.title,
    super.onComplete,
    super.isHidden,
  }) : super(key: ComponentKey.named('pollutionBar'));

  @override
  FutureOr<void> onLoad() {
    position = Vector2(MGame.gameWidth / 2 + 400, 32);
    return super.onLoad();
  }
}
