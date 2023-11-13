import 'dart:convert';
import 'dart:io';

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

  Future getListReport_pictures(int report_id) async {
    var url = Uri.parse(baseURL + '/report_pictures/list/${report_id}');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("-------ข้อมูลที่ได้-----${response.body}");

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);

    List<Report_pictures>? list = await jsonList
        .map((e) => Report_pictures.fromJsonToReport_pictures(e))
        .toList();
    print("----ได้reportpictures_id----${list[0].picture_url}--------------");

    return list;
  }

  Future findNamePicturesById(String? picture_url) async {
    var url = Uri.parse(baseURL + '/report_pictures/image/$picture_url');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ findNamePicturesById : " + response.body);
    return response.body == "" ? "0" : response.body;
  }

  Future deleteReportPicture(int reportpictures_id) async {
    var url = Uri.parse(
        baseURL + '/report_pictures/delete/' + reportpictures_id.toString());

    http.Response response = await http.get(url);
    return response;
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse(baseURL + "/report_pictures/uploadimg");
    var length = await file.length();
    //print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    //var jsonResponse = jsonDecode(response.body);
    return response.body;
  }

  Future addReportPicture(File? image, String report_id) async {
    var path;
    if (image != null) {
      path = await upload(image);
    }

    Map data = {
      "picture_url": path.toString(),
      "report_id": report_id,
    };

    print(path);

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/report_pictures/addreppic');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    //var jsonResponse = jsonDecode(response.body);
    return response;
  }
}
