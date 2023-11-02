import 'package:flutter/material.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/Staff/Summary/Sammary.dart';
import 'package:flutterr/screen/User/InformRepairToilet/Edit.dart';
import 'package:flutterr/screen/User/InformRepairToilet/EditInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/List_NewItem.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

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
      // home: Login(),
      // home: EditInformRepairs(user: 1001, informrepair_id: 10001),
      home: MyEdit(user: 1001, informrepair_id: 10002),
      //  home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    return Stack(
      children: <Widget>[
        Container(
          height: 1100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/Top1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 150, top: 220, right: 16.0),
          child: Container(
            width: 300,
            child: Image.asset(
              'images/MJU_LOGO.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, top: 90, right: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Equidment Repair",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 0, top: 200, right: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Notification System",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 0, top: 330, right: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "For The Faculty Of Science",
              style: TextStyle(
                  color: Color.fromARGB(255, 166, 14, 3),
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none),
            ),
          ),
        ),

        // const Padding(
        //         padding: EdgeInsets.only(left: 120, top: 590, right: 16.0),
        //         child: Text
        //         ("ยินดีต้อนรับเข้าสู่แอพพลิเคชั่น.." ,
        //         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,),),
        //         ),

        // const Padding(
        //         padding: EdgeInsets.only(left: 100, top: 620, right: 16.0),
        //         child: Text
        //         ("แจ้งซ่อมอุปกรณ์ชำรุดภายในห้องน้ำและ" ,
        //         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,),),
        //         ),

        // const Padding(
        //         padding: EdgeInsets.only(left: 70, top: 650, right: 16.0),
        //         child: Text
        //         ("ห้องเรียนรวม คณะวิทยาศาสตร์ มหาวิทยาลัยแม่โจ้" ,
        //         style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,),),
        //         ),

        Padding(
          padding: EdgeInsets.only(
              left: 200,
              top: 820,
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
                primary: Color.fromARGB(255, 238, 104, 2), // สีพื้นหลังของปุ่ม
                textStyle: TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                padding: EdgeInsets.symmetric(
                    horizontal: 70, vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                ),
              ),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              )),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 0, top: 740, right: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "เฉพาะนักศึกษาและบุคลากร",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 0, top: 820, right: 0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "มหาวิทยาลัยแม่โจ้เท่านั้น",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ],
    );
  }
}
