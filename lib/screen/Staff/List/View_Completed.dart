import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import '../../User/ListInformRepair/ListInformRepair.dart';
import 'ListManage.dart';

class ViewCompleted extends StatefulWidget {
  final int? informrepair_id;
  const ViewCompleted({
    super.key,
    this.informrepair_id,
    int? report_id,
  });

  @override
  State<ViewCompleted> createState() => _ViewCompletedState();
}

class _ViewCompletedState extends State<ViewCompleted> {
  final InformRepairController informRepairController =
      InformRepairController();

  InformRepair? informRepair = null;

  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  // void getInform(int informrepair_id) async {
  //   informRepair = await informRepairController.getInform(informrepair_id);
  //   print("getInform : ${informRepair?.informrepair_id}");
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // if (widget.informrepair_id != null) {
    //   getInform(widget.informrepair_id!);
    // }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า รายละเอียดการแจ้งซ่อม",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
              fontWeight: FontWeight.w100),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListInformRepair();
            }));
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 245, 59, 59),
        height: 50,
        shape: CircularNotchedRectangle(), // รูปร่างของแถบ

        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.home),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Home(username: 'ชื่อผู้ใช้');
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "หน้าแรก",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              Expanded(child: Text("                           ")),
              Expanded(
                child: IconButton(
                    icon: Icon(Icons.logout),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              )
            ]),
      ),
      backgroundColor: Colors.white,
      body:

          // isDataLoaded == false?
          // CircularProgressIndicator() : //คือตัวหมนุๆ
          Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Center(
          child: Column(children: [
            Center(
              child: Text(
                "รายละเอียด",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 94, 53),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'images/View_Inform.png',
              // fit: BoxFit.cover,
              width: 220,
              alignment: Alignment.center,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "เลขที่แจ้งซ่อม  :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informRepair?.informrepair_id}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "วันที่แจ้งซ่อม  :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informRepair?.informdate}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Expanded(
                //   child: Text(
                //     "ประเภทห้องน้ำ   :",
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     informRepair?.equipment?.rooms != null
                //         ? informRepair!.equipment!.rooms!
                //             .map((room) => room.roomname!)
                //             .join(', ')
                //         : 'N/A',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "อาคาร   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     informRepair?.equipment?.rooms != null
                //         ? informRepair!.equipment!.rooms!
                //             .map((room) => room.building?.buildingname ?? 'N/A')
                //             .join(', ')
                //         : 'N/A',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ชั้น   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     informRepair?.equipment?.rooms != null
                //         ? informRepair!.equipment!.rooms!
                //             .map((room) => room.floor ?? 'N/A')
                //             .join(', ')
                //         : 'N/A',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ตำแหน่ง   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     informRepair?.equipment?.rooms != null
                //         ? informRepair!.equipment!.rooms!
                //             .map((room) => room.position ?? 'N/A')
                //             .join(', ')
                //         : 'N/A',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                Text(
                  "อุปกรณ์ชำรุด",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "-----------------------------------",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Text(
            //       "${informRepair?.equipment?.equipmentname}",
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "รายละเอียด   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "informRepair?.informdetails",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text(
                "ย้อนกลับ",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // var response = await reviewController.addReview(
                //   reviewer,
                //   _rating != null ? _rating.toString() : "", // แปลง _rating เป็น String
                //   textEditingController.text,
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListManage();
                  }),
                );
              },
            ),
          ),
          SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
