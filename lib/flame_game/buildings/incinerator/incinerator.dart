import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mgame/flame_game/buildings/building.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_back.dart';
import 'package:mgame/flame_game/buildings/incinerator/incinerator_front.dart';
import 'package:mgame/flame_game/particle/incinerator_smoke.dart';
import 'package:mgame/flame_game/ui/show_garbage_processed_tick.dart';
import 'package:mgame/flame_game/ui/show_money_gained_tick.dart';
import 'package:mgame/flame_game/ui/show_pollution_tick.dart';

import '../../game.dart';
import '../../tile/tile.dart';
import '../../truck/truck.dart';
import '../../utils/convert_coordinates.dart';
import '../../utils/convert_rotations.dart';
import 'incinerator_door.dart';
import 'incinerator_outline.dart';

class Incinerator extends Building {
  bool isRecycler;

  Incinerator({this.isRecycler = false, super.direction, super.position, required super.anchorTile});

  late final IncineratorFront incineratorFront;
  late final IncineratorBack incineratorBack;
  late final IncineratorDoor incineratorDoor;
  late final IncineratorOutline incineratorOutline;
  late final Vector2 offset;
  late final Vector2 smokeOffset;

  Point<int> deliveryPointDimetric = const Point<int>(0, 0);

  late Timer timer;

  final IncineratorSmoke incineratorSmoke = IncineratorSmoke(rate: 10);
  Vector2 showTickPosition = Vector2.zero();

  double pollutionReduction = 1;
  double moneyBonus = 1;

  bool pollutionReductionUpgrade = false;
  bool moneyBonusUpgrade = false;
  bool filterUpgrade = false;

  @override
  FutureOr<void> onLoad() {
    offset = convertDimetricVectorToWorldCoordinates(Vector2(3, 1)) + Vector2(0, 2);
    smokeOffset = convertDimetricVectorToWorldCoordinates(Vector2(-4, 5)) + Vector2(12, 0);

    incineratorFront = IncineratorFront(isRecycler: isRecycler, direction: direction, position: position + offset);
    incineratorBack = IncineratorBack(direction: direction, position: position + offset);
    incineratorDoor = IncineratorDoor(direction: direction, position: position + offset);
    incineratorOutline = IncineratorOutline(isRecycler: isRecycler, direction: direction, position: position + offset);

    world.addAll([
      incineratorFront,
      incineratorBack,
      incineratorDoor,
      incineratorOutline,
    ]);

    incineratorOutline.opacity = 0;

    timer = Timer(1, autoStart: false, onTick: () => closeDoor());

    add(incineratorSmoke..position = position + smokeOffset);

    if (isRecycler) {
      pollutionReduction = 0.0;
    }

    return super.onLoad();
  }

  @override
  void updatePosition(Vector2 updatedPosition) {
    incineratorFront.position = updatedPosition + offset;
    incineratorBack.position = updatedPosition + offset;
    incineratorDoor.position = updatedPosition + offset;
    incineratorOutline.position = updatedPosition + offset + Vector2(5, 5);

    deliveryPointDimetric = dimetricCoordinates + const Point<int>(-1, 1);

    listTilesWithDoor = [
      ...switch (direction) {
        Directions.S => [
            dimetricCoordinates + const Point<int>(-1, 0),
            dimetricCoordinates + const Point<int>(-1, -1),
          ],
        Directions.W => [
            dimetricCoordinates + const Point<int>(-2, 1),
            dimetricCoordinates + const Point<int>(-3, 1),
          ],
        Directions.N => [
            dimetricCoordinates + const Point<int>(-1, 2),
            dimetricCoordinates + const Point<int>(-1, 3),
          ],
        Directions.E => [
            dimetricCoordinates + const Point<int>(0, 1),
            dimetricCoordinates + const Point<int>(1, 1),
          ],
      }
    ];

    incineratorSmoke.position = updatedPosition + smokeOffset;
    showTickPosition = updatedPosition + smokeOffset + Vector2(0, -25);
  }

  @override
  void updateDirection(Directions updatedDirection) {
    incineratorFront.updateDirection(updatedDirection);
    incineratorBack.updateDirection(updatedDirection);
    incineratorDoor.updateDirection(updatedDirection);
    incineratorOutline.updateDirection(updatedDirection);
  }

  @override
  void updatePriority(Vector2 updatedPosition) {
    final int offsetPriority = ((updatedPosition.y + offset.y) / MGame.gameHeight * 100).toInt();
    incineratorFront.priority = 110 + offsetPriority;
    incineratorBack.priority = 90 + offsetPriority;
    incineratorDoor.priority = 110 + offsetPriority;
    incineratorOutline.priority = 89 + offsetPriority;
  }

  @override
  void renderAboveAll() {
    incineratorFront.priority = 510;
    incineratorBack.priority = 490;
    incineratorDoor.priority = 511;
  }

  @override
  BuildingType get buildingType => (isRecycler) ? BuildingType.recycler : BuildingType.incinerator;

  @override
  Point<int> get sizeInTile => const Point<int>(3, 3);

  @override
  void changeColor(Color color) {
    incineratorFront.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    incineratorBack.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
    incineratorDoor.paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }

  @override
  void resetColor() {
    incineratorFront.paint.colorFilter = null;
    incineratorBack.paint.colorFilter = null;
    incineratorDoor.paint.colorFilter = null;
    super.resetColor();
  }

  @override
  void makeTransparent() {
    incineratorFront.opacity = 0.8;
    incineratorBack.opacity = 0.8;
    incineratorDoor.opacity = 0.0;
  }

  @override
  void initialize() {
    incineratorDoor.animationTicker!.paused = true;
    incineratorDoor.animationTicker!.setToLast();
  }

  @override
  void closeDoor() {
    isDoorClosed = true;
    isDoorOpen = false;

    if (incineratorDoor.isAnimationReversed) {
      int currentIndex = incineratorDoor.animationTicker!.currentIndex;
      incineratorDoor.animation = incineratorDoor.animation!.reversed();
      incineratorDoor.animationTicker!.currentIndex = incineratorDoor.spriteAmount - 1 - currentIndex;
      incineratorDoor.animationTicker!.paused = false;
      incineratorDoor.isAnimationReversed = false;
    } else {
      incineratorDoor.animationTicker!.paused = false;
    }
  }

  @override
  void openDoor() {
    if (incineratorDoor.isAnimationReversed) {
      incineratorDoor.animationTicker!.paused = false;
    } else {
      int currentIndex = incineratorDoor.animationTicker!.currentIndex;
      incineratorDoor.animation = incineratorDoor.animation!.reversed();
      incineratorDoor.animationTicker!.currentIndex = incineratorDoor.spriteAmount - 1 - currentIndex;
      incineratorDoor.animationTicker!.paused = false;
      incineratorDoor.isAnimationReversed = true;
    }

    incineratorDoor.animationTicker!.completed.then((_) {
      isDoorClosed = false;
      isDoorOpen = true;
      timer.start();
    });
  }

  @override
  void select() {
    super.select();
    incineratorOutline.opacity = 1;
  }

  @override
  void deselect() {
    super.deselect();
    incineratorOutline.opacity = 0;
  }

  @override
  void onRemove() {
    if (incineratorBack.ancestors().isNotEmpty) {
      world.remove(incineratorFront);
      world.remove(incineratorBack);
      world.remove(incineratorDoor);
      world.remove(incineratorOutline);
    }
    super.onRemove();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }

  @override
  double get buildingCost => 20000;

  void showPollutionTick({required int quantity}) {
    if (!isRecycler && isMounted) {
      world.add(ShowPollutionTick(quantity: quantity)
        ..position = showTickPosition
        ..priority = 1000);
    }
  }

  void showGarbageProcessedTick({required int quantity}) {
    world.add(ShowGarbageProcessedTick(quantity: quantity)
      ..position = showTickPosition
      ..priority = 1000);
  }

  void showMoneyGainedTick({required int quantity}) {
    world.add(ShowMoneyGainedTick(quantity: quantity)
      ..position = showTickPosition
      ..priority = 1000);
  }

  @override
  Truck? isOccupiedByTruck() {
    Point<int> transitCoordinates = switch (direction) {
      Directions.S => dimetricCoordinates + const Point<int>(-1, 0),
      Directions.W => dimetricCoordinates + const Point<int>(-2, 1),
      Directions.N => dimetricCoordinates + const Point<int>(-1, 2),
      Directions.E => dimetricCoordinates + const Point<int>(0, 1),
    };

    Tile? tileDelivery = world.gridController.getTileAtDimetricCoordinates(deliveryPointDimetric);
    Tile? tileTransit = world.gridController.getTileAtDimetricCoordinates(transitCoordinates);

    if ((tileDelivery?.listTrucksOnTile.isEmpty ?? false) && (tileTransit?.listTrucksOnTile.isEmpty ?? false)) {
      return null;
    } else {
      if (tileDelivery?.listTrucksOnTile.isNotEmpty ?? false) {
        return tileDelivery?.listTrucksOnTile.first;
      }
      if (tileTransit?.listTrucksOnTile.isNotEmpty ?? false) {
        return tileTransit?.listTrucksOnTile.first;
      }
      return null;
    }
  }

  @override
  bool get isRefundable => true;

  void upgradePollutionReduction() {
    pollutionReduction = pollutionReduction * 0.75;
    pollutionReductionUpgrade = true;
  }

  void upgradeMoneyBonus(double ratio) {
    moneyBonus = moneyBonus * ratio;
    moneyBonusUpgrade = true;
  }

  void upgradeFilter() {
    pollutionReduction = pollutionReduction * 0.5;
    filterUpgrade = true;
  }
}
