import 'dart:convert';

import '../Model/Report_Model.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ListinformController {
  ReportRepair? reportrepair;

  Future listAllReportRepair() async {
    var url = Uri.parse('$baseURL/reportrepair/list');

    http.Response response = await http.post(url, headers: headers, body: null);

    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    print("listAllReportRepair : ${reportrepair?.report_id}");
    return list!.map((e) => ReportRepair.fromJsonToReportRepair(e)).toList();
  }

  Future<ReportRepair> getReportRepair(int report_id) async {
    var url = Uri.parse(baseURL + '/reportrepair/get/' + report_id.toString());

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    ReportRepair reportrepair =
        ReportRepair.fromJsonToReportRepair(jsonResponse['result']);
    print("Controller report_id : ${reportrepair.report_id}");
    return reportrepair;
  }
}
