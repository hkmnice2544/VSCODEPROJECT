import 'dart:convert';
import 'package:flutterr/model/User_Model.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class LoginController {
  User? user;
  Future getviewInformDetailsById(String username) async {
    var url = Uri.parse(baseURL + '/loginController/getidlogin/$username');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);
    return response.body;
  }
}
