import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class UIBottomBarButton extends SpriteButtonComponent with HasGameRef<MGame> {
  UIBottomBarButton({required this.buttonType, required super.size, super.position});

  ButtonType buttonType;

  bool isActive = false;

  @override
  Future<void> onLoad() async {
    button = getButtonSprite(false);
    buttonDown = getButtonSprite(true);

    await add(
      FlameBlocListener<GameBloc, GameState>(onNewState: _handleNewGameState),
    );

    await add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache(buttonType.path)),
        paint: Paint()..filterQuality = FilterQuality.low,
        position: size / 2,
        anchor: Anchor.center,
      ),
    );
    return super.onLoad();
  }

  void updateButtonsSprite() {
    button = getButtonSprite(false);
    buttonDown = getButtonSprite(true);
    sprites = {
      ButtonState.up: button!,
      ButtonState.down: buttonDown!,
    };
  }

  Sprite getButtonSprite(bool isForButtonDown) {
    if (isActive) {
      if (buttonType == ButtonType.trash) {
        return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedRed.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonRed.path));
      } else {
        return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedGreen.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonGreen.path));
      }
    } else {
      return (isForButtonDown == true) ? Sprite(game.images.fromCache(Assets.images.ui.uiButtonPressedWhite.path)) : Sprite(game.images.fromCache(Assets.images.ui.uiButtonWhite.path));
    }
  }

  @override
  void onTapDown(_) {
    if (isActive) {
      buttonType.functionDesactivate(game.gameBloc);
    } else {
      buttonType.functionActivate(game.gameBloc);
    }
    super.onTapDown(_);
  }

  void _handleNewGameState(GameState newState) {
    switch (newState.status) {
      case GameStatus.initial:
        break;
      case GameStatus.construct:
        if (newState.buildingType!.name.contains(buttonType.name) && !isActive) {
          isActive = true;
          updateButtonsSprite();
        }
        if (!newState.buildingType!.name.contains(buttonType.name) && isActive) {
          isActive = false;
          updateButtonsSprite();
        }
        break;
      case GameStatus.destruct:
        if (buttonType == ButtonType.trash && !isActive) {
          isActive = true;
          updateButtonsSprite();
        }
        if (buttonType != ButtonType.trash && isActive) {
          isActive = false;
          updateButtonsSprite();
        }
        break;
      case GameStatus.idle:
        if (isActive) {
          isActive = false;
          updateButtonsSprite();
        }
        break;
    }
  }
}

enum ButtonType {
  road,
  trash;

  String get path {
    return switch (this) {
      ButtonType.road => Assets.images.ui.uiRoadSN.path,
      ButtonType.trash => Assets.images.ui.uiTrash.path,
    };
  }

  Function get functionActivate {
    return switch (this) {
      ButtonType.road => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(buildingType: BuildingType.roadSN));
        },
      ButtonType.trash => (GameBloc gameBloc) {
          gameBloc.add(const DestructionModePressed());
        },
    };
  }

  Function get functionDesactivate {
    return switch (this) {
      ButtonType.road => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModeExited());
        },
      ButtonType.trash => (GameBloc gameBloc) {
          gameBloc.add(const DestructionModeExited());
        },
    };
  }
}
