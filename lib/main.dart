import 'package:flutter/material.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/Long/Detail.dart';
import 'package:flutterr/screen/Long/Homeee.dart';
import 'package:flutterr/screen/Long/Login.dart';
import 'package:flutterr/screen/Staff/List/ListManage.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  String locale = 'th_TH'; // ตัวอย่างเป็น locale ไทย
  await initializeDateFormatting(locale);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(username: 'ชื่อผู้ใช้'),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
  }
}
