import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/Room_Model.dart';

class RoomEquipmentId {
  Room? room;
  Equipment? equipment;

  RoomEquipmentId({
    this.room,
    this.equipment,
  });

  factory RoomEquipmentId.fromJsonToRoomEquipmentId(Map<String, dynamic> json) {
    return RoomEquipmentId(
        room: json["room"] == null ? null : Room.fromJsonToRoom(json["room"]),
        equipment: json["equipment"] == null
            ? null
            : Equipment.fromJsonToEquipment(json["equipment"]));
  }

  Map<String, dynamic> RoomEquipmentIdtoJson() {
    return {
      'room': room?.toJson(),
      'equipment': equipment?.toJson(),
    };
  }
}
