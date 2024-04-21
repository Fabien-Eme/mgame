import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';

import 'custom_ninetilebox.dart';

/// This class is a thin wrapper on top of [NineTileBox] as a component.
class CustomNineTileBoxComponent extends PositionComponent implements SizeProvider {
  CustomNineTileBox? nineTileBox;

  /// Takes the [NineTileBox] instance to render a box that can grow and shrink
  /// seamlessly.
  ///
  /// It uses the x, y, width and height coordinates from the
  /// [PositionComponent] to render.
  CustomNineTileBoxComponent({
    this.nineTileBox,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
  });

  void changeOpacity(double opacity) {
    nineTileBox!.opacity = opacity;
  }

  @override
  @mustCallSuper
  void onMount() {
    assert(
      nineTileBox != null,
      'The nineTileBox should be set either in the constructor or in onLoad',
    );
  }

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    nineTileBox?.drawRect(canvas, size.toRect());
  }
}
