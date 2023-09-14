import 'package:flutter/material.dart';

import 'Building_Model.dart';

class Room {
  int? room_id;
  String? roomtype;
  String? roomname;
  String? floor;
  String? position;
  Building? building; // เพิ่มความสัมพันธ์ Many-to-One

  Room({
    required this.room_id,
    this.roomtype,
    this.roomname,
    this.floor,
    this.position,
    this.building, // เพิ่มพารามิเตอร์เพื่อรับข้อมูล Building ที่เกี่ยวข้อง
  });

  factory Room.fromJsonToRoom(Map<String, dynamic> json) => Room(
        room_id: json["room_id"] as int?,
        roomtype: json["roomtype"],
        roomname: json["roomname"],
        floor: json["floor"],
        position: json["position"],
        building: json["building"] != null
            ? Building.fromJsonToBuilding(json["building"])
            : null, // แปลงข้อมูล Building จาก JSON
      );

  Map<String, dynamic> fromRoomToJson() {
    return <String, dynamic>{
      'room_id': room_id,
      'roomtype': roomtype,
      'roomname': roomname,
      'floor': floor,
      'position': position,
      'building': building != null
          ? building!.fromBuildingToJson()
          : null, // แปลงข้อมูล Building เป็น JSON
    };
  }
}
