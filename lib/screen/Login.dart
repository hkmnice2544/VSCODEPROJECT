import 'package:flutter/material.dart';
import 'package:flutterr/model/%E0%B9%8AUser_Model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/HomeStaff.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/informrepair_model.dart';
import '../constant/constant_value.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
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
      // ดึงข้อมูลผู้ใช้งานจาก response (JSON) และแปลงเป็น Map
      final userData = json.decode(response.body);
      final userType = userData['usertype'];

      // ตรวจสอบประเภทผู้ใช้งานและนำทางไปยังหน้าที่เหมาะสม
      if (userType == 'นักศึกษา') {
        saveUsername(
            username); // เมื่อเข้าสู่ระบบสำเร็จ บันทึก username ใน SharedPreferences
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(username: username),
            ));
      } else if (userType == 'หัวหน้างานแผนกห้องน้ำ') {
        saveUsername(
            username); // เมื่อเข้าสู่ระบบสำเร็จ บันทึก username ใน SharedPreferences
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeStaff(username: username),
            ));
      } else {
        print("ประเภทผู้ใช้ไม่ถูกต้อง");
      }
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

  void saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Top2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 200, top: 70, right: 16.0),
            child: Container(
              width: 200,
              child: Image.asset(
                'images/MJU_LOGO.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 300, right: 0),
            child: Container(
              width: 1100,
              height: 1000,
              child: Stack(
                children: [
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Container(
                      width: 510,
                      height: 510,
                      decoration: ShapeDecoration(
                        color: Color(0xFFEB6727),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5,
                    top: 0,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // สีของเงา
                            spreadRadius: 5, // รัศมีการกระจายของเงา
                            blurRadius: 7, // ความคมชัดของเงา
                            offset: Offset(0, 3), // ตำแหน่งเงา
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 20,
                    child: SizedBox(
                      width: 800,
                      height: 50,
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 94, 53),
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 90,
                    child: Container(
                      width: 450,
                      height: 4,
                      decoration: BoxDecoration(color: Color(0xFFEB6727)),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 140,
                    child: Container(
                      width: 450,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(31.50),
                        border: Border.all(width: 1, color: Color(0xFFEB6727)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 240,
                    child: Container(
                      width: 450,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(31.50),
                        border: Border.all(width: 1, color: Color(0xFFEB6727)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),
                            border: InputBorder.none,
                          ),
                          obscureText: isObscure,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 340,
                    child: ElevatedButton(
                        onPressed: () async {
                          await _loginUser(
                              context); // ใช้ await เพื่อรอการเรียก _loginUser สิ้นสุด
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 238, 104, 2), // สีพื้นหลังของปุ่ม
                          textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                          padding: EdgeInsets.symmetric(
                              horizontal: 200,
                              vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                60), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                          ),
                        ),
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
