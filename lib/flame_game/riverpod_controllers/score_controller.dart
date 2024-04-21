import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_controller.g.dart';

const baseScore = 3;

@Riverpod(keepAlive: true)
class ScoreController extends _$ScoreController {
  bool _hasACityGeneratedPollution = false;
  bool _hasPollutionGoneOverTreshold = false;

  @override
  int build() {
    return baseScore;
  }

  void changeScore(int amount) {
    state = (state + amount).clamp(0, 3);
  }

  bool cityHasGeneratedPollution() {
    if (!_hasACityGeneratedPollution) {
      _hasACityGeneratedPollution = true;
      changeScore(-1);
      return true;
    }
    return false;
  }

  bool pollutionHasGoneOverTreshold() {
    if (!_hasPollutionGoneOverTreshold) {
      _hasPollutionGoneOverTreshold = true;
      changeScore(-1);
      return true;
    }
    return false;
  }

  void reInitializeScore() {
    state = baseScore;
    _hasACityGeneratedPollution = false;
    _hasPollutionGoneOverTreshold = false;
  }
}
