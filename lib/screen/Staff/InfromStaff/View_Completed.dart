import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/report_pictures_controller.dart';
import 'package:flutterr/model/Report_pictures_Model.dart';
import 'package:intl/intl.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'ListInformRepair.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCompleted extends StatefulWidget {
  final int? report_id;
  final int? user;
  const ViewCompleted({super.key, this.report_id, this.user});

  @override
  State<ViewCompleted> createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewCompleted> {
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
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListInformRepair();
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
                          return Home(user: widget.user);
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "หน้าแรก",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]),
      ),
      body:

          // isDataLoaded == false?
          // CircularProgressIndicator() : //คือตัวหมนุๆ
          SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Center(
            child: Column(children: [
              Center(
                child: Text(
                  "รายละเอียดผลการซ่อม",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 7, 94, 53),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 432,
                  height: 160,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 419,
                          height: 160,
                          decoration: ShapeDecoration(
                            color: Color.fromARGB(32, 41, 111, 29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 210,
                        top: 23,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(1.57),
                          child: Container(
                            width: 120,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 41, 111, 29),
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 72,
                        top: 20,
                        child: Icon(
                          Icons.favorite, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 60, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 64,
                        top: 85,
                        child: SizedBox(
                          width: 200,
                          height: 22,
                          child: Text(
                            'เลขที่แจ้งซ่อม',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 64,
                        top: 110,
                        child: SizedBox(
                          width: 93,
                          height: 52,
                          child: Text(
                            '${reportRepair?.informrepair!.informrepair_id}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 288,
                        top: 20,
                        child: Icon(
                          Icons.calendar_month_outlined, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 60, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 279,
                        top: 85,
                        child: SizedBox(
                          width: 81,
                          height: 22,
                          child: Text(
                            'วันที่แจ้งซ่อม',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 252,
                        top: 110,
                        child: SizedBox(
                          width: 174,
                          height: 30,
                          child: Text(
                            '${reportRepair?.formattedInformDate()}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 432,
                  height: 90,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 419,
                          height: 90,
                          decoration: ShapeDecoration(
                            color: Color.fromARGB(32, 41, 111, 29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 25,
                        child: Icon(
                          Icons.new_releases_outlined, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 40, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 25,
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: Text(
                            'ผลการแจ้งซ่อม',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 210,
                        top: 25,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(1.57),
                          child: Container(
                            width: 40,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 41, 111, 29),
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 230,
                        top: 30,
                        child: SizedBox(
                          width: 400,
                          height: 52,
                          child: Text(
                            '${reportRepair?.details}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 432,
                  height: 90,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 419,
                          height: 90,
                          decoration: ShapeDecoration(
                            color: Color.fromARGB(32, 41, 111, 29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 25,
                        child: Icon(
                          Icons.person, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 40, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 35,
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: Text(
                            'ผู้ซ่อม',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 210,
                        top: 25,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(1.57),
                          child: Container(
                            width: 40,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 41, 111, 29),
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 230,
                        top: 30,
                        child: SizedBox(
                          width: 400,
                          height: 52,
                          child: Text(
                            '${reportRepair?.repairer}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 432,
                  height: 90,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 419,
                          height: 90,
                          decoration: ShapeDecoration(
                            color: Color.fromARGB(32, 41, 111, 29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 25,
                        child: Icon(
                          Icons.star_outline_sharp, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 40, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 35,
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: Text(
                            'สถานะ',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 210,
                        top: 25,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(1.57),
                          child: Container(
                            width: 40,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 41, 111, 29),
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 230,
                        top: 30,
                        child: SizedBox(
                          width: 400,
                          height: 52,
                          child: Text(
                            '${reportRepair?.status}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 432,
                  height: 330,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 419,
                          height: 500,
                          decoration: ShapeDecoration(
                            color: Color.fromARGB(32, 41, 111, 29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 25,
                        child: Icon(
                          Icons
                              .photo_size_select_actual_outlined, // เปลี่ยนไอคอนตรงนี้
                          color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                          size: 40, // ขนาดไอคอน
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 35,
                        child: SizedBox(
                          width: 80,
                          height: 50,
                          child: Text(
                            'รูปภาพ',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(7, 94, 53, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 110,
                        top: 90,
                        child: Wrap(
                          spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
                          runSpacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
                          children: List.generate(
                            report_picture.length,
                            (index) {
                              return Container(
                                width: 200,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // 100 is half of 200 (width/2)
                                  child: Image.network(
                                    baseURL +
                                        '/report_pictures/${report_picture[index]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                              // Container(
                              //   width: 200,
                              //   height: 200,
                              //   child: Image.network(
                              //     baseURL +
                              //         '/report_pictures/image/${report_picture[index]}',
                              //     fit: BoxFit.cover,
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 120, // Set the width of the button here
                      child: FloatingActionButton.extended(
                        label: Text(
                          "ย้อนกลับ",
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ListInformRepair(user: widget.user);
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
