import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../game.dart';

class AudioController extends Component with HasGameReference<MGame> {
  void playClickButton() {
    if (game.isAudioEnabled) FlameAudio.play('button.mp3');
  }

  void playClickButtonBack() {
    if (game.isAudioEnabled) FlameAudio.play('button_back.mp3');
  }
}
