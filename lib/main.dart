import 'package:flutter/material.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/Staff/List/ListManage.dart';
import 'package:flutterr/screen/Staff/Summary/Sammary.dart';
import 'package:flutterr/screen/User/InformRepairToilet/AddInformRepair.dart';
import 'package:flutterr/screen/User/InformRepairToilet/Edit.dart';
import 'package:flutterr/screen/User/InformRepairToilet/EditInformRepair.dart';
import 'package:flutterr/screen/User/InformRepairToilet/InformRepairForm.dart';
import 'package:flutterr/screen/User/InformRepairToilet/ResultInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/List_NewItem.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

late String storedUsername;
void main() async {
  String locale = 'th_TH'; // ตัวอย่างเป็น locale ไทย
  await initializeDateFormatting(locale);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ResultInformRepair(user: 1001, informrepair_id: 10004),
      // home: Login(),
      // home: EditInformRepairs(user: 1001, informrepair_id: 10004),
      // home: AddInformRepair(user: 1001),
      // home: Summary(user: 1001),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: HomeStaff(user: 1009),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Top1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 160, top: 200, right: 16.0),
            child: Container(
              width: 300,
              child: Image.asset(
                'images/MJU_LOGO.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 40, right: 0),
            child: Align(
              child: Text(
                'Equidment Repair',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 94, 53),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 180, right: 0),
            child: Align(
              child: Text(
                'Notification System',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 94, 53),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 320, right: 0),
            child: Align(
              child: Text(
                'For The Faculty Of Science',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 200,
                top: 830,
                right: 17.0,
                bottom: 10.0), // กำหนดระยะห่างให้เท่ากับ 8.0 หน่วยทั้งหมด
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login();
                  }));

                  // Navigator.pushNamed(context, '/one');
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color.fromARGB(255, 238, 104, 2), // สีพื้นหลังของปุ่ม
                  textStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                  padding: EdgeInsets.symmetric(
                      horizontal: 60, vertical: 15), // การจัดพื้นที่รอบข้างปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                  ),
                ),
                child: Text(
                  'เข้าสู่ระบบ',
                  style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 780, right: 0),
            child: Align(
              child: Text(
                'เฉพาะนักศึกษาและบุคลากร',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 860, right: 0),
            child: Align(
              child: Text(
                'มหาวิทยาลัยแม่โจ้เท่านั้น',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
