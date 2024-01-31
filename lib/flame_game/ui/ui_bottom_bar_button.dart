import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class UIBottomBarButton extends SpriteButtonComponent with HasGameRef<MGame> {
  UIBottomBarButton({required this.buttonType, required super.size, super.position});

  ButtonType buttonType;

  @override
  Future<void> onLoad() async {
    button = Sprite(game.images.fromCache(Assets.images.ui.uiButton.path));
    buttonDown = Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressed.path));

    add(SpriteComponent(sprite: Sprite(game.images.fromCache(buttonType.path)), paint: Paint()..filterQuality = FilterQuality.low, position: size / 2, anchor: Anchor.center));
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent _) {
    buttonType.function(game.gameBloc);
    super.onTapDown(_);
  }
}

enum ButtonType {
  road,
  trash;

  String get path {
    return switch (this) {
      ButtonType.road => Assets.images.ui.uiRoad.path,
      ButtonType.trash => Assets.images.ui.uiTrash.path,
    };
  }

  Function get function {
    return switch (this) {
      ButtonType.road => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(buildingType: BuildingType.road));
        },
      ButtonType.trash => (GameBloc gameBloc) {
          gameBloc.add(const DestructionModePressed());
        },
    };
  }
}
