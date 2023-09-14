import 'package:flutter/material.dart';

class Building {
  int? buildingId;
  String? buildingName;

  Building({
    this.buildingId,
    this.buildingName,
  });

  factory Building.fromJsonToBuilding(Map<String, dynamic> json) => Building(
        buildingId: json["building_id"] as int?,
        buildingName: json["buildingName"],
      );

  Map<String, dynamic> fromBuildingToJson() {
    return <String, dynamic>{
      'building_id': buildingId,
      'buildingName': buildingName,
    };
  }
}
