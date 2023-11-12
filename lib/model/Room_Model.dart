import 'Building_Model.dart';

class Room {
  int? room_id;
  String? roomtype;
  String? roomname;
  String? floor;
  String? position;
  Building? building; // เพิ่มความสัมพันธ์ Many-to-One

  Room({
    this.room_id,
    this.roomtype,
    this.roomname,
    this.floor,
    this.position,
    this.building, // เพิ่มพารามิเตอร์เพื่อรับข้อมูล Building ที่เกี่ยวข้อง
  });

  factory Room.fromJsonToRoom(Map<String, dynamic> json) {
    final room_id = json["room_id"] != null
        ? int.tryParse(json["room_id"].toString())
        : null;

    return Room(
        room_id: room_id,
        roomtype: json["roomtype"],
        roomname: json["roomname"],
        floor: json["floor"],
        position: json["position"],
        building: json["building"] == null
            ? null
            : Building.fromJsonToBuilding(json["building"]));
  }

  Map<String, dynamic> fromRoomToJson() {
    return <String, dynamic>{
      'room_id': room_id,
      'roomtype': roomtype,
      'roomname': roomname,
      'floor': floor,
      'position': position,
      'building': building?.building_id,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': room_id,
      'roomtype': roomtype,
      'roomname': roomname,
      'floor': floor,
      'position': position,
      'building':
          building?.fromBuildingToJson(), // เรียกใช้ toJson ของคลาส Building
    };
  }
}
