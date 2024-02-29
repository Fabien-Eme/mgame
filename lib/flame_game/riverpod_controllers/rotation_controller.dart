import 'dart:math' as math;

import 'package:mgame/flame_game/ui/ui_rotate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rotation_controller.g.dart';

@Riverpod(keepAlive: true)
class RotationController extends _$RotationController {
  @override
  Rotation build() {
    return Rotation.zero;
  }

  void rotateLeft() {
    if (state == Rotation.zero) {
      state = Rotation.piAndHalf;
    } else if (state == Rotation.halfPi) {
      state = Rotation.zero;
    } else if (state == Rotation.pi) {
      state = Rotation.halfPi;
    } else if (state == Rotation.piAndHalf) {
      state = Rotation.pi;
    }
  }

  void rotateRight() {
    if (state == Rotation.zero) {
      state = Rotation.halfPi;
    } else if (state == Rotation.halfPi) {
      state = Rotation.pi;
    } else if (state == Rotation.pi) {
      state = Rotation.piAndHalf;
    } else if (state == Rotation.piAndHalf) {
      state = Rotation.zero;
    }
  }

  void rotate(RotateDirection rotateDirection) {
    if (rotateDirection == RotateDirection.left) {
      rotateLeft();
    } else if (rotateDirection == RotateDirection.right) {
      rotateRight();
    }
  }
}

enum Rotation {
  zero,
  halfPi,
  pi,
  piAndHalf;

  double get angle {
    switch (this) {
      case Rotation.zero:
        return 0;
      case Rotation.halfPi:
        return math.pi / 2;
      case Rotation.pi:
        return math.pi;
      case Rotation.piAndHalf:
        return 3 / 2 * math.pi;
    }
  }
}
