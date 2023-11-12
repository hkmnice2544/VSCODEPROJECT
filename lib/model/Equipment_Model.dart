import 'Room_Model.dart';

class Equipment {
  int? equipment_id;
  String? equipmentname;
  Room? room; // เพิ่ม List ของห้องที่เกี่ยวข้อง

  Equipment({
    required this.equipment_id,
    this.equipmentname,
    this.room, // เพิ่มพารามิเตอร์เพื่อรับ List ของห้องที่เกี่ยวข้อง
  });
  factory Equipment.fromJsonToEquipment(Map<String, dynamic> json) {
    final roomJson = json['room'] as Map<String, dynamic>;
    final room = Room.fromJsonToRoom(roomJson);

    final equipment = Equipment(
      equipment_id: json['equipment_id'] as int,
      equipmentname: json['equipmentname'],
      room: room,
    );

    return equipment;
  }

  Map<String, dynamic> fromEquipmentToJson() {
    return <String, dynamic>{
      'equipment_id': equipment_id,
      'equipmentname': equipmentname,
      'room': room?.fromRoomToJson(),
    };
  }
}
