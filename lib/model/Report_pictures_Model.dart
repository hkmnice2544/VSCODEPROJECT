import 'package:flutterr/model/Report_Model.dart';

class Report_pictures {
  int? reportpictures_id;
  String? picture_url;
  ReportRepair? reportrepair;

  Report_pictures({
    this.reportpictures_id,
    this.picture_url,
    this.reportrepair,
  });
  factory Report_pictures.fromJsonToReport_pictures(Map<String, dynamic> json) {
    final reportrepairJson = json['reportrepair'] as Map<String, dynamic>;

    final reportrepair = ReportRepair.fromJsonToReportRepair(reportrepairJson);

    final inform_Pictures = Report_pictures(
        reportpictures_id: json['reportpictures_id'] as int,
        picture_url: json['pictureUrl'],
        reportrepair: reportrepair);

    return inform_Pictures;
  }

  Map<String, dynamic> fromReport_picturesToJson() {
    return <String, dynamic>{
      'reportpictures_id': reportpictures_id,
      'picture_url': picture_url,
      'informRepairDetails': reportrepair?.fromReportRepairToJson(),
    };
  }
}
