import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import '../../constant/constant_value.dart';
import 'Homeee.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser(BuildContext context) async {
    // เพิ่มตัวแปร context ที่รับเข้ามา
    final username = _usernameController.text;
    final password = _passwordController.text;

    var url = Uri.parse(
        '$baseURL/loginController/login'); // แทน URL ที่เป็นเว็บ API ของคุณ
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var data = {
      'username': username,
      'password': password,
    };
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // การเข้าสู่ระบบสำเร็จ
      // ทำการนำทางไปยังหน้าอื่นตามที่คุณต้องการ
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyHome(), // YourNextPage คือหน้าที่คุณต้องการไปหลังจากเข้าสู่ระบบสำเร็จ
          ));
    } else {
      print("Error");
      print(response.statusCode);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('เข้าสู่ระบบล้มเหลว'),
            content: Text('กรุณาตรวจสอบชื่อผู้ใช้และรหัสผ่านของคุณ'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                await _loginUser(
                    context); // ใช้ await เพื่อรอการเรียก _loginUser สิ้นสุด
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
