import 'Room_Model.dart';

class Equipment {
  int? equipment_id;
  String? equipmentname;
  List<Room>? rooms; // เพิ่ม List ของห้องที่เกี่ยวข้อง

  Equipment({
    required this.equipment_id,
    this.equipmentname,
    this.rooms, // เพิ่มพารามิเตอร์เพื่อรับ List ของห้องที่เกี่ยวข้อง
  });

  factory Equipment.fromJsonToEquipment(Map<String, dynamic> json) => Equipment(
        equipment_id: json["equipment_id"] as int?,
        equipmentname: json["equipmentname"],
        rooms: json["rooms"] != null
            ? List<Room>.from(json["rooms"].map((x) => Room.fromJsonToRoom(x)))
            : null, // แปลง List ของห้องจาก JSON
      );

  Map<String, dynamic> fromEquipmentToJson(json) {
    return <String, dynamic>{
      'equipment_id': equipment_id,
      'equipmentname': equipmentname,
      'rooms': rooms != null
          ? List<dynamic>.from(rooms!.map((x) => x.fromRoomToJson()))
          : null, // แปลง List ของห้องเป็น JSON
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'equipment_id': equipment_id,
      'equipmentname': equipmentname,
      'rooms': rooms != null
          ? List<dynamic>.from(rooms!.map((room) => room.toJson()))
          : null, // แปลง List ของห้องให้กลายเป็น JSON
    };
  }
}
