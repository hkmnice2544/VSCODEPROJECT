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

  Future getListInformRepairDetails() async {
    var url = Uri.parse(baseURL + '/informrepairdetails/list');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<InformRepairDetails>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList
        .map((e) => InformRepairDetails.fromJsonToInformRepairDetails(e))
        .toList();
    return list;
  }

  Future getInformDetailsById(int informrepair_id) async {
    var url = Uri.parse(
        baseURL + '/informrepairdetails/viewinformdetails/${informrepair_id}');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("-------ข้อมูลที่ได้-----${response.body}");

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);

    List<InformRepairDetails>? list = await jsonList
        .map((e) => InformRepairDetails.fromJsonToInformRepairDetails(e))
        .toList();
    print("----ได้----${list[0].informdetails_id}--------------");
    return list;
  }

  Future getviewInformDetailsById(int informdetails_id) async {
    var url = Uri.parse(baseURL +
        '/informrepairdetails/getInformRepairDetails/$informdetails_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    InformRepairDetails? informRepair =
        InformRepairDetails.fromJsonToInformRepairDetails(jsonMap);
    return informRepair;
  }
}
