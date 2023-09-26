import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepair_controller.dart';
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

  final InformRepairController informController = InformRepairController();

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

  @override
  void initState() {
    super.initState();
    // fetchlistAllInformRepairs(); // เรียกใช้งานเมื่อหน้าจอถูกสร้างขึ้นครั้งแรก
    print({informrepairs});
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
              :
              //ถ้ามีค่าว่างให้ขึ้นตัวหมุนๆ
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: informrepairs?.length,
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
                            trailing:
                                const Icon(Icons.zoom_in, color: Colors.red),
                            onTap: () {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => View_NewItem(
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
