import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import 'Review.dart';
import 'View_Completed.dart';
import 'package:google_fonts/google_fonts.dart';

class InformCompleted extends StatefulWidget {
  final int? user; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  InformCompleted({required this.user});

  @override
  State<InformCompleted> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InformCompleted> {
  Set<String> uniqueInformRepairIDs = Set<String>();
  List<ReportRepair>? reportRepair;
  bool? isDataLoaded = false;

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
    print("user-----Com--------${widget.user}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: isDataLoaded == false
              ? CircularProgressIndicator()
              : //ถ้ามีค่าว่างให้ขึ้นตัวหมุนๆ
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: reportRepair?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (reportRepair?[index].status == "กำลังดำเนินการ" ||
                          reportRepair?[index].status == "ยังไม่ได้ดำเนินการ") {
                        return Container();
                      } else {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            // leading: Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     // Icon(Icons.account_box_rounded,color: Colors.red)
                            //   ],
                            // ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                    child: Text("เลขที่รายงานผล",
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        "${reportRepair?[index].report_id}",
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
                                        "${reportRepair?[index].informRepairDetails?.informRepair?.informrepair_id}",
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
                                    child: Text("วันที่รายงานผล",
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
                                // Row(children: [
                                //   Expanded(
                                //     child: Text(
                                //       "อุปกรณ์",
                                //        style: GoogleFonts.prompt(
                                //           textStyle: TextStyle(
                                //             color: Color.fromRGBO(0, 0, 0, 1),
                                //             fontSize: 20,
                                //           ),
                                //         )
                                //     ),
                                //   ),
                                //   Expanded(
                                //     child: Text(
                                //       "${reportRepair?[index].informRepairDetails?.roomEquipment?.equipment?.equipmentname}",
                                //       style: const TextStyle(
                                //           fontFamily: 'Itim', fontSize: 20),
                                //     ),
                                //   ),
                                // ]),
                                Row(children: [
                                  Expanded(
                                    child: Text("สถานะ",
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
                              ],
                            ),

                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Reviews(
                                              report_id: reportRepair?[index]
                                                  .report_id,
                                              user: widget.user,
                                            )));
                              },
                              child: Text('ประเมิน',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewCompleted(
                                          report_id:
                                              reportRepair?[index].report_id,
                                          user: widget.user)),
                                );
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),
                )),
    );
  }
}
