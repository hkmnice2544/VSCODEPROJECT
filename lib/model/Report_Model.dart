import 'package:flutter/material.dart';

class ReportRepair {
	int? report_id;
	
	String? repairer;
	// DateTime? reportdate; 
	// DateTime? enddate;
	String? details;
  String? status;
  
ReportRepair({
  required this.report_id,
  // this.informdate,
  this.repairer,
  // this.reportdate,
  // this.enddate,
  this.details,
  this.status,
});

factory ReportRepair.fromJsonToReportRepair(Map<String, dynamic> json) => ReportRepair(
  report_id: int.parse(json["report_id"].toString()),
  repairer: json["repairer"],
  // reportdate: json["reportdate"],
  // enddate: json["enddate"],
  details: json["details"],
  status: json["status"],
  // informdate: DateTime.parse(json["informdate"].toString()),
);

Map<String, dynamic> fromReportRepairToJson() {
  return <String, dynamic> {
    'report_id': report_id,
    'repairer': repairer,
    // 'reportdate': reportdate,
    // 'enddate': enddate,
    'details': details,
    'status': status,
    
  };
}

}