import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../style/font_family.dart';
import '../style/palette.dart';

class AnimatedNarrative extends ConsumerStatefulWidget {
  const AnimatedNarrative(
      {required this.textLines,
      required this.previousTextLines,
      this.initialDelayTime = const Duration(milliseconds: 0),
      this.itemFadeTime = const Duration(milliseconds: 1500),
      this.staggerTime = const Duration(milliseconds: 2000),
      this.onAnimationEnd,
      super.key});

  final List<String>? textLines;
  final List<String>? previousTextLines;
  final Duration initialDelayTime;
  final Duration itemFadeTime;
  final Duration staggerTime;
  final Function? onAnimationEnd;

  @override
  ConsumerState<AnimatedNarrative> createState() => _AnimatedNarrativeState();
}

class _AnimatedNarrativeState extends ConsumerState<AnimatedNarrative> with TickerProviderStateMixin {
  late final List<String>? _textLines = widget.textLines;
  late final List<String>? _previousTextLines = widget.previousTextLines;

  late final _initialDelayTime = widget.initialDelayTime;
  late final _itemFadeTime = widget.itemFadeTime;
  late final _staggerTime = widget.staggerTime;
  late final _onAnimationEnd = widget.onAnimationEnd;

  bool hasPreviousTextLinesFadeOut = false;

  @override
  Widget build(BuildContext context) {
    final Palette palette = ref.watch(paletteProvider);

    List<Widget> buildListItems() {
      final listItems = <Widget>[];
      final List<String> textToDisplay = (_previousTextLines != null && !hasPreviousTextLinesFadeOut) ? _previousTextLines : _textLines!;
      for (var i = 0; i < textToDisplay.length; ++i) {
        final double padding = (i == textToDisplay.length - 1) ? 0 : 8;

        final Widget currentTextLine = Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Text(
            textToDisplay[i],
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: fontFamily,
              color: palette.textWhite,
              fontSize: 40,
              height: 1,
            ),
          ),
        );

        if (_previousTextLines != null && !hasPreviousTextLinesFadeOut) {
          listItems.add(
            Animate(
              key: ValueKey(textToDisplay[i]),
              delay: _initialDelayTime,
              effects: [FadeEffect(begin: 1, end: 0, duration: _itemFadeTime)],
              onComplete: (_) {
                if (i == (textToDisplay.length - 1)) {
                  if (_textLines != null) {
                    setState(() {
                      hasPreviousTextLinesFadeOut = true;
                    });
                  } else {
                    _onAnimationEnd?.call();
                  }
                }
              },
              child: currentTextLine,
            ),
          );
        } else {
          listItems.add(
            Animate(
              key: ValueKey(textToDisplay[i]),
              delay: _initialDelayTime + (_itemFadeTime + _staggerTime) * i,
              effects: [FadeEffect(begin: 0, end: 1, duration: _itemFadeTime, curve: Curves.easeInQuart)],
              onComplete: (_) {
                if (i == (textToDisplay.length - 1)) {
                  Future.delayed(_staggerTime).then((_) => _onAnimationEnd?.call());
                }
              },
              child: currentTextLine,
            ),
          );
        }
      }
      return listItems;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildListItems(),
      ],
    );
  }
}
