import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepiarDetailsList_Model.dart';
import 'package:flutterr/screen/User/ListInformRepair/View_NewItem.dart';
import 'package:http/http.dart' as http;

class listNewItem extends StatefulWidget {
  const listNewItem({Key? key}) : super(key: key);

  @override
  _listAllInformRepairsState createState() => _listAllInformRepairsState();
}

class _listAllInformRepairsState extends State<listNewItem> {
  List<InformRepairDetailsList>? informRepairDetailsList;
  bool isDataLoaded = false;

  final InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  void listAllInformRepairDetails() async {
    informRepairDetailsList = await informRepairDetailsController.fetchData();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllInformRepairDetails();
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
                  itemCount: informRepairDetailsList?.length,
                  itemBuilder: (context, index) {
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
                                  " ${informRepairDetailsList?[index].informrepair_id}",
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
                                  "${informRepairDetailsList?[index].informDate.toString()}",
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
                                  "${informRepairDetailsList?[index].totalAmount.toString()}",
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
                                  "${informRepairDetailsList?[index].status}",
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 20),
                                ),
                              ),
                            ]),
                          ],
                        ),
                        onTap: () {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => View_NewItem(
                                      informrepair_id:
                                          informRepairDetailsList?[index]
                                              .informrepair_id)),
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
