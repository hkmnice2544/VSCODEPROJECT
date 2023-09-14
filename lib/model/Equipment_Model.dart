import 'package:flutter/material.dart';

class Equipment {
  int? equipment_id;
  String? equipmentname;

  Equipment({
    required this.equipment_id,
    this.equipmentname,
  });

  factory Equipment.fromJsonToEquipment(Map<String, dynamic> json) => Equipment(
        equipment_id: json["equipment_id"] as int?,
        equipmentname: json["equipmentname"],

        // informdate: DateTime.parse(json["informdate"].toString()),
      );

  Map<String, dynamic> fromEquipmentToJson() {
    return <String, dynamic>{
      'equipment_id': equipment_id,
      'equipmentname': equipmentname,
    };
  }
}
