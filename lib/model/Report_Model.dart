import 'package:flutter/material.dart';
import 'package:flutterr/model/informrepair_model.dart';

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

  factory ReportRepair.fromJsonToReportRepair(Map<String, dynamic> json) =>
      ReportRepair(
          report_id: int.parse(json["report_id"].toString()),
          repairer: json["repairer"],
          reportdate: json["reportdate"],
          enddate: json["enddate"],
          details: json["details"],
          informRepair: json["informRepair"] == null
              ? null
              : InformRepair.fromJsonToInformRepair(json["informRepair"]));

  Map<String, dynamic> fromReportRepairToJson() {
    return <String, dynamic>{
      'report_id': report_id,
      'repairer': repairer,
      'reportdate': reportdate,
      'enddate': enddate,
      'details': details,
      'informRepair': informRepair?.informrepair_id
    };
  }
}
