import 'dart:ui';
import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:intl/intl.dart';

class InformRepair {
  int? informrepair_id;
  DateTime? informdate;
  String? informtype;
  String? status;
  int? amount;
  String? details;
  String? pictures;
  User? user;
  Equipment? equipment;

  String formattedInformDate() {
    if (informdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat = DateFormat('dd-MM-yyyy', thailandLocale.toString());
      return outputFormat.format(informdate!);
    } else {
      return 'N/A';
    }
  }

  InformRepair({
    this.informrepair_id,
    this.informdate,
    this.informtype,
    this.status,
    this.amount,
    this.details,
    this.pictures,
    this.user,
    this.equipment,
  });

  factory InformRepair.fromJsonToInformRepair(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final equipmentJson = json['equipment'] as Map<String, dynamic>;

    final user = User.fromJsonToUser(userJson);
    final equipment = Equipment.fromJsonToEquipment(equipmentJson);

    final informRepair = InformRepair(
      informrepair_id: json['informrepair_id'] as int,
      informdate: json['informdate'] != null
          ? DateTime.parse(json['informdate'] as String)
          : null,
      informtype: json['informtype'],
      status: json['status'],
      amount: json['amount'],
      details: json['details'],
      pictures: json['pictures'],
      user: user,
      equipment: equipment,
    );

    return informRepair;
  }

  Map<String, dynamic> fromInformRepairToJson() {
    return <String, dynamic>{
      'informrepair_id': informrepair_id,
      'informdate': informdate?.toIso8601String(),
      'informtype': informtype,
      'status': status,
      'amount': amount,
      'details': details,
      'pictures': pictures,
      'user': user?.toJson(),
      'equipment': equipment?.fromEquipmentToJson(),
    };
  }
}
