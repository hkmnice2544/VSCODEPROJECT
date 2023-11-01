import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/report_pictures_controller.dart';
import 'package:flutterr/model/Report_pictures_Model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/List/ListManage.dart';
import 'package:intl/intl.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import '../../Home.dart';
import '../../Login.dart';

class View_Completed extends StatefulWidget {
  final int? report_id;
  final int? user;
  const View_Completed({super.key, this.report_id, this.user});

  @override
  State<View_Completed> createState() => _ViewResultState();
}

class _ViewResultState extends State<View_Completed> {
  final ReportController reportController = ReportController();
  Report_PicturesController report_picturesController =
      Report_PicturesController();

  ReportRepair? reportRepair;
  List<Report_pictures>? report_pictures;
  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  void getInform(int report_id) async {
    reportRepair = await reportController.getReportRepair(report_id);
    print("getInform : ${reportRepair?.report_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String> report_picture = [];

  void getListReport_pictures(int report_id) async {
    List<String> nameList = [];
    report_pictures =
        await report_picturesController.getListReport_pictures(report_id);
    for (int i = 0; i < report_pictures!.length; i++) {
      nameList.add(report_pictures![i].picture_url.toString());
      print("-------report_picture-----${nameList[i]}-------------");
    }
    setState(() {
      report_picture = nameList;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    print("-------report_id-----${widget.report_id!}-------------");
    getInform(widget.report_id!);

    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    getListReport_pictures(widget.report_id!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า รายละเอียดการแจ้งซ่อม",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
              fontWeight: FontWeight.w100),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListManage();
            }));
          },
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 245, 59, 59),
        height: 50,
        shape: CircularNotchedRectangle(), // รูปร่างของแถบ

        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.home),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeStaff(user: widget.user);
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "หน้าแรก",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              Expanded(child: Text("                           ")),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.logout),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              )
            ]),
      ),
      body:

          // isDataLoaded == false?
          // CircularProgressIndicator() : //คือตัวหมนุๆ
          Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Center(
          child: Column(children: [
            Center(
              child: Text(
                "รายละเอียดผลการซ่อม",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 94, 53),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'images/View_Inform.png',
              // fit: BoxFit.cover,
              width: 220,
              alignment: Alignment.center,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "เลขที่แจ้งซ่อม  :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${reportRepair?.informRepairDetails?.informRepair?.informrepair_id}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "วันที่แจ้งซ่อม  :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${reportRepair?.informRepairDetails?.informRepair?.formattedInformDate()}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "รายละเอียด",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${reportRepair?.details}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ผู้ซ่อม   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${reportRepair?.repairer}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "สถานะ   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${reportRepair?.informRepairDetails?.informRepair?.status}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
              runSpacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
              children: List.generate(
                report_picture.length,
                (index) {
                  return Container(
                    width: 200,
                    height: 350,
                    child: Image.network(
                      baseURL +
                          '/report_pictures/image/${report_picture[index]}',
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ListManage(user: widget.user);
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 234, 112, 5),
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ย้อนกลับ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}
