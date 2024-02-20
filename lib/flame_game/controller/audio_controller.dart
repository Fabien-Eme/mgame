import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class AudioController extends Component with HasGameReference<MGame> {
  void playClickButton() {
    FlameAudio.play(Assets.sfx.button, volume: game.soundVolume);
  }

  void playClickButtonBack() {
    FlameAudio.play(Assets.sfx.buttonBack, volume: game.soundVolume);
  }
}
