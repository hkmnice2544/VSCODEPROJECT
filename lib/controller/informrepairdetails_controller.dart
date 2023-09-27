import 'dart:convert';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/InformRepiarDetailsList_Model.dart';
import 'package:http/http.dart' as http;

class InformRepairDetailsController {
  InformRepairDetailsList? informRepairDetails;
  Future<List<InformRepairDetailsList>> fetchData() async {
    final response =
        await http.post(Uri.parse((baseURL + '/informrepairdetails/allList')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<InformRepairDetailsList> result = [];

      for (final dynamic data in jsonData) {
        if (data != null && data is Map<String, dynamic>) {
          final details = InformRepairDetailsList.fromJson(data);
          result.add(details);
        }
      }

      return result;
    } else {
      throw Exception('Failed to load data');
    }
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
