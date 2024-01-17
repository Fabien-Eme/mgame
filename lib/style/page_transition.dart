import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCustomFadeTransitionPage extends CustomTransitionPage<void> {
  MyCustomFadeTransitionPage({super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class IntroNarrativeFadeTransitionPage extends CustomTransitionPage<void> {
  IntroNarrativeFadeTransitionPage({super.key, required super.child})
      : super(
          transitionDuration: const Duration(seconds: 2),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class MyCustomScaleTransitionPage extends CustomTransitionPage<void> {
  MyCustomScaleTransitionPage({super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
            child: child,
          ),
        );
}
