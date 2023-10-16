import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';
import '../model/Report_Model.dart';

class ReportController {
  ReportRepair? reportRepair;

  Future<void> addReport(String repairer, String details, String status,
      int equipment_id, int room_id, int informrepair_id) async {
    try {
      Map<String, dynamic> data = {
        "repairer": repairer,
        "details": details,
        "status": status,
        "equipment_id": equipment_id,
        "room_id": room_id,
        "informrepair_id": informrepair_id
      };

      final response = await http.post(
        Uri.parse('$baseURL/reportrepairs/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // การสร้าง Reportrepair สำเร็จ
        print('Reportrepair ถูกสร้างเรียบร้อย');
        // คุณสามารถทำอะไรก็ตามที่คุณต้องการหลังจากสร้าง Reportrepair ได้ที่นี่
      } else {
        // เกิดข้อผิดพลาดในการสร้าง Reportrepair
        print('เกิดข้อผิดพลาดในการสร้าง Reportrepair: ${response.statusCode}');
        // คุณสามารถจัดการข้อผิดพลาดได้ตามต้องการ
      }
    } catch (error) {
      // เกิดข้อผิดพลาดระหว่างการเรียก API
      print('เกิดข้อผิดพลาดในการสร้าง Reportrepair: $error');
      // คุณสามารถจัดการข้อผิดพลาดนี้ได้ตามต้องการ
    }
  }

  Future getReportRepair(int report_id) async {
    var url = Uri.parse(baseURL + '/reportrepairs/get/$report_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือออ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    ReportRepair? reportRepair = ReportRepair.fromJsonToReportRepair(jsonMap);
    return reportRepair;
  }

  Future Get_Reviews_id() async {
    var url = Uri.parse('$baseURL/reportrepairs/list');

    http.Response response = await http.post(url, headers: headers, body: null);

    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    print("listAllInformRepairs : ${reportRepair?.report_id}");
    return list!.map((e) => ReportRepair.fromJsonToReportRepair(e)).toList();
  }

  Future<List<ReportRepair>> listAllReportRepairs() async {
    var url = Uri.parse(baseURL + '/reportrepairs/list');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<ReportRepair> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonList = json.decode(utf8body) as List<dynamic>;

    for (final jsonData in jsonList) {
      final reportRepair = ReportRepair.fromJsonToReportRepair(jsonData);
      list.add(reportRepair);
    }

    return list;
  }

  Future<List<ReportRepair>> ViewListInformDetails(int informrepair_id) async {
    var url = Uri.parse(
        baseURL + '/reportrepairs/ViewListInformDetails/$informrepair_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    List<dynamic> jsonList = json.decode(response.body);
    List<ReportRepair> reportRepairs = jsonList
        .map((jsonMap) => ReportRepair.fromJsonToReportRepair(jsonMap))
        .toList();
    return reportRepairs;
  }
}
