import 'package:flutter/material.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant_value.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  LoginController loginController = LoginController();
  int? user = null;
  User? users;
  late String storedUsername;
  bool isUsernameLoaded = false;
  bool? isDataLoaded = false;
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
      user = await loginController.getviewInformDetailsById(username);
      users = await loginController.getLoginById(user!);

      // ตรวจสอบประเภทผู้ใช้งานและนำทางไปยังหน้าที่เหมาะสม
      if (userType == 'นักศึกษา') {
        saveUsername(
            user!); // เมื่อเข้าสู่ระบบสำเร็จ บันทึก username ใน SharedPreferences
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(user: user),
            ));
      } else if (userType == 'หัวหน้างานแผนกห้องน้ำ' ||
          userType == 'หัวหน้างานแผนกห้องเรียนรวม') {
        saveUsername(
            user!); // เมื่อเข้าสู่ระบบสำเร็จ บันทึก username ใน SharedPreferences
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeStaff(user: user),
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

  void saveUsername(int user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user', user);
  }

  void getviewInformDetailsById(String username) async {
    if (user != null) {
      user = await loginController.getviewInformDetailsById(username);
      users = await loginController.getLoginById(user!);
      print("getuser : ${user}");
      print("getuserfirstname : ${users?.firstname}");
      setState(() {
        isDataLoaded = true;
      });
    }
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
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: Image.asset(
                      'images/MJU_LOGO.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "แอปพลิเคชันสำหรับนักศึกษา และ บุคลากร\nคณะวิทยาศาสตร์ มหาวิทยาลัยแม่โจ้",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 112, 109, 109),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign:
                        TextAlign.center, // กำหนดให้ข้อความอยู่ตรงกลางแนวนอน
                  ),
                  SizedBox(
                    height: 20,
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
                  SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    left: 20,
                    top: 140,
                    child: Container(
                      width: 450,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 1, color: Color(0xFFEB6727)),
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
                  SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    left: 20,
                    top: 240,
                    child: Container(
                      width: 450,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 1, color: Color(0xFFEB6727)),
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
                  SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    left: 20,
                    top: 340,
                    child: ElevatedButton(
                        onPressed: () async {
                          await _loginUser(
                              context); // รอให้การเข้าสู่ระบบสำเร็จ
                          getviewInformDetailsById(_usernameController
                              .text); // เมื่อเข้าสู่ระบบสำเร็จ ค่า username ถูกตรวจสอบแล้ว จึงเรียก getviewInformDetailsById
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 238, 104, 2), // สีพื้นหลังของปุ่ม
                          textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                          padding: EdgeInsets.symmetric(
                              horizontal: 176,
                              vertical: 14), // การ16จัดพื้นที่รอบข้างปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                          ),
                        ),
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(
                          255, 255, 255, 255), // สีพื้นหลังของปุ่ม
                      textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255), // สีข้อความภายในปุ่ม
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 154,
                        vertical: 14,
                      ), // การจัดพื้นที่รอบข้างปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // กำหนดรูปร่างของปุ่ม
                        side: BorderSide(
                          color: Color.fromARGB(255, 238, 104, 2), // สีเส้นขอบ
                          width: 4, // ความหนาขอบ
                        ),
                      ),
                    ),
                    child: Text(
                      'กลับสู่หน้าหลัก',
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 238, 104, 2),
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
