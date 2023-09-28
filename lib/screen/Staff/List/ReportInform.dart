import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Model/Report_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../controller/report_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import '../../User/ListInformRepair/ListInformRepair.dart';
import 'ListManage.dart';

class ReportInform extends StatefulWidget {
  final int? informrepair_id;
  const ReportInform({
    super.key,
    this.informrepair_id,
    int? report_id,
  });

  @override
  State<ReportInform> createState() => _ReportInformState();
}

class _ReportInformState extends State<ReportInform> {
  final InformRepairController informRepairController =
      InformRepairController();

  TextEditingController detailsTextController = TextEditingController();
  final ReportController reportController = ReportController();

  InformRepair? informRepair;
  List<ReportRepair>? reports;

  bool? isDataLoaded = false;
  String formattedDate = '';

  DateTime informdate = DateTime.now();

  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];

  _ReportInformState() {
    //dropdown
    _dropdownrepairer = _repairerList[0];
    _dropdownstatus = _statusList[0];
  }

  String? _dropdownrepairer;
  String? _dropdownstatus;

  final _repairerList = ["นายอนุวัฒน์ คำเมืองลือ", "นายรชานนท์ พรหมมา"];
  final _statusList = ["กำลังดำเนินการ", "เสร็จสิ้น"];

  void getInform(int informrepair_id) async {
    informRepair = await informRepairController.getInform(informrepair_id);
    print("getInform : ${informRepair?.informrepair_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.informrepair_id != null) {
      getInform(widget.informrepair_id!);
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd' ' HH:mm:ss.000').format(now);
  }

  // void _pickImage() {
  //   final input = FileUploadInputElement();
  //   input.accept = 'image/*';
  //   input.multiple = true; // อนุญาตให้เลือกไฟล์หลายไฟล์พร้อมกัน
  //   input.click();

  //   input.onChange.listen((event) {
  //     final files = input.files;
  //     if (files != null && files.isNotEmpty) {
  //       int remainingSlots = 5 - imageBytesList.length;
  //       if (remainingSlots > 0) {
  //         final selectedFiles =
  //             files.sublist(0, min(files.length, remainingSlots));

  //         for (final file in selectedFiles) {
  //           final reader = FileReader();

  //           reader.onLoadEnd.listen((e) {
  //             final bytes = reader.result as Uint8List;
  //             setState(() {
  //               imageBytesList.add(bytes);
  //               imageNames.add(file.name);
  //             });
  //           });

  //           reader.readAsArrayBuffer(file);
  //         }
  //       } else {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text('เกิดข้อผิดพลาด'),
  //             content: Text('คุณสามารถเลือกรูปภาพได้ไม่เกิน 5 รูปเท่านั้น'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('ตกลง'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า รายงานผลการแจ้งซ่อม",
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
          SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Center(
          child: Column(children: [
            Center(
              child: Text(
                "รายงานผลการแจ้งซ่อม",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 94, 53),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'images/Report.png',
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
                Expanded(
                  child: Text(
                    "วันที่รายงานผล   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$formattedDate",
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
                Text(
                  "รายละเอียด",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextField(
              controller: detailsTextController,
              decoration: InputDecoration(
                labelText: 'รายละเอียด',
              ),
              onChanged: (value) {},
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ผู้ซ่อม   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _dropdownrepairer,
                    items: _repairerList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _dropdownrepairer = val!;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.red,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "สถานะ   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _dropdownstatus,
                    items: _statusList
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _dropdownstatus = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.red,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "รูปภาพ   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('เลือกรูปภาพ'),
            // ),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(imageBytesList.length, (index) {
                  final bytes = imageBytesList[index];
                  final imageName = imageNames[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.memory(
                              bytes,
                              width: 200,
                              height: 200,
                            ),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imageBytesList.removeAt(index);
                                    imageNames.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.disabled_by_default_rounded,
                                  color: Colors.red,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text('ชื่อภาพ: $imageName'),
                      ],
                    ),
                  );
                }),
              ),
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
                "ยืนยันรายงาน",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var response = await reportController.addReport(
                    _dropdownrepairer.toString(),
                    detailsTextController.text,
                    informRepair!.informrepair_id as int,
                    _dropdownstatus.toString()
                    // แปลง _rating เป็น String
                    );

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
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text(
                "ยกเลิก",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListManage();
                  }),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
