import 'dart:convert';
import 'package:flutterr/model/User_Model.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class LoginController {
  User? user;
  Future<int?> getviewInformDetailsById(String username) async {
    var url = Uri.parse(baseURL + '/loginController/getidlogin/$username');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    try {
      int? userInt = int.tryParse(response.body);
      return userInt;
    } catch (e) {
      // หากมีข้อผิดพลาดในการแปลงให้คืนค่า null หรือทำการจัดการตามความเหมาะสม
      return null;
    }
  }

  Future getLoginById(int user_id) async {
    var url = Uri.parse(baseURL + '/loginController/get/$user_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    // print("ข้อมูลที่ได้คือ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    User? user = User.fromJsonToUser(jsonMap);
    return user;
  }
}
