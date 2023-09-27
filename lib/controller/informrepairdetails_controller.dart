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

    if (jsonData is List<dynamic>) {
      for (final dynamic data in jsonData) {
        if (data is Map<String, dynamic>) {
          final informRepairDetails =
              InformRepairDetails.fromJsonToInformRepairDetails(data);
          if (informRepairDetails != null) {
            // ตรวจสอบว่าไม่เป็นค่า null
            list.add(informRepairDetails);
          }
        } else {
          // ข้อมูลไม่ใช่ Map<String, dynamic> หรือเป็น null
          // ให้ทำการจัดการตามที่เหมาะสม
        }
      }
    } else {
      // jsonData ไม่ใช่ List<dynamic> หรือเป็น null
      // ให้ทำการจัดการตามที่เหมาะสม
    }

    return list;
  }
}
