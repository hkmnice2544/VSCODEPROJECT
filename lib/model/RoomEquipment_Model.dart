import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/RoomEquipmentID_Model.dart';
import 'package:flutterr/model/Room_Model.dart';

class RoomEquipment {
  RoomEquipmentId? id; // นี่คือคีย์หลัก
  String? status;
  Room? room;
  Equipment? equipment;

  RoomEquipment({
    this.id,
    this.status,
    this.room,
    this.equipment,
  });

  factory RoomEquipment.fromJsonToRoomEquipment(Map<String, dynamic> json) {
    final id = json["id"] != null
        ? RoomEquipmentId.fromJsonToRoomEquipmentId(json["id"])
        : null;

    return RoomEquipment(
      id: id, // ใช้ RoomEquipmentId ในการระบุคีย์หลัก
      status: json["status"],
      room: json["room"] == null ? null : Room.fromJsonToRoom(json["room"]),
      equipment: json["equipment"] == null
          ? null
          : Equipment.fromJsonToEquipment(json["equipment"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.RoomEquipmentIdtoJson(), // แปลง RoomEquipmentId เป็น JSON
      'status': status,
      'room': room?.toJson(), // แปลง Room เป็น JSON
      'equipment': equipment?.toJson(), // แปลง Equipment เป็น JSON
    };
  }
}
