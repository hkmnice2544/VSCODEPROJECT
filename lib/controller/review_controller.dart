import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';
import '../model/Review_Model.dart';

class ReviewController {
  Reviews? review;

  Future addReview(String reviewer, String repairscore, String comment,
      int report_id) async {
    Map data = {
      // "informdate" : informdate,
      "reviewer": reviewer,
      "repairscore": repairscore,
      "comment": comment,
      "report_id": report_id
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/reviews/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    // print("addInformRepair: ${informRepair!.informdate}");
  }

  String decodeUtf8(String input) {
    List<int> bytes = input.codeUnits;
    Utf8Decoder decoder = Utf8Decoder();
    String result = decoder.convert(bytes);
    return result;
  }

  Future getReviews(int review_id) async {
    var url = Uri.parse(baseURL + '/reviews/get/$review_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    String utf8DecodedBody = decodeUtf8(response.body); // แปลง UTF-8
    Map<String, dynamic> jsonMap = json.decode(utf8DecodedBody);
    Reviews? reviews = Reviews.fromJsonToReviews(jsonMap);
    return reviews;
  }

  Future<List<Reviews>> listAllReviews() async {
    var url = Uri.parse(baseURL + '/reviews/list');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<Reviews> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonList = json.decode(utf8body) as List<dynamic>;

    for (final jsonData in jsonList) {
      final review = Reviews.fromJsonToReviews(jsonData);
      list.add(review);
    }

    return list;
  }
}
