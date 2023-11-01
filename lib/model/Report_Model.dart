import 'package:flutter/material.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/RoomEquipment_Model.dart';
import 'package:intl/intl.dart';

class ReportRepair {
  int? report_id;

  String? repairer;
  DateTime? reportdate;
  String? details;
  String? status;
  DateTime? statusdate;
  InformRepairDetails? informRepairDetails;

  ReportRepair(
      {required this.report_id,
      // this.informdate,
      this.repairer,
      this.reportdate,
      this.details,
      this.status,
      this.statusdate,
      this.informRepairDetails});

  String formattedInformDate() {
    if (reportdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat = DateFormat('dd-MM-yyyy', thailandLocale.toString());
      return outputFormat.format(reportdate!);
    } else {
      return 'N/A';
    }
  }

  String formattedstatusdateDate() {
    if (statusdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat = DateFormat('dd-MM-yyyy', thailandLocale.toString());
      return outputFormat.format(statusdate!);
    } else {
      return 'N/A';
    }
  }

  factory ReportRepair.fromJsonToReportRepair(Map<String, dynamic> json) {
    final report_id = json["report_id"] != null
        ? int.tryParse(json["report_id"].toString())
        : null;

    return ReportRepair(
        report_id: report_id,
        repairer: json["repairer"],
        reportdate: json['reportdate'] != null
            ? DateTime.parse(json['reportdate'] as String)
            : null,
        details: json["details"],
        status: json["status"],
        statusdate: json['statusdate'] != null
            ? DateTime.parse(json['statusdate'] as String)
            : null,
        informRepairDetails: json["informRepairDetails"] == null
            ? null
            : InformRepairDetails.fromJsonToInformRepairDetails(
                json["informRepairDetails"]));
  }

  Map<String, dynamic> fromReportRepairToJson() {
    return <String, dynamic>{
      'report_id': report_id,
      'repairer': repairer,
      'reportdate': reportdate,
      'details': details,
      'status': status,
      'statusdate': statusdate,
      'informRepairDetails': informRepairDetails,
    };
  }
}
