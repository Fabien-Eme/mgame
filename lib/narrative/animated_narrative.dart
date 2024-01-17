import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../style/font_family.dart';
import '../style/palette.dart';

class AnimatedNarrative extends ConsumerStatefulWidget {
  const AnimatedNarrative(
      {required this.textLines,
      this.initialDelayTime = const Duration(milliseconds: 0),
      this.itemFadeTime = const Duration(milliseconds: 1500),
      this.staggerTime = const Duration(milliseconds: 1500),
      super.key});

  final List<String> textLines;
  final Duration initialDelayTime;
  final Duration itemFadeTime;
  final Duration staggerTime;

  @override
  ConsumerState<AnimatedNarrative> createState() => _IntroDialogState();
}

class _IntroDialogState extends ConsumerState<AnimatedNarrative> with TickerProviderStateMixin {
  late final List<String> _textLines = widget.textLines;

  late final _initialDelayTime = widget.initialDelayTime;
  late final _itemFadeTime = widget.itemFadeTime;
  late final _staggerTime = widget.staggerTime;

  late final _animationDuration = _initialDelayTime + (_itemFadeTime * _textLines.length) + (_staggerTime * _textLines.length);

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _textLines.length; ++i) {
      final startTime = _initialDelayTime + ((_itemFadeTime + _staggerTime) * i);
      final endTime = startTime + _itemFadeTime;

      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = ref.watch(paletteProvider);

    List<Widget> buildListItems() {
      final listItems = <Widget>[];
      for (var i = 0; i < _textLines.length; ++i) {
        final double padding = (i == _textLines.length - 1) ? 0 : 8;
        listItems.add(
          AnimatedBuilder(
            animation: _staggeredController,
            builder: (context, child) {
              final animationPercent = Curves.easeInQuart.transform(
                _itemSlideIntervals[i].transform(_staggeredController.value),
              );
              return Opacity(
                opacity: animationPercent,
                child: child,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: padding),
              child: Text(
                _textLines[i],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: fontFamily,
                  color: palette.textWhite,
                  fontSize: 40,
                  height: 1,
                ),
              ),
            ),
          ),
        );
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

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }
}
