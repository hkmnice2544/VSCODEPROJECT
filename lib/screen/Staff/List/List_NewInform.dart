import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Model/Report_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import 'ReportInform.dart';
import 'View_NewInform.dart';

class listNewInform extends StatefulWidget {
  const listNewInform({super.key});

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
  List<InformRepair>? searchResults;

  final InformRepairController informrepairController =
      InformRepairController();

  void fetchInformRepairs() async {
    informrepairs = await informrepairController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    print("ID : ${informrepairs?[informrepairs!.length - 1].informrepair_id}");
    // print(informRepairs?.defectiveequipment);
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
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInformRepairs();
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
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'ค้นหาเลขที่แจ้งซ่อม',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      if (searchQuery.isNotEmpty) {
                        searchResults = informrepairs
                            ?.where((informrepair) =>
                                informrepair.informrepair_id.toString() ==
                                searchQuery)
                            .toList();
                      } else {
                        searchResults = null; // เมื่อค่าค้นหาเป็นว่าง
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults?.length ?? informrepairs?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (informrepairs?[index].status == "เสร็จสิ้น" ||
                        informrepairs?[index].status == "กำลังดำเนินการ") {
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
                                    "${informrepairs?[index].informrepair_id}",
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
                                    "${informrepairs?[index].informdate}",
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
                                    "${informrepairs?[index].status}",
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 22),
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
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ViewNewInform(
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
              )
            ]),
    ));
  }
}
