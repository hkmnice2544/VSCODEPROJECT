import 'package:flutterr/model/RoomEquipment_Model.dart';
import 'package:flutterr/model/informrepair_model.dart';

class InformRepairDetails {
  int? informdetails_id;
  int? amount;
  String? details;
  String? pictures;
  InformRepair? informRepair;
  RoomEquipment? roomEquipment;

  InformRepairDetails(
      {this.informdetails_id,
      this.amount,
      this.details,
      this.pictures,
      this.informRepair,
      this.roomEquipment});

  factory InformRepairDetails.fromJsonToInformRepairDetails(
          Map<String, dynamic> json) =>
      InformRepairDetails(
          informdetails_id: json["informdetails_id"] as int?,
          amount: json["amount"] as int?,
          details: json["details"],
          informRepair: json["informrepairid"] == null
              ? null
              : InformRepair.fromJsonToInformRepair(json["informrepairid"]),
          roomEquipment: json["roomEquipment"] == null
              ? null
              : RoomEquipment.fromJsonToRoomEquipment(json["roomEquipment"]));
  Map<String, dynamic> fromInformRepairDetailsToJson() {
    return <String, dynamic>{
      'informdetails_id': informdetails_id,
      'amount': amount,
      'details': details,
      'pictures': pictures,
      'informRepair': informRepair,
      'roomEquipment': roomEquipment,
    };
  }
  // Other methods and factory constructors
}
