import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import 'Review.dart';
import 'View_Completed.dart';

class InformCompleted extends StatefulWidget {
  const InformCompleted({super.key});

  @override
  State<InformCompleted> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InformCompleted> {
  List<ReportRepair>? reportRepair;
  bool? isDataLoaded = false;

  final ReportController reportController = ReportController();

  void listAllReportRepair() async {
    reportRepair = await reportController.listAllReportRepairs();
    print({reportRepair?[0].report_id});
    // print(informRepairs?.defectiveequipment);
    reportRepair?.sort((a, b) {
      if (a.reportdate == null && b.reportdate == null) {
        return 0;
      } else if (a.reportdate == null) {
        return 1;
      } else if (b.reportdate == null) {
        return -1;
      }
      return b.reportdate!.compareTo(a.reportdate!);
    });
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllReportRepair();
    reportRepair?.sort((a, b) {
      if (a.reportdate == null && b.reportdate == null) {
        return 0;
      } else if (a.reportdate == null) {
        return 1;
      } else if (b.reportdate == null) {
        return -1;
      }
      return b.reportdate!.compareTo(a.reportdate!);
    });
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
                      if (reportRepair?[index]
                              .informRepairDetails
                              ?.informRepair
                              ?.status ==
                          "กำลังดำเนินการ") {
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
                            //     // Icon(Icons.account_box_rounded,color: Colors.red)
                            //   ],
                            // ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "เลขที่รายงานผล",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${reportRepair?[index].report_id}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "เลขที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${reportRepair?[index].informRepairDetails?.informRepair?.informrepair_id}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "เสร็จสิ้นวันที่ ",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${reportRepair?[index].enddate}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "สถานะ",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${reportRepair?[index].informRepairDetails?.informRepair?.status}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                              ],
                            ),

                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Review(
                                            report_id: reportRepair?[index]
                                                .report_id)));
                              },
                              child: Text('ประเมิน'),
                            ),
                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewCompleted(
                                          report_id:
                                              reportRepair?[index].report_id)),
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
