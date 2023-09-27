import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/informrepair_model.dart';

class InformRepairDetails {
  int? informdetails_Id;
  int? amount;
  String? details;
  InformRepair? informRepair;
  Equipment? equipment;
  Room? room;

  InformRepairDetails(
      {required this.informdetails_Id,
      this.amount,
      this.details,
      this.informRepair,
      this.equipment,
      this.room});

  factory InformRepairDetails.fromJsonToInformRepairDetails(
      Map<String, dynamic> json) {
    final informRepairJson = json['informRepair'] as Map<String, dynamic>;
    final equipmentJson = json['equipment'] as Map<String, dynamic>;
    final roomJson = json['equipment'] as Map<String, dynamic>;
    final informRepair = InformRepair.fromJsonToInformRepair(informRepairJson);
    final equipment = Equipment.fromJsonToEquipment(equipmentJson);
    final room = Room.fromJsonToRoom(roomJson);
    return InformRepairDetails(
      informdetails_Id: json['informdetails_id'] as int,
      amount: json['amount'],
      details: json['details'],
      informRepair: informRepair,
      equipment: equipment,
      room: room,
    );
  }

  Map<String, dynamic> fromInformRepairDetailsToJson() {
    return <String, dynamic>{
      'informdetails_Id': informdetails_Id,
      'amount': amount,
      'details': details,
      'informRepair': informRepair?.fromInformRepairToJson(),
      'equipment': equipment?.fromEquipmentToJson(),
      'room': room?.fromRoomToJson(),
    };
  }
}
