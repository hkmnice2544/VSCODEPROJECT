import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/informrepair_model.dart';
import 'package:flutterr/screen/User/ListInformRepair/View_NewItem.dart';
import 'package:http/http.dart' as http;

class listNewItem extends StatefulWidget {
  const listNewItem({Key? key}) : super(key: key);

  @override
  _listAllInformRepairsState createState() => _listAllInformRepairsState();
}

class _listAllInformRepairsState extends State<listNewItem> {
  List<InformRepair>? informRepairList;
  bool isDataLoaded = false;

  final InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  InformRepairController informRepairController = InformRepairController();

  List<String>? amounts = [];
  void listAllInformRepair() async {
    informRepairList = await informRepairController.listAllInformRepairs();
    for (int i = 0; i < informRepairList!.length; i++) {
      amounts!.add(await informRepairController
          .findSumamountById(informRepairList![i].informrepair_id ?? 0));
    }
    print("------------${informRepairList![0].informrepair_id}-------------");
    informRepairList?.sort((a, b) {
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
    listAllInformRepair();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isDataLoaded == false
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: informRepairList?.length,
                    itemBuilder: (context, index) {
                      if (informRepairList?[index].status == "กำลังดำเนินการ" ||
                          informRepairList?[index].status == "เสร็จสิ้น") {
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
                                      "เลขที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${informRepairList?[index].informrepair_id}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "วันที่แจ้งซ่อม",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepairList?[index].informdate.toString()}",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "จำนวนที่เสียทั้งหมด :",
                                      style: const TextStyle(
                                          fontFamily: 'Itim', fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${amounts![index]}",
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
                                      "${informRepairList?[index].status}",
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => View_NewItem(
                                          informrepair_id:
                                              informRepairList?[index]
                                                  .informrepair_id)),
                                );
                              });
                            },
                          ),
                        );
                      }
                    }),
              ),
      ),
    );
  }
}
