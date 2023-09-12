import 'package:flutter/material.dart';


class Building {
  int? building_id;
  String? buildingname;


  Building({
    this.building_id,
    this.buildingname,

  });

  factory Building.fromJsonToBuilding(Map<String, dynamic> json) => Building( //แปลงjson เป็น object
    building_id: json["building_id"],
    buildingname: json["buildingname"],

  );

  get length => null;

  Map<String, dynamic> fromBuildingToJson() { //แปลง object เป็น  json
    return <String, dynamic> {
      'building_id' : building_id,
      'buildingname' : buildingname,

    };
  }

}