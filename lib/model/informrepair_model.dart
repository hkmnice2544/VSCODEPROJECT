import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformRepair {
  late int informrerair_id;
  late String buildngname;
  late String floor;
  late String position;
  late String tap;
  late bool toiletbowl;
  late bool bidet;
  late bool urinal;
  late bool sink;
  late bool lightbulb;
  late bool other;

  int? informrepair_id;
  DateTime? informdate;
  String? defectiveequipment;
  String? informdetails;
  String? informtype;
  String? status;

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
    );
  }
}
