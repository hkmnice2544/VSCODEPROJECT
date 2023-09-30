import 'dart:convert';
import 'package:flutterr/model/%E0%B9%8AUser_Model.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class LoginController {
  User? user;
  Future getviewInformDetailsById() async {
    var url = Uri.parse(baseURL + '/loginController/getidlogin');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    User? user = User.fromJsonToUser(jsonMap);
    return user;
  }
}
