import 'package:flutter/material.dart';

class Building {
  int? building_id;
  String? buildingname;

  Building({
    this.building_id,
    this.buildingname,
  });

  factory Building.fromJsonToBuilding(Map<String, dynamic> json) => Building(
        building_id: json["building_id"] as int?,
        buildingname: json["buildingname"],
      );

  Map<String, dynamic> fromBuildingToJson() {
    return <String, dynamic>{
      'building_id': building_id,
      'buildingname': buildingname,
    };
  }
}
