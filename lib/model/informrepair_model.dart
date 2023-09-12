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
      return DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ', 'en_US')
          .format(informdate!);
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
      final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ', 'en_US');
      informdate = inputFormat.parse(informdateString);
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
