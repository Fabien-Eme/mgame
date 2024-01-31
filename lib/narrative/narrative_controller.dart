import 'package:mgame/narrative/narrative.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'narrative_controller.g.dart';

@Riverpod(keepAlive: true)
class NarrativeController extends _$NarrativeController {
  @override
  Narrative? build() {
    return null;
  }

  void load({required String title}) {
    state = Narrative.byTitle(title: title);
  }

  void forward() {
    if (state != null && state?.hasFinishedNarrative == false) {
      state = state!.forward(state!);
    }
  }

  void reset() {
    if (state != null) {
      state = Narrative.byTitle(title: state!.title);
    }
  }
}
