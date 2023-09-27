import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepair_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepiarDetails_Model.dart';
import '../../../model/informrepair_model.dart';
import 'View_NewItem.dart';

class listAllInformRepairs extends StatefulWidget {
  const listAllInformRepairs({super.key});

  @override
  State<listAllInformRepairs> createState() => _listAllInformRepairsState();
}

class _listAllInformRepairsState extends State<listAllInformRepairs> {
  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;
  List<InformRepairDetails>? informrepairsdetails;

  final InformRepairController informController = InformRepairController();
  final InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  // void fetchlistAllInformRepairs() async {
  //   informrepairs = await informController.listAllInformRepairs();
  //   print({informrepairs?[0].informrepair_id});
  //   print({informrepairs});
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
  void listAllinformRepairDetails() async {
    // เรียกใช้งานฟังก์ชันดึงข้อมูลจาก controller
    informrepairsdetails = (await informRepairDetailsController.listAll())
        .cast<InformRepairDetails>();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllinformRepairDetails();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: isDataLoaded == false
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: informrepairsdetails?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // ดึงข้อมูลแต่ละกลุ่ม
                    Map<String, dynamic>? group =
                        informrepairsdetails?[index] as Map<String, dynamic>?;

                    // ดึงข้อมูลแจ้งซ่อม
                    Map<String, dynamic>? informRepair = group?['informRepair'];

                    // ดึงข้อมูลอุปกรณ์ของแจ้งซ่อม
                    List<Map<String, dynamic>>? roomEquipment =
                        group?['roomEquipment'];

                    // ตรวจสอบสถานะและแสดงผลเฉพาะรายการที่ไม่ใช่ "เสร็จสิ้น" หรือ "กำลังดำเนินการ"
                    if (informRepair?['status'] != "เสร็จสิ้น" &&
                        informRepair?['status'] != "กำลังดำเนินการ") {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_circle, color: Colors.red)
                            ],
                          ),
                          title: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "เลขที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair?['informrepair_id']}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "วันที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair?['informdate']}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "สถานะ ",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair?['status']}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing:
                              const Icon(Icons.zoom_in, color: Colors.red),
                          onTap: () {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => View_NewItem(
                                    informrepair_id:
                                        informRepair?['informrepair_id'],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    } else {
                      return Container(); // สร้าง Container ว่างเปล่าเพื่อซ่อนรายการที่มี status เป็น "กำลังดำเนินการ"
                    }
                  },
                ),
              ),
      ),
    );
  }
}
