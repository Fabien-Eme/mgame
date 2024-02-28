import 'dart:math';

import '../../gen/assets.gen.dart';
import 'truck_model.dart';

String getTruckAssetPath({required TruckType truckType, required double truckAngle}) {
  truckAngle = truckAngle % (2 * pi);
  int spriteNumber = 0;

  if (truckAngle > 31 * pi / 16 || truckAngle <= pi / 16) {
    spriteNumber = 0;
  }
  if (truckAngle > pi / 16 && truckAngle <= 3 * pi / 16) {
    spriteNumber = 15;
  }
  if (truckAngle > 3 * pi / 16 && truckAngle <= 5 * pi / 16) {
    spriteNumber = 14;
  }
  if (truckAngle > 5 * pi / 16 && truckAngle <= 7 * pi / 16) {
    spriteNumber = 13;
  }
  if (truckAngle > 7 * pi / 16 && truckAngle <= 9 * pi / 16) {
    spriteNumber = 12;
  }
  if (truckAngle > 9 * pi / 16 && truckAngle <= 11 * pi / 16) {
    spriteNumber = 11;
  }
  if (truckAngle > 11 * pi / 16 && truckAngle <= 13 * pi / 16) {
    spriteNumber = 10;
  }
  if (truckAngle > 13 * pi / 16 && truckAngle <= 15 * pi / 16) {
    spriteNumber = 9;
  }
  if (truckAngle > 15 * pi / 16 && truckAngle <= 17 * pi / 16) {
    spriteNumber = 8;
  }
  if (truckAngle > 17 * pi / 16 && truckAngle <= 19 * pi / 16) {
    spriteNumber = 7;
  }
  if (truckAngle > 19 * pi / 16 && truckAngle <= 21 * pi / 16) {
    spriteNumber = 6;
  }
  if (truckAngle > 21 * pi / 16 && truckAngle <= 23 * pi / 16) {
    spriteNumber = 5;
  }
  if (truckAngle > 23 * pi / 16 && truckAngle <= 25 * pi / 16) {
    spriteNumber = 4;
  }
  if (truckAngle > 25 * pi / 16 && truckAngle <= 27 * pi / 16) {
    spriteNumber = 3;
  }
  if (truckAngle > 27 * pi / 16 && truckAngle <= 29 * pi / 16) {
    spriteNumber = 2;
  }
  if (truckAngle > 29 * pi / 16 && truckAngle <= 31 * pi / 16) {
    spriteNumber = 1;
  }

  int spriteOffset = 0;
  switch (truckType) {
    case TruckType.yellow:
      spriteOffset = 32;
      break;
    case TruckType.blue:
      spriteOffset = 0;
      break;
    case TruckType.purple:
      spriteOffset = 16;
      break;
  }

  return Assets.images.trucks.values[spriteNumber + spriteOffset].path;
}
