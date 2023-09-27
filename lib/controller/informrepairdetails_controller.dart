import 'dart:convert';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/InformRepiarDetails_Model.dart';
import 'package:http/http.dart' as http;

class InformRepairDetailsController {
  InformRepairDetails? informRepairDetails;

  Future<List<InformRepairDetails>> listAll() async {
    var url = Uri.parse(baseURL + '/informrepairdetails/allList');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<InformRepairDetails> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonData = json.decode(utf8body);

    // ดำเนินการแปลงข้อมูลเฉพาะเมื่อสถานะถูกต้อง
    final jsonList = jsonData as List<dynamic>;
    for (final jsonData in jsonList) {
      final informRepairDetails =
          InformRepairDetails.fromJsonToInformRepairDetails(jsonData);
      list.add(informRepairDetails);
    }

    return list;
  }
}
