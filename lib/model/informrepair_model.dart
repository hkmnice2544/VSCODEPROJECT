import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Equipment_Model.dart';

class InformRepair {
  int? informrepair_id;
  DateTime? informdate;
  String? defectiveequipment;
  String? informdetails;
  String? informtype;
  String? status;
  Equipment? equipment;

  String formattedInformDate() {
    if (informdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat =
          DateFormat('dd-MM-yyyy HH:mm', thailandLocale as String?);
      return outputFormat.format(informdate!);
    } else {
      return 'N/A'; // หรือข้อความที่คุณต้องการให้แสดงถ้าไม่มีวันที่
    }
  }

  InformRepair({
    required this.informrepair_id,
    this.informdate,
    this.defectiveequipment,
    this.informdetails,
    this.informtype,
    this.status,
    this.equipment,
  });

  factory InformRepair.fromJsonToInformRepair(Map<String, dynamic> json) {
    final informdateString = json["informdate"] as String?;
    DateTime? informdate;

    if (informdateString != null) {
      final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      final DateTime dateTime = inputFormat.parse(informdateString);

      // ปรับเวลาเป็นโซนเวลาไทย (ICT - Indochina Time)
      final thailandOffset = Duration(hours: 7);
      final thailandDateTime = dateTime.add(thailandOffset);

      informdate = thailandDateTime; // กำหนดค่าให้กับ informdate
    }

    return InformRepair(
        informrepair_id: int.parse(json["informrepair_id"].toString()),
        defectiveequipment: json["defectiveequipment"],
        informdetails: json["informdetails"],
        informtype: json["informtype"],
        status: json["status"],
        informdate: informdate,
        equipment: json["equipment"] == null
            ? null
            : Equipment.fromJsonToEquipment(json["equipment"]));
  }

  Map<String, dynamic> fromInformRepairToJson() {
    return <String, dynamic>{
      'informrepair_id': informrepair_id,
      'defectiveequipment': defectiveequipment,
      'informdetails': informdetails,
      'informtype': informtype,
      'status': status,
      'informdate': informdate,
      'equipment': equipment?.equipment_id
    };
  }
}
