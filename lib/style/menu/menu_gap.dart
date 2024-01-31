import 'package:flutter/material.dart';

class MenuVerticalGap extends StatelessWidget {
  const MenuVerticalGap({required this.maxHeight, super.key});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight * 0.03,
    );
  }
}

class MenuVerticalGapLarge extends StatelessWidget {
  const MenuVerticalGapLarge({required this.maxHeight, super.key});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight * 0.05,
    );
  }
}
