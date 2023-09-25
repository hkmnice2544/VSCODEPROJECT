import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterr/screen/Staff/List/ReportInform.dart';
import 'package:intl/intl.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../controller/listinform_controller.dart';
import '../../../model/informrepair_model.dart';
import 'View_Actualize.dart';

class ListActualize extends StatefulWidget {
  const ListActualize({super.key});

  @override
  State<ListActualize> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListActualize> {
  List<InformRepair>? informrepairs;
  InformRepair? informRepairs;
  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  final InformRepairController informController = InformRepairController();

  // void fetchlistAllInformRepairs() async {
  //   informrepairs = await informController.listAllInformRepairs();
  //   print({informrepairs?[0].informrepair_id});
  //   informrepairs?.sort((a, b) {
  //     if (a.informdate == null && b.informdate == null) {
  //       return 0;
  //     } else if (a.informdate == null) {
  //       return 1;
  //     } else if (b.informdate == null) {
  //       return -1;
  //     }
  //     return b.informdate!.compareTo(a.informdate!);
  //   });
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // fetchlistAllInformRepairs();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
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
                    itemCount: informrepairs?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (informrepairs?[index].status == "เสร็จสิ้น" ||
                          informrepairs?[index].status ==
                              "ยังไม่ได้ดำเนินการ") {
                        return Container(); // สร้าง Container ว่างเปล่าเพื่อซ่อนรายการที่มี status เป็น "กำลังดำเนินการ"
                      } else {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.run_circle_outlined,
                                    color: Colors.red)
                              ],
                            ),
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
                                      "${informrepairs?[index].informrepair_id}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "วันที่ดำเนินการ ",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informrepairs?[index].informdate}",
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
                                      "${informrepairs?[index].status}",
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
                                      builder: (_) => ReportInform(
                                          informrepair_id: informrepairs?[index]
                                              .informrepair_id),
                                    ));
                              },
                              child: Text('รายงานผล'),
                            ),
                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewActualize(
                                          informrepair_id: informrepairs?[index]
                                              .informrepair_id)),
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
