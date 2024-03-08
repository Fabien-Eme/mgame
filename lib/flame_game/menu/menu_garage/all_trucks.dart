import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../../gen/assets.gen.dart';
import '../../game.dart';
import '../../riverpod_controllers/all_trucks_controller.dart';
import '../../truck/truck.dart';
import '../../truck/truck_helper.dart';
import '../forward_backward_button.dart';
import '../../utils/convert_rotations.dart';
import '../../utils/my_text_style.dart';

class AllTrucksContent extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final Vector2 boxSize;
  AllTrucksContent({required this.boxSize});

  int indexOffset = 0;
  int maxItems = 7;

  @override
  void onLoad() {
    super.onLoad();
    add(TextComponent(
      text: "ALL TRUCKS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    add(TextComponent(
      text: 'Truck',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 75, -boxSize.y / 2 + 100),
    ));

    add(TextComponent(
      text: 'Task affected',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 250, -boxSize.y / 2 + 100),
    ));
    add(TextComponent(
      text: 'State',
      textRenderer: MyTextStyle.header,
      anchor: Anchor.center,
      position: Vector2(-boxSize.x / 2 + 550, -boxSize.y / 2 + 100),
    ));

    Map<String, Truck> mapAllTrucks = ref.read(allTrucksControllerProvider).trucksOwned;
    List<Truck> listTrucks = mapAllTrucks.values.toList();

    List<Component> truckTable = getTruckTable(List.from(listTrucks));
    addAll(truckTable);

    add(SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddleBar.path)),
      anchor: Anchor.center,
      angle: -pi / 2,
      size: Vector2(338, 16),
      position: Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 295),
    ));

    SpriteComponent selector = SpriteComponent(
      sprite: Sprite(game.images.fromCache(Assets.images.ui.dialog.selectorRangeMiddlePoint.path)),
      anchor: Anchor.center,
      angle: -pi / 2,
      size: Vector2(39, 48),
      position: Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems)))),
    );
    add(selector);

    add(ForwardBackwardButton(
      isForward: false,
      onPressed: () {
        if (indexOffset - 1 >= 0) {
          indexOffset--;
          truckTable = reAddTruckTable(truckTable, List.from(listTrucks));
          selector.position = Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems))));
        }
      },
      isVertical: true,
      position: Vector2(-boxSize.x / 2 + 800, -boxSize.y / 2 + 110),
    ));
    add(ForwardBackwardButton(
      isForward: true,
      onPressed: () {
        if (indexOffset + 1 <= listTrucks.length - maxItems) {
          indexOffset++;
          truckTable = reAddTruckTable(truckTable, List.from(listTrucks));
          selector.position = Vector2(-boxSize.x / 2 + 802, -boxSize.y / 2 + 150 + (indexOffset * 290 / max(1, (listTrucks.length - maxItems))));
        }
      },
      isVertical: true,
      position: Vector2(-boxSize.x / 2 + 800, -boxSize.y / 2 + 480),
    ));
  }

  List<Component> reAddTruckTable(List<Component> truckTable, List<Truck> listTrucks) {
    for (Component component in truckTable) {
      remove(component);
    }
    truckTable = getTruckTable(listTrucks);
    addAll(truckTable);
    return truckTable;
  }

  List<Component> getTruckTable(List<Truck> listTrucks) {
    List<Component> listComponents = [];

    if (indexOffset > 0) {
      listTrucks.removeRange(0, indexOffset);
    }
    if (listTrucks.length > maxItems) {
      listTrucks.removeRange(maxItems, listTrucks.length);
    }

    int index = 0;
    for (Truck truck in listTrucks) {
      listComponents.add(SpriteComponent(
        sprite: Sprite(game.images.fromCache(getTruckAssetPath(truckType: truck.truckType, truckAngle: Directions.E.angle))),
        anchor: Anchor.center,
        size: Vector2(50, 50),
        position: Vector2(-boxSize.x / 2 + 80, -boxSize.y / 2 + 150 + index * 50),
      ));
      listComponents.add(TextComponent(
        text: truck.currentTask?.taskType.name ?? "No task",
        textRenderer: MyTextStyle.header,
        anchor: Anchor.center,
        position: Vector2(-boxSize.x / 2 + 250, -boxSize.y / 2 + 150 + index * 50),
      ));
      listComponents.add(TextComponent(
        text: (truck.isTruckMoving) ? "Going to task" : "Idling",
        textRenderer: MyTextStyle.header,
        anchor: Anchor.center,
        position: Vector2(-boxSize.x / 2 + 550, -boxSize.y / 2 + 150 + index * 50),
      ));

      index++;
    }
    return listComponents;
  }
}
