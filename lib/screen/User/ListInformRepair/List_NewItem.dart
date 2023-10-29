import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/screen/User/ListInformRepair/View_NewItem.dart';
import '../../../Model/Report_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';

class listNewItem extends StatefulWidget {
  final int? user; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  listNewItem({required this.user});

  @override
  State<listNewItem> createState() => NewInform();
}

class NewInform extends State<listNewItem> {
  List<InformRepair>? informrepairs;
  List<ReportRepair>? reports;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  String formattedDate = '';
  String formattedInformDate = '';
  String searchQuery = '';
  List<InformRepair>? informRepairList;
  int? informDetailsID;

  final InformRepairController informrepairController =
      InformRepairController();
  final InformRepairController informRepairController =
      InformRepairController();

  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
  List<InformRepairDetails>? informRepairDetails;

  void listAllInformRepairDetails() async {
    // เรียกใช้งาน listAllInformRepairDetails และรอข้อมูลเสร็จสมบูรณ์
    informRepairDetails =
        (await informRepairDetailsController.listAllInformRepairDetails())
            .cast<InformRepairDetails>();
    // อัปเดตสถานะแสดงว่าข้อมูลถูกโหลดแล้ว
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? DetailID = [];

  void listAllInformRepair() async {
    informRepairList = await informrepairController.listAllInformRepairs();
    for (int i = 0; i < informRepairList!.length; i++) {
      DetailID?.add(await informrepairController
          .findInformDetailIDById(informRepairList![i].informrepair_id ?? 0));
      print("-------informDetailsID-----${DetailID?[i]}-------------");
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllInformRepair();
    listAllInformRepairDetails();
    print("user-------New-----------${widget.user}");

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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: isDataLoaded == false
              ? CircularProgressIndicator()
              : Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount:
                        informRepairList?.length ?? informRepairList?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (informRepairList?[index].status == "เสร็จสิ้น" ||
                          informRepairList?[index].status == "กำลังดำเนินการ") {
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
                                    child: Text(
                                      "เลขที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepairList?[index].informrepair_id}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "วันที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepairList?[index].informdate}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "สถานะ ",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepairList?[index].status}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 22),
                                    ),
                                  ),
                                ]),
                              ],
                            ),

                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => View_NewItem(
                                            informrepair_id:
                                                informRepairList?[index]
                                                    .informrepair_id,
                                            user: widget.user,
                                          )),
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
