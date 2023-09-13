import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/Review_Model.dart';
import '../constant/constant_value.dart';

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

  Future<Reviews> getReview(int review_id) async {
    var url = Uri.parse(baseURL + '/review/get/' + review_id.toString());

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    Reviews review = Reviews.fromJsonToReview(jsonResponse['result']);
    // print("Controller informrepair_id : ${informRepair.informrepair_id}");
    // print("Controller informdetails: ${informRepair.informdetails}");
    return review;
  }

  Future listAllReviews() async {
    var url = Uri.parse('$baseURL/review/list');

    http.Response response = await http.post(url, headers: headers, body: null);

    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    print("listAllInformRepairs : ${review?.review_id}");
    return list!.map((e) => Reviews.fromJsonToReview(e)).toList();
  }
}
