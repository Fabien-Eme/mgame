import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart' hide ButtonState;
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mgame/flame_game/bloc/game_bloc.dart';
import 'package:mgame/flame_game/buildings/building.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';
import '../tile.dart';

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
        if ((newState.tileType?.name.contains(buttonType.name) ?? false) && !isActive) {
          toggleActivation();
          break;
        }
        if (!(newState.tileType?.name.contains(buttonType.name) ?? false) && isActive) {
          toggleActivation();
          break;
        }
        if ((newState.buildingType?.name.contains(buttonType.name) ?? false) && !isActive) {
          toggleActivation();
          break;
        }
        if (!(newState.buildingType?.name.contains(buttonType.name) ?? false) && isActive) {
          toggleActivation();
          break;
        }
        break;
      case GameStatus.destruct:
        if (buttonType == ButtonType.trash && !isActive) {
          toggleActivation();
          break;
        }
        if (buttonType != ButtonType.trash && isActive) {
          toggleActivation();
          break;
        }
        break;
      case GameStatus.idle:
        if (isActive) {
          toggleActivation();
          break;
        }
        break;
    }
  }

  void activate() {
    isActive = true;
    updateButtonsSprite();
  }

  void disactivate() {
    isActive = false;
    updateButtonsSprite();
  }

  void toggleActivation() {
    if (isActive) {
      disactivate();
    } else {
      activate();
    }
  }
}

enum ButtonType {
  road,
  trash,
  garbageLoader,
  recycler,
  incinerator;

  String get path {
    return switch (this) {
      ButtonType.road => Assets.images.ui.uiRoadSN.path,
      ButtonType.trash => Assets.images.ui.uiTrash.path,
      ButtonType.garbageLoader => Assets.images.ui.uiGarbageLoader.path,
      ButtonType.recycler => Assets.images.ui.uiRecycler.path,
      ButtonType.incinerator => Assets.images.ui.uiIncinerator.path,
    };
  }

  Function get functionActivate {
    return switch (this) {
      ButtonType.road => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(tileType: TileType.road));
        },
      ButtonType.trash => (GameBloc gameBloc) {
          gameBloc.add(const DestructionModePressed());
        },
      ButtonType.garbageLoader => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(buildingType: BuildingType.garbageLoader));
        },
      ButtonType.recycler => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(buildingType: BuildingType.recycler));
        },
      ButtonType.incinerator => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModePressed(buildingType: BuildingType.incinerator));
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
      ButtonType.garbageLoader => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModeExited());
        },
      ButtonType.recycler => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModeExited());
        },
      ButtonType.incinerator => (GameBloc gameBloc) {
          gameBloc.add(const ConstructionModeExited());
        },
    };
  }
}
