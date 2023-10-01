import 'dart:convert';

import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/Report_pictures_Model.dart';
import 'package:http/http.dart' as http;

class Report_PicturesController {
  Report_pictures? report_pictures;

  static Future<List<Report_pictures>> saveReport_pictures(
      List<Map<String, dynamic>> dataList) async {
    final url = Uri.parse('$baseURL/report_pictures/addReport_pictures');

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(dataList),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final List<Report_pictures> savedReport_picturesList = jsonResponse
          .map(
              (dynamic item) => Report_pictures.fromJsonToReport_pictures(item))
          .toList();

      return savedReport_picturesList;
    } else {
      throw Exception('Failed to save savedInform_PicturesList');
    }
  }
}
