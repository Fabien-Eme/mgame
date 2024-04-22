enum TruckType {
  yellow,
  purple,
  blue;

  TruckModel get model {
    switch (this) {
      case TruckType.yellow:
        return TruckModel.yellow();
      case TruckType.purple:
        return TruckModel.purple();
      case TruckType.blue:
        return TruckModel.blue();
    }
  }
}

class TruckModel {
  TruckType truckType;
  String name;
  int buyCost;
  int costPerTick;
  int buyPollution;
  int pollutionPerTile;
  int maxLoad;

  TruckModel({required this.truckType, required this.name, required this.buyCost, required this.costPerTick, required this.buyPollution, required this.pollutionPerTile, required this.maxLoad});

  factory TruckModel.yellow() {
    return TruckModel(
      truckType: TruckType.yellow,
      name: "Diesel Truck",
      buyCost: 10000,
      costPerTick: 10,
      buyPollution: 1000,
      pollutionPerTile: 10,
      maxLoad: 15,
    );
  }
  factory TruckModel.purple() {
    return TruckModel(
      truckType: TruckType.purple,
      name: "Natural Gas Truck",
      buyCost: 12000,
      costPerTick: 12,
      buyPollution: 800,
      pollutionPerTile: 6,
      maxLoad: 12,
    );
  }
  factory TruckModel.blue() {
    return TruckModel(
      truckType: TruckType.blue,
      name: "Electric Truck",
      buyCost: 20000,
      costPerTick: 8,
      buyPollution: 250,
      pollutionPerTile: 0,
      maxLoad: 10,
    );
  }
}
