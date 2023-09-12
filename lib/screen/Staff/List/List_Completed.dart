import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../../../Model/Report_Model.dart';
import '../../../Model/informrepair_model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../controller/listinform_controller.dart';

class ListCompleted extends StatefulWidget {
  const ListCompleted({super.key});

  @override
  State<ListCompleted> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListCompleted> {
  List<InformRepair>? informrepairs;
  InformRepair? informRepairs;
  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  final InformRepairController informController = InformRepairController();

  void fetchlistAllInformRepairs() async {
    informrepairs = await informController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchlistAllInformRepairs();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
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
                      if (informrepairs?[index].status == "กำลังดำเนินการ" ||
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
                                      "เสร็จสิ้นวันที่ ",
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
                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (_) => ViewCompleted(
                                //           report_id:
                                //               reportRepair?[index].report_id)),
                                // );
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
