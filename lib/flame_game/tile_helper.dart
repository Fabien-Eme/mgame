import '../gen/assets.gen.dart';
import 'riverpod_controllers/rotation_controller.dart';

TileType getShownTileType(TileType tileType, Rotation rotation) {
  switch (tileType) {
    case TileType.road:
      return tileType;
    case TileType.roadS:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadE;
        case Rotation.pi:
          return TileType.roadN;
        case Rotation.piAndHalf:
          return TileType.roadW;
      }
    case TileType.roadW:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadS;
        case Rotation.pi:
          return TileType.roadE;
        case Rotation.piAndHalf:
          return TileType.roadN;
      }
    case TileType.roadN:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadW;
        case Rotation.pi:
          return TileType.roadS;
        case Rotation.piAndHalf:
          return TileType.roadE;
      }
    case TileType.roadE:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadN;
        case Rotation.pi:
          return TileType.roadW;
        case Rotation.piAndHalf:
          return TileType.roadS;
      }
    case TileType.roadNE:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadWN;
        case Rotation.pi:
          return TileType.roadSW;
        case Rotation.piAndHalf:
          return TileType.roadSE;
      }
    case TileType.roadSE:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadNE;
        case Rotation.pi:
          return TileType.roadWN;
        case Rotation.piAndHalf:
          return TileType.roadSW;
      }
    case TileType.roadSN:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadWE;
        case Rotation.pi:
          return TileType.roadSN;
        case Rotation.piAndHalf:
          return TileType.roadWE;
      }
    case TileType.roadSW:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadSE;
        case Rotation.pi:
          return TileType.roadNE;
        case Rotation.piAndHalf:
          return TileType.roadWN;
      }
    case TileType.roadWE:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadSN;
        case Rotation.pi:
          return TileType.roadWE;
        case Rotation.piAndHalf:
          return TileType.roadSN;
      }
    case TileType.roadWN:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadSW;
        case Rotation.pi:
          return TileType.roadSE;
        case Rotation.piAndHalf:
          return TileType.roadNE;
      }
    case TileType.roadESW:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadNES;
        case Rotation.pi:
          return TileType.roadWNE;
        case Rotation.piAndHalf:
          return TileType.roadSWN;
      }
    case TileType.roadNES:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadWNE;
        case Rotation.pi:
          return TileType.roadSWN;
        case Rotation.piAndHalf:
          return TileType.roadESW;
      }
    case TileType.roadSWN:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadESW;
        case Rotation.pi:
          return TileType.roadNES;
        case Rotation.piAndHalf:
          return TileType.roadWNE;
      }
    case TileType.roadWNE:
      switch (rotation) {
        case Rotation.zero:
          return tileType;
        case Rotation.halfPi:
          return TileType.roadSWN;
        case Rotation.pi:
          return TileType.roadESW;
        case Rotation.piAndHalf:
          return TileType.roadNES;
      }
    case TileType.roadSWNE:
      return tileType;
    case TileType.grass:
      return tileType;
    default:
      return tileType;
  }
}

enum TileType {
  road,
  roadS,
  roadW,
  roadN,
  roadE,
  roadNE,
  roadSE,
  roadSN,
  roadSW,
  roadWE,
  roadWN,
  roadESW,
  roadNES,
  roadSWN,
  roadWNE,
  roadSWNE,

  grass;

  String get path {
    return switch (this) {
      TileType.road => Assets.images.tiles.road.path,
      TileType.roadS => Assets.images.tiles.roadS.path,
      TileType.roadW => Assets.images.tiles.roadW.path,
      TileType.roadN => Assets.images.tiles.roadN.path,
      TileType.roadE => Assets.images.tiles.roadE.path,
      TileType.roadNE => Assets.images.tiles.roadNE.path,
      TileType.roadSE => Assets.images.tiles.roadSE.path,
      TileType.roadSN => Assets.images.tiles.roadSN.path,
      TileType.roadSW => Assets.images.tiles.roadSW.path,
      TileType.roadWE => Assets.images.tiles.roadWE.path,
      TileType.roadWN => Assets.images.tiles.roadWN.path,
      TileType.roadESW => Assets.images.tiles.roadESW.path,
      TileType.roadNES => Assets.images.tiles.roadNES.path,
      TileType.roadSWN => Assets.images.tiles.roadSWN.path,
      TileType.roadWNE => Assets.images.tiles.roadWNE.path,
      TileType.roadSWNE => Assets.images.tiles.roadSWNE.path,
      TileType.grass => Assets.images.tiles.grass.path,
    };
  }

  bool get canConnect {
    if (name.contains('road')) {
      return true;
    } else {
      return false;
    }
  }
}
