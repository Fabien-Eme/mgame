enum TruckType {
  yellow,
  blue,
  purple;

  TruckModel get model {
    switch (this) {
      case TruckType.yellow:
        return TruckModel.yellow();
      case TruckType.blue:
        return TruckModel.blue();
      case TruckType.purple:
        return TruckModel.purple();
    }
  }
}

class TruckModel {
  TruckType truckType;
  String name;
  int buyCost;
  int costPerTick;
  int buyPollution;
  int pollutionPerTick;

  TruckModel({required this.truckType, required this.name, required this.buyCost, required this.costPerTick, required this.buyPollution, required this.pollutionPerTick});

  factory TruckModel.yellow() {
    return TruckModel(
      truckType: TruckType.yellow,
      name: "Diesel Truck",
      buyCost: 10000,
      costPerTick: 10,
      buyPollution: 1000,
      pollutionPerTick: 20,
    );
  }
  factory TruckModel.blue() {
    return TruckModel(
      truckType: TruckType.blue,
      name: "Electric Truck",
      buyCost: 20000,
      costPerTick: 8,
      buyPollution: 2500,
      pollutionPerTick: 1,
    );
  }
  factory TruckModel.purple() {
    return TruckModel(
      truckType: TruckType.purple,
      name: "Natural Gas Truck",
      buyCost: 12000,
      costPerTick: 13,
      buyPollution: 1000,
      pollutionPerTick: 18,
    );
  }
}