import 'dart:async';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/truck/truck_stacked.dart';

import '../../../gen/assets.gen.dart';
import '../../truck/truck_model.dart';
import '../forward_backward_button.dart';

class TruckSelector extends PositionComponent with HasGameReference {
  final Function(TruckType) changeTruckType;

  TruckSelector({required this.changeTruckType, super.position});

  late TruckStacked truckStacked;

  @override
  FutureOr<void> onLoad() {
    truckStacked = TruckStacked(truckType: TruckType.yellow)
      ..scale = Vector2(4, 5.5)
      ..position = Vector2(0, 25);
    changeTruckType(truckStacked.truckType);

    add(NineTileBoxComponent(
      nineTileBox: NineTileBox(Sprite(game.images.fromCache(Assets.images.ui.dialog.complete.path)), tileSize: 50, destTileSize: 50),
      size: Vector2(250, 250),
      anchor: Anchor.center,
    ));

    add(truckStacked);

    add(ForwardBackwardButton(
        isForward: true,
        onPressed: () {
          truckStacked.nextTruckType();
          changeTruckType(truckStacked.truckType);
        })
      ..position = Vector2(175, 0));
    add(ForwardBackwardButton(
        isForward: false,
        onPressed: () {
          truckStacked.previousTruckType();
          changeTruckType(truckStacked.truckType);
        })
      ..position = Vector2(-175, 0));

    return super.onLoad();
  }
}
