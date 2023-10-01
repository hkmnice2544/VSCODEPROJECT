import 'dart:convert';

import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/inform_pictures_model.dart';
import 'package:http/http.dart' as http;

class InformRepair_PicturesController {
  Inform_Pictures? inform_pictures;

  static Future<List<Inform_Pictures>> saveInform_Pictures(
      List<Map<String, dynamic>> dataList) async {
    final url = Uri.parse('$baseURL/inform_pictures/addInformPictures');

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
      final List<Inform_Pictures> savedInform_PicturesList = jsonResponse
          .map(
              (dynamic item) => Inform_Pictures.fromJsonToInform_Pictures(item))
          .toList();

      return savedInform_PicturesList;
    } else {
      throw Exception('Failed to save savedInform_PicturesList');
    }
  }
}
