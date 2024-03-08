import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:mgame/flame_game/utils/palette.dart';

class Dots extends PositionComponent {
  List<RectangleComponent> listDots = [];

  @override
  FutureOr<void> onLoad() {
    listDots.add(
      RectangleComponent.square(
        size: 4,
        paint: Paint()..color = Palette.darkGrey,
        position: Vector2(0, 0),
      ),
    );
    listDots.add(
      RectangleComponent.square(
        size: 4,
        paint: Paint()..color = Palette.darkGrey,
        position: Vector2(10, 0),
      ),
    );
    listDots.add(
      RectangleComponent.square(
        size: 4,
        paint: Paint()..color = Palette.darkGrey,
        position: Vector2(20, 0),
      ),
    );

    addAll([
      listDots[0],
      listDots[1],
      listDots[2],
    ]);
    return super.onLoad();
  }

  double delay = 0.3;
  double waitTime = 1;
  List<double> timeElapsed = [0, 0, 0];
  List<bool> isGoingUp = [true, true, true];
  List<bool> isMoving = [false, false, false];
  List<bool> isFirstMove = [true, true, true];

  @override
  void update(double dt) {
    for (int i = 0; i < 3; i++) {
      if (timeElapsed[i] < delay && isGoingUp[i] && isMoving[i]) {
        timeElapsed[i] += dt;
        listDots[i].position.y -= dt * 10;
      }
      if (timeElapsed[i] >= delay && isGoingUp[i] && isMoving[i]) {
        timeElapsed[i] = 0;
        isGoingUp[i] = false;
        listDots[i].position.y = -5;
      }

      if (timeElapsed[i] < delay && !isGoingUp[i] && isMoving[i]) {
        timeElapsed[i] += dt;
        listDots[i].position.y += dt * 10;
      }
      if (timeElapsed[i] >= delay && !isGoingUp[i] && isMoving[i]) {
        timeElapsed[i] = 0;
        isGoingUp[i] = true;
        listDots[i].position.y = 0;
        isMoving[i] = false;
      }
      if (!isMoving[i]) {
        timeElapsed[i] += dt;
        if (isFirstMove[i]) {
          if (timeElapsed[i] >= delay * i) {
            timeElapsed[i] = 0;
            isMoving[i] = true;
            isFirstMove[i] = false;
          }
        } else {
          if (timeElapsed[i] >= waitTime) {
            timeElapsed[i] = 0;
            isMoving[i] = true;
          }
        }
      }
    }

    super.update(dt);
  }
}
