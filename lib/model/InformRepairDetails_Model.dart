import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/RoomEquipment_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/informrepair_model.dart';

class InformRepairDetails {
  int? informdetails_id;
  int? amount;
  String? details;
  InformRepair? informRepair;
  RoomEquipment? roomEquipment;

  InformRepairDetails(
      {required this.informdetails_id,
      amount,
      details,
      informRepair,
      roomEquipment});

  factory InformRepairDetails.fromJsonToInformRepairDetails(
      Map<String, dynamic> json) {
    final informRepairJson = json['informRepair'] as Map<String, dynamic>;

    final informRepair = InformRepair.fromJsonToInformRepair(informRepairJson);

    final informdetails_id = json["informdetails_id"] != null
        ? int.tryParse(json["informdetails_id"].toString())
        : null;

    return InformRepairDetails(
      informdetails_id: informdetails_id,
      amount: json["amount"],
      details: json["details"],
      informRepair: json["informRepair"] == null
          ? null
          : InformRepair.fromJsonToInformRepair(json["informRepair"]),
      roomEquipment: json["roomEquipment"] == null
          ? null
          : RoomEquipment.fromJsonToRoomEquipment(json["roomEquipment"]),
    );
  }
  Map<String, dynamic> fromInformRepairDetailsToJson() {
    return <String, dynamic>{
      'informdetails_id': informdetails_id,
      'amount': amount,
      'details': details,
      'informRepair': informRepair?.informrepair_id,
      'roomEquipment': roomEquipment,
    };
  }
  // Other methods and factory constructors
}
