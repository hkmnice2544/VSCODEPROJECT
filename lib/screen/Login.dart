import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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
          Container(
            padding: EdgeInsets.only(left: 140, top: 14, right: 16.0),
            width: 300,
            child: Image.asset(
              'images/MJU_LOGO.png',
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 125, top: 160, right: 16.0),
            child: Text(
              "เข้าสู่ระบบ",
              style: TextStyle(
                color: Color.fromARGB(255, 7, 94, 53),
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: isObscure,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // ดึงค่า Username และ Password จาก TextField
                    String enteredUsername = _usernameController.text;
                    String enteredPassword = _passwordController.text;

                    // ตรวจสอบ Username และ Password ว่าตรงกับข้อมูลในระบบหรือไม่
                    if (enteredUsername == 'mju6304106339' &&
                        enteredPassword == 'MJU@21092001') {
                      // ถ้าตรงกันให้นำผู้ใช้ไปยังหน้าหลักของแอป
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Home()),
                      // );
                    } else if (enteredUsername == 'staff01' &&
                        enteredPassword == 'staff01') {
                      // กรณีรหัสผู้ใช้และรหัสผ่านตรงกับเงื่อนไขใหม่
                      // นำผู้ใช้ไปยังหน้าอื่นที่คุณต้องการ
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomeStaff()),
                      // );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('เข้าสู่ระบบล้มเหลว'),
                            content:
                                Text('กรุณาตรวจสอบชื่อผู้ใช้และรหัสผ่านของคุณ'),
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
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
