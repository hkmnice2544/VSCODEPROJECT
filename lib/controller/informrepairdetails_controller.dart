import 'dart:convert';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:http/http.dart' as http;

class InformRepairDetailsController {
  InformRepairDetails? informRepairDetails;

  Future<List> listAllInformRepairDetails() async {
    var url = Uri.parse(baseURL + '/informrepairdetails/list');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<InformRepairDetails> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonList = json.decode(utf8body) as List<dynamic>;

    for (final jsonData in jsonList) {
      final informRepairDetails =
          InformRepairDetails.fromJsonToInformRepairDetails(jsonData);
      list.add(informRepairDetails);
    }

    return list;
  }

  Future<List<InformRepairDetails>> getAllInformRepairDetails() async {
    final response =
        await http.post(Uri.parse((baseURL + '/informrepairdetails/list')));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<InformRepairDetails> detailsList = [];

      for (final dynamic data in jsonData) {
        final details = InformRepairDetails.fromJsonToInformRepairDetails(data);
        detailsList.add(details);
      }

      return detailsList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
