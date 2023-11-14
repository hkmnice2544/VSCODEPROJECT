import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/report_controller.dart';
import 'package:flutterr/model/Report_Model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/Summary/Sammary.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Login.dart';
import 'package:google_fonts/google_fonts.dart';

class View_Sum extends StatefulWidget {
  final int? informrepair_id;
  final int? user;
  const View_Sum({super.key, this.informrepair_id, this.user});

  @override
  State<View_Sum> createState() => _ViewResultState();
}

class _ViewResultState extends State<View_Sum> {
  final InformRepairController informController = InformRepairController();
  final ReportController reportController = ReportController();
  InformRepair? informRepair;
  List<InformRepair>? informrepairs;
  ReportRepair? reportRepair;
  List<ReportRepair>? reportRepairs;

  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  // void fetchlistAllInformRepairs() async {
  //   informrepairs = await informController.listAllInformRepairs();
  //   print({informrepairs?[0].informrepair_id});
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  void getReportRepair(int report_id) async {
    reportRepair = await reportController.getReportRepair(report_id);
    print("getreportRepair : ${reportRepair?.report_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  // List<InformRepairDetails> informDetails = [];
  // List<ReportRepair> results = [];
  // Future getInformDetails(int informrepair_id) async {
  //   List<InformRepairDetails> result = await informRepairDetailsController
  //       .getInformDetailsById(informrepair_id);
  //   for (int i = 0; i < result.length; i++) {
  //     informDetails.add(result[i]);
  //   }
  //   results = await reportController.ViewListInformDetails(
  //       result[0].informRepair!.informrepair_id!);

  //   print(
  //       "------ส่งresults ${results?[0].informRepairDetails?.informRepair?.informrepair_id}--------");
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  // Future ViewListInformDetails(int informdetails_id) async {

  //   print(
  //       "------ส่งinformdetails_id ${result[0].informRepairDetails?.informdetails_id}--------");
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  // void getInform(int informrepair_id) async {
  //   informRepair = await .getInform(informrepair_id);
  //   print("getInform : ${informRepair?.informrepair_id}");
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // fetchlistAllInformRepairs();
    // if (widget.informrepair_id != null) {
    //   getInform(widget.informrepair_id!);
    // }
    if (widget.informrepair_id != null) {
      getReportRepair(widget.informrepair_id!);
    }
    // getInformDetails(widget.informrepair_id!);
    // ViewListByinformrepair_id(widget.informrepair_id!);
    print(widget.informrepair_id!);
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
              return ListInformRepair();
            }));
          },
        ),
      ),
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
      backgroundColor: Colors.white,
      body: isDataLoaded == false
          ? Center(
              child: Text(
                "ยังไม่มีข้อมูล",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 94, 53),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : //คือตัวหมนุๆ
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Center(
                  child: Column(children: [
                    Center(
                      child: Text(
                        "รายละเอียด",
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 94, 53),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Image.asset(
                    //   'images/View_Inform.png',
                    //   // fit: BoxFit.cover,
                    //   width: 220,
                    //   alignment: Alignment.center,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 400,
                        height: 380,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 400,
                                height: 380,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(32, 41, 111, 29),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
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
                                        child: Icon(
                                          Icons.list, // เปลี่ยนไอคอนตรงนี้
                                          color: Color.fromARGB(
                                              255, 7, 94, 53), // สีไอคอน
                                          // ขนาดไอคอน
                                        ),
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
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.informrepair!.informrepair_id ?? 'N/A' : 'N/A'}',
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
                                        child: Icon(
                                          Icons.date_range,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
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
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.formattedInformDate() ?? 'N/A' : 'N/A'}',
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
                                        child: Icon(
                                          Icons.ballot_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'ประเภทห้องน้ำ  :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.informrepair!.equipment!.room!.roomtype ?? 'N/A' : 'N/A'}',
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
                                        child: Icon(
                                          Icons.business,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'อาคาร   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.informrepair!.equipment!.room!.building!.buildingname ?? 'N/A' : 'N/A'}',
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
                                        child: Icon(
                                          Icons.bento_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'ชั้น   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.informrepair!.equipment!.room!.floor ?? 'N/A' : 'N/A'}',
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
                              top: 210,
                              child: SizedBox(
                                width: 450,
                                height: 90,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.place_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'ตำแหน่ง   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.informrepair!.equipment!.room!.position ?? 'N/A' : 'N/A'}',
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
                              top: 250,
                              child: SizedBox(
                                width: 450,
                                height: 90,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.place_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'สถานะ   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.status ?? 'N/A' : 'Loading...'}',
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
                              top: 290,
                              child: SizedBox(
                                width: 450,
                                height: 90,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.place_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'วันที่รายงานผล   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.formattedstatusdateDate() ?? 'ยังไม่มีข้อมูล' : 'ยังไม่มีข้อมูล'}',
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
                              top: 330,
                              child: SizedBox(
                                width: 450,
                                height: 90,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.place_outlined,
                                          color: Color.fromARGB(255, 7, 94, 53),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'ผู้ซ่อม   :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
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
                                            '${reportRepair != null ? reportRepair!.repairer ?? 'ยังไม่มีข้อมูล' : 'ยังไม่มีข้อมูล'}',
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 450,
                        height: 50,
                        child: Stack(children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 450,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(7, 94, 53, 1)),
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
                            left: 20,
                            top: 11,
                            child: SizedBox(
                              width: 400,
                              height: 27,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.build,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'อุปกรณ์ชำรุด',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap:
                          true, // ตั้งค่า shrinkWrap เป็น true เพื่อให้ ListView ย่อเข้าตัวเมื่อมีเนื้อหาน้อย
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        int displayIndex = index + 1;
                        return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                                title: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                        "รายการที่ : ${displayIndex}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 7, 94, 53),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                        "อุปกรณ์ :",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${reportRepair?.informrepair!.equipment!.equipmentname}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                        "รายละเอียด :",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${reportRepair?.informrepair!.details}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Center(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: Image.network(
                                        baseURL +
                                            '/informrepairs/image/${reportRepair!.informrepair!.pictures}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Wrap(
                                  //   spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
                                  //   runSpacing:
                                  //       8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
                                  //   children: List.generate(
                                  //     1,
                                  //     (index) {
                                  //       final informPicture =
                                  //           pictures!.firstWhere(
                                  //         (inform) {
                                  //           final parts = inform.split(',');
                                  //           return parts.length == 2 &&
                                  //               parts[0] == "1002";
                                  //         },
                                  //         orElse: () => "",
                                  //       );

                                  //       if (informPicture != null) {
                                  //         final parts = informPicture.split(',');
                                  //         final imageName = parts[1];
                                  //         return Container(
                                  //           width: 200,
                                  //           height: 350,
                                  //           child: Image.network(
                                  //             baseURL +
                                  //                 '/informrepairdetails/image/$imageName',
                                  //             fit: BoxFit.cover,
                                  //           ),
                                  //         );
                                  //       } else {
                                  //         return Container(); // หากไม่พบข้อมูลรูปภาพสำหรับอุปกรณ์นี้
                                  //       }
                                  //     },
                                  //   ),
                                  // )
                                ])));
                      },
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "${informRepair?.equipment?.equipmentname}",
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Summary(user: widget.user)),
                  );
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
