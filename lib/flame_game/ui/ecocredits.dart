import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/utils/my_text_style.dart';

import '../game.dart';
import '../riverpod_controllers/game_user_controller.dart';

class EcoCredits extends PositionComponent with RiverpodComponentMixin {
  late TextComponent textComponent;

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    position = Vector2(MGame.gameWidth / 2 + 5, 90);

    return super.onLoad();
  }

  @override
  void onMount() {
    textComponent = TextBoxComponent(
      text: 'EcoCredits: ${ref.read(gameUserControllerProvider).value?.ecoCredits ?? ' '}',
      textRenderer: MyTextStyle.ecoCredits,
      align: Anchor.center,
      anchor: Anchor.center,
    );

    addToGameWidgetBuild(() => ref.listen(gameUserControllerProvider, (previous, userStatus) {
          textComponent.text = 'EcoCredits: ${userStatus.value?.ecoCredits ?? ' '}';
        }));

    add(textComponent);

    super.onMount();
  }
}
