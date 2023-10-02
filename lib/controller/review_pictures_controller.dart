import 'dart:convert';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/Review_pictures_Model.dart';
import 'package:http/http.dart' as http;

class Review_PicturesController {
  Review_pictures? review_pictures;

  static Future<List<Review_pictures>> saveReview_pictures(
      List<Map<String, dynamic>> dataList) async {
    final url = Uri.parse('$baseURL/review_pictures/addReview_pictures');

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
      final List<Review_pictures> savedReview_pictures = jsonResponse
          .map(
              (dynamic item) => Review_pictures.fromJsonToReview_pictures(item))
          .toList();

      return savedReview_pictures;
    } else {
      throw Exception('Failed to save savedReview_picturesList');
    }
  }

  Future getListReview_pictures(int review_id) async {
    var url = Uri.parse(baseURL + '/review_pictures/list/${review_id}');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("-------ข้อมูลที่ได้-----${response.body}");

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);

    List<Review_pictures>? list = await jsonList
        .map((e) => Review_pictures.fromJsonToReview_pictures(e))
        .toList();
    print(
        "----ได้Review_pictures----${list[0].picture_url}-----${list[0].review?.review_id}---------");

    return list;
  }
}
