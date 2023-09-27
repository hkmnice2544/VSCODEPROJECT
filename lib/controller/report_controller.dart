import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';
import '../model/Report_Model.dart';

class ReportController {
  ReportRepair? reportRepair;

  Future addReport(String repairer, String details, int informrepair_id,
      String status) async {
    Map data = {
      // "informdate" : informdate,
      "repairer": repairer,
      "details": details,
      "informrepair_id": informrepair_id,
      "status": status,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/reportrepairs/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    // print("addInformRepair: ${informRepair!.informdate}");
  }

  Future getReportRepair(int report_id) async {
    var url = Uri.parse(baseURL + '/reportrepairs/get/$report_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

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
}
