import 'package:flutter/material.dart';
import 'package:flutterr/controller/report_controller.dart';
import 'package:flutterr/model/Report_Model.dart';
import '../../../model/informrepair_model.dart';
import 'ReportInform.dart';
import 'View_NewInform.dart';
import 'package:google_fonts/google_fonts.dart';

class ListActualize extends StatefulWidget {
  final int? user;
  const ListActualize({
    super.key,
    required this.user,
  });

  @override
  State<ListActualize> createState() => NewInform();
}

class NewInform extends State<ListActualize> {
  List<InformRepair>? informrepairs;

  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  String formattedDate = '';
  String formattedInformDate = '';
  String searchQuery = '';
  List<InformRepair>? informRepairList;
  int? informDetailsID;

  List<ReportRepair>? reportRepair;
  final ReportController reportController = ReportController();

  void listAllReportRepair() async {
    reportRepair = await reportController.listAllReportRepairs();
    print({reportRepair?[0].report_id});

    reportRepair?.sort((a, b) {
      DateTime? dateA = a.reportdate;
      DateTime? dateB = b.reportdate;

      if (dateA == null && dateB == null) {
        return 0;
      } else if (dateA == null) {
        return 1;
      } else if (dateB == null) {
        return -1;
      }
      return dateB.compareTo(dateA); // คืนค่าลบถ้า B มากกว่า A
    });
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllReportRepair();
    // listAllInformRepairDetails();

    informrepairs?.sort((a, b) {
      if (a.informdate == null && b.informdate == null) {
        return 0;
      } else if (a.informdate == null) {
        return 1;
      } else if (b.informdate == null) {
        return -1;
      }
      return b.informdate!.compareTo(a.informdate!);
    });
    // formattedInformDate = DateFormat('dd-MM-yyyy')
    //     .format(informrepairs?[index].informdate); // ใช้ this.formattedInformDate
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : Container(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: TextField(
                  //   decoration: InputDecoration(
                  //     labelText: 'ค้นหาเลขที่แจ้งซ่อม',
                  //     prefixIcon: Icon(Icons.search),
                  //   ),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       searchQuery = value;
                  //       if (searchQuery.isNotEmpty) {
                  //         informRepairList = informrepairs
                  //             ?.where((informrepair) =>
                  //                 informrepair.informrepair_id.toString() ==
                  //                 searchQuery)
                  //             .toList();
                  //       } else {
                  //         informRepairList = null; // เมื่อค่าค้นหาเป็นว่าง
                  //       }
                  //     });
                  //   },
                  // ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reportRepair?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (reportRepair?[index].status == "เสร็จสิ้น" ||
                          reportRepair?[index].status == "ยังไม่ได้ดำเนินการ") {
                        return Container(); // สร้าง Container ว่างเปล่าเพื่อซ่อนรายการที่มี status เป็น "กำลังดำเนินการ"
                      } else {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            // leading: Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Icon(Icons.account_circle, color: Colors.red)
                            //   ],
                            // ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                    child: Text("เลขที่แจ้งซ่อม",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${reportRepair?[index].informrepair!.informrepair_id}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text("วันที่แจ้งซ่อม",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${reportRepair?[index].formattedInformDate()}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text("สถานะ ",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${reportRepair?[index].status}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text("ผู้แจ้ง ",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${reportRepair?[index].informrepair!.user!.firstname} ${reportRepair?[index].informrepair!.user!.lastname}",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ]),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportInform(
                                      informrepair_id: reportRepair?[index]
                                              .informrepair!
                                              .informrepair_id ??
                                          0,
                                      room_id: reportRepair?[index]
                                              .informrepair!
                                              .equipment!
                                              .room!
                                              .room_id ??
                                          0,
                                      equipment_id: reportRepair?[index]
                                              .informrepair!
                                              .equipment!
                                              .equipment_id ??
                                          0,
                                      report_id:
                                          reportRepair?[index].report_id ?? 0,
                                      user: widget.user ?? 0,
                                    ),
                                  ),
                                );
                              },
                              child: Text('รายงานผล',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  )),
                            ),
                            leading: reportRepair?[index].status ==
                                    "ยังไม่ได้ดำเนินการ"
                                ? Icon(Icons.warning,
                                    color: Colors
                                        .red) // สร้าง Icon แสดงสถานะ "ยังไม่ได้ดำเนินการ" ในสีแดง
                                : reportRepair?[index].status == "เสร็จสิ้น"
                                    ? Icon(Icons.check,
                                        color: Colors
                                            .green) // สร้าง Icon แสดงสถานะ "เสร็จสิ้น" ในสีเขียว
                                    : reportRepair?[index].status ==
                                            "กำลังดำเนินการ"
                                        ? Icon(Icons.update,
                                            color: Colors
                                                .blue) // สร้าง Icon แสดงสถานะ "กำลังดำเนินการ" ในสีฟ้า
                                        : null, // ถ้าสถานะไม่ใช่ทั้ง "ยังไม่ได้ดำเนินการ", "เสร็จสิ้น", หรือ "กำลังดำเนินการ" ให้ไม่แสด Icon

                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewNewInform(
                                          informrepair_id: reportRepair?[index]
                                              .informrepair!
                                              .informrepair_id,
                                          user: widget.user)),
                                );
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ]),
            ),
    ));
  }
}
