import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/narrative/narrative_text.dart';

part 'narrative.freezed.dart';

@freezed
class Narrative with _$Narrative {
  const Narrative._();

  factory Narrative({
    required String title,
    required Map<String, dynamic> text,
    required int textIndex,
    required bool isOver,
    required bool hasFinishedNarrative,
    required bool autoPlay,
  }) = _Narrative;

  factory Narrative.byTitle({required String title, int textIndex = 1}) {
    Map<String, dynamic> text = narrativeText[title]["text"] as Map<String, dynamic>? ?? {};

    final bool isOver = (text.length <= textIndex) ? true : false;
    final bool hasFinishedNarrative = (text.length < textIndex) ? true : false;

    final bool autoPlay = narrativeText[title]["autoPlay"] as bool;

    return Narrative(title: title, text: text, textIndex: textIndex, isOver: isOver, hasFinishedNarrative: hasFinishedNarrative, autoPlay: autoPlay);
  }

  Narrative forward(Narrative narrative) {
    return Narrative.byTitle(title: narrative.title, textIndex: narrative.textIndex + 1);
  }
}
