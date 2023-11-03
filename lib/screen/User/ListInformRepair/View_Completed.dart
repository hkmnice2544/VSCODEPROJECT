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
              Image.asset(
                'images/View_Inform.png',
                // fit: BoxFit.cover,
                width: 220,
                alignment: Alignment.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 390,
                  height: 220,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 390,
                          height: 220,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFF0573D)),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            shadows: [
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
                        left: 50,
                        top: 11,
                        child: SizedBox(
                          width: 450,
                          height: 27,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.list,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: 'เลขที่แจ้งซ่อม :',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text:
                                      '${reportRepair?.informRepairDetails?.informRepair?.informrepair_id}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 50,
                        child: SizedBox(
                          width: 450,
                          height: 27,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.date_range,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: 'วันที่แจ้งซ่อม  :',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text:
                                      '${reportRepair?.informRepairDetails?.informRepair?.formattedInformDate()}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 90,
                        child: SizedBox(
                          width: 450,
                          height: 90,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.ballot_outlined,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: 'ผลการแจ้งซ่อม  :',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: '${reportRepair?.details}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 130,
                        child: SizedBox(
                          width: 450,
                          height: 90,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.business,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: 'ผู้ซ่อม   ',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: '${reportRepair?.repairer}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 170,
                        child: SizedBox(
                          width: 450,
                          height: 90,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.bento_outlined,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text: 'สถานะ   ',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                                TextSpan(
                                  text:
                                      '${reportRepair?.informRepairDetails?.informRepair?.status}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        top: 170,
                        child: SizedBox(
                          width: 450,
                          height: 90,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.bento_outlined,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width:
                                          25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
            ]),
          ),
        ),
      ),
      floatingActionButton: Row(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
