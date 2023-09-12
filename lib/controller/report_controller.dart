import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/Report_Model.dart';
import '../Model/Review_Model.dart';
import '../constant/constant_value.dart';

class ReportController {
  ReportRepair? reportRepair;

  Future addReport(String repairer, String details, String status) async {
    Map data = {
      // "informdate" : informdate,
      "repairer": repairer,
      "details": details,
      "status": status
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/reportrepair/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    // print("addInformRepair: ${informRepair!.informdate}");
  }

  Future<ReportRepair> getReportRepair(int report_id) async {
    var url = Uri.parse(baseURL + '/reportrepair/get/' + report_id.toString());

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    ReportRepair reportRepair =
        ReportRepair.fromJsonToReportRepair(jsonResponse['result']);
    // print("Controller informrepair_id : ${informRepair.informrepair_id}");
    // print("Controller informdetails: ${informRepair.informdetails}");
    return reportRepair;
  }

  Future Get_Reviews_id() async {
    var url = Uri.parse('$baseURL/reportrepair/list');

    http.Response response = await http.post(url, headers: headers, body: null);

    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    print("listAllInformRepairs : ${reportRepair?.report_id}");
    return list!.map((e) => ReportRepair.fromJsonToReportRepair(e)).toList();
  }
}
