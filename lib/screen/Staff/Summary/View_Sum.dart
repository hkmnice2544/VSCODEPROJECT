import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/controller/report_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/Report_Model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/Summary/Sammary.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';

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
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
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

  List<InformRepairDetails> informDetails = [];
  List<ReportRepair> results = [];
  Future getInformDetails(int informrepair_id) async {
    List<InformRepairDetails> result = await informRepairDetailsController
        .getInformDetailsById(informrepair_id);
    for (int i = 0; i < result.length; i++) {
      informDetails.add(result[i]);
    }
    results = await reportController.ViewListInformDetails(
        result[0].informRepair!.informrepair_id!);

    print(
        "------ส่งresults ${results?[0].informRepairDetails?.informRepair?.informrepair_id}--------");
    setState(() {
      isDataLoaded = true;
    });
  }

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
    getInformDetails(widget.informrepair_id!);
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
      body:

          // isDataLoaded == false?
          // CircularProgressIndicator() : //คือตัวหมนุๆ
          Padding(
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
                    isDataLoaded! &&
                            informDetails != null &&
                            informDetails.isNotEmpty
                        ? informDetails[0].informRepair?.informrepair_id != null
                            ? informDetails[0]
                                .informRepair!
                                .informrepair_id
                                .toString()
                            : 'N/A'
                        : 'Loading...', // แสดง 'Loading...' เมื่อข้อมูลยังไม่พร้อม
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
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.formattedInformDate() ?? 'N/A' : 'Loading...'}",
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
                    "ประเภทห้องน้ำ   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.roomname ?? 'N/A' : 'Loading...'}",
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
                    "อาคาร   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.building?.buildingname ?? 'N/A' : 'Loading...'}",
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
                    "ชั้น   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.floor ?? 'N/A' : 'Loading...'}",
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
                    "ตำแหน่ง   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.position ?? 'N/A' : 'Loading...'}",
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
                    "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.status ?? 'N/A' : 'Loading...'}",
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
                    "วันที่รายงานผล   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${results != null && results.isNotEmpty ? results[0]?.formattedInformDate() ?? 'ยังไม่มีข้อมูล' : 'ยังไม่มีข้อมูล'}",
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
                    "${results != null && results.isNotEmpty ? results[0]?.repairer ?? 'ยังไม่มีข้อมูล' : 'ยังไม่มีข้อมูล'}",
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
                Text(
                  "อุปกรณ์ชำรุด",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "-----------------------------------",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap:
                  true, // ตั้งค่า shrinkWrap เป็น true เพื่อให้ ListView ย่อเข้าตัวเมื่อมีเนื้อหาน้อย
              itemCount: informDetails.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                        title: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(children: [
                            Expanded(
                              child: Text(
                                "อุปกรณ์ :",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 22),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[index]?.roomEquipment?.equipment?.equipmentname ?? 'N/A' : 'Loading...'}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 22),
                              ),
                            ),
                          ]),
                          Row(children: [
                            Expanded(
                              child: Text(
                                "รายละเอียด :",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 22),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[index]?.details ?? 'N/A' : 'Loading...'}",
                                style: const TextStyle(
                                    fontFamily: 'Itim', fontSize: 22),
                              ),
                            ),
                          ]),
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

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                // Button Click
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Summary(user: widget.user)),
                        );
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
