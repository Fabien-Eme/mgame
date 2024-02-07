import 'package:flame/components.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class Building extends PositionComponent with HasWorldReference {
  Building({super.position});

  @mustBeOverridden
  void changePosition(Vector2 newPosition) {}
}

enum BuildingType {
  garbageLoader,
  recycler,
  incinerator;
}
