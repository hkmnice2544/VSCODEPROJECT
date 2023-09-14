import 'package:flutter/material.dart';
import 'package:flutterr/model/informrepair_model.dart';
import 'package:intl/intl.dart';

class ReportRepair {
  int? report_id;

  String? repairer;
  DateTime? reportdate;
  DateTime? enddate;
  String? details;
  InformRepair? informRepair;

  ReportRepair({
    required this.report_id,
    // this.informdate,
    this.repairer,
    this.reportdate,
    this.enddate,
    this.details,
    this.informRepair,
  });

  String formattedReviewDate(DateTime? enddate) {
    if (enddate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat =
          DateFormat('dd-MM-yyyy HH:mm', thailandLocale.toString());

      // แปลง DateTime เป็นสตริงและตัด 'Z' ออก
      final dateString = outputFormat.format(enddate).replaceAll('Z', '');

      return dateString;
    } else {
      return 'N/A'; // หรือข้อความที่คุณต้องการให้แสดงถ้าไม่มีวันที่
    }
  }

  factory ReportRepair.fromJsonToReportRepair(Map<String, dynamic> json) {
    final enddateString = json["reviewdate"] as String?;
    DateTime? enddate;

    if (enddateString != null) {
      final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      final DateTime dateTime = inputFormat.parse(enddateString);

      // ปรับเวลาเป็นโซนเวลาไทย (ICT - Indochina Time)
      final thailandOffset = Duration(hours: 7);
      final thailandDateTime = dateTime.add(thailandOffset);

      enddate = thailandDateTime; // กำหนดค่าให้กับ informdate
    }

    final report_id = json["report_id"] != null
        ? int.tryParse(json["report_id"].toString())
        : null;

    return ReportRepair(
        report_id: report_id,
        repairer: json["repairer"],
        details: json["details"],
        enddate: enddate,
        informRepair: json["informRepair"] == null
            ? null
            : InformRepair.fromJsonToInformRepair(json["informRepair"]));
  }

  Map<String, dynamic> fromReportRepairToJson() {
    return <String, dynamic>{
      'report_id': report_id,
      'repairer': repairer,
      'details': details,
      'enddate': enddate,
      'informRepair': informRepair?.informrepair_id,
    };
  }
}
