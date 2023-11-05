import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import '../../../Model/Report_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import 'ReportInform.dart';
import 'View_NewInform.dart';
import 'package:google_fonts/google_fonts.dart';

class listNewInform extends StatefulWidget {
  final int? user;
  const listNewInform({
    super.key,
    required this.user,
  });

  @override
  State<listNewInform> createState() => NewInform();
}

class NewInform extends State<listNewInform> {
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
  List<InformRepairDetails>? informRepairDetailsList;

  // void listAllInformRepairDetails() async {
  //   // เรียกใช้งาน listAllInformRepairDetails และรอข้อมูลเสร็จสมบูรณ์
  //   informRepairDetails =
  //       (await informRepairDetailsController.listAllInformRepairDetails())
  //           .cast<InformRepairDetails>();
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  void ViewListInformListInformDetailsGroupbyinformrepair_idDetails() async {
    // เรียกใช้งาน listAllInformRepairDetails และรอข้อมูลเสร็จสมบูรณ์
    informRepairDetailsList = (await informRepairDetailsController
            .ViewListInformListInformDetailsGroupbyinformrepair_idDetails())
        .cast<InformRepairDetails>();
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
    ViewListInformListInformDetailsGroupbyinformrepair_idDetails();

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
          : Column(children: [
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
                //         informRepairDetailsList = null; // เมื่อค่าค้นหาเป็นว่าง
                //       }
                //     });
                //   },
                // ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: informRepairDetailsList?.length ??
                      informRepairList?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (informRepairDetailsList?[index].informRepair?.status ==
                            "เสร็จสิ้น" ||
                        informRepairDetailsList?[index].informRepair?.status ==
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
                                      "${informRepairDetailsList?[index].informRepair?.informrepair_id}",
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
                                      "${informRepairDetailsList?[index].informRepair?.formattedInformDate()}",
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
                                      "${informRepairDetailsList?[index].informRepair?.status}",
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
                                      "${informRepairList?[index].user?.firstname} ${informRepairList?[index].user!.lastname}",
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
                                    informrepair_id:
                                        informRepairDetailsList?[index]
                                                ?.informRepair
                                                ?.informrepair_id ??
                                            0,
                                    room_id: informRepairDetailsList?[index]
                                            ?.informRepair
                                            ?.room
                                            ?.room_id ??
                                        0,
                                    equipment_id:
                                        informRepairDetailsList?[index]
                                                ?.roomEquipment
                                                ?.equipment
                                                ?.equipment_id ??
                                            0,
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
                          leading: informRepairList?[index].status ==
                                  "ยังไม่ได้ดำเนินการ"
                              ? Icon(Icons.warning,
                                  color: Colors
                                      .red) // สร้าง Icon แสดงสถานะ "ยังไม่ได้ดำเนินการ" ในสีแดง
                              : informRepairList?[index].status == "เสร็จสิ้น"
                                  ? Icon(Icons.check,
                                      color: Colors
                                          .green) // สร้าง Icon แสดงสถานะ "เสร็จสิ้น" ในสีเขียว
                                  : informRepairList?[index].status ==
                                          "กำลังดำเนินการ"
                                      ? Icon(Icons.update,
                                          color: Colors
                                              .blue) // สร้าง Icon แสดงสถานะ "กำลังดำเนินการ" ในสีฟ้า
                                      : null, // ถ้าสถานะไม่ใช่ทั้ง "ยังไม่ได้ดำเนินการ", "เสร็จสิ้น", หรือ "กำลังดำเนินการ" ให้ไม่แสด Icon

                          onTap: () {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ViewNewInform(
                                        informrepair_id:
                                            informRepairDetailsList?[index]
                                                .informRepair
                                                ?.informrepair_id,
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
    ));
  }
}
