import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../game.dart';
import '../../utils/my_text_style.dart';

class InfosGarageContent extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final Vector2 boxSize;
  InfosGarageContent({required this.boxSize});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(TextComponent(
      text: "INFOS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    add(TextBoxComponent(
      text:
          "The garage is where you can buy trucks, upgrade them and manage the type of waste they handle and at wich priority.\n\nIf a truck has waste loaded in its cargo and has nowhere to go, it will comme back to the garage and dump its waste in nature. This result in a major penalty to pollution : 100 pollution per waste, and the garbage doesn't count as processed.\nAvoid this at all cost !",
      textRenderer: MyTextStyle.text,
      anchor: Anchor.topCenter,
      align: Anchor.topLeft,
      size: boxSize - Vector2(50, 120),
      position: Vector2(0, -boxSize.y / 2 + 100),
    ));
  }
}
