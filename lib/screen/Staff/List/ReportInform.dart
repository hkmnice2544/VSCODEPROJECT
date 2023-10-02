import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/controller/report_pictures_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/Report_pictures_Model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import '../../User/ListInformRepair/ListInformRepair.dart';
import 'ListManage.dart';
import 'package:http/http.dart' as http;

class ReportInform extends StatefulWidget {
  final int? detailId;
  final int? user;
  const ReportInform({
    super.key,
    required this.detailId,
    required this.user,
    int? report_id,
  });

  @override
  State<ReportInform> createState() => _ReportInformState();
}

class _ReportInformState extends State<ReportInform> {
  final InformRepairController informRepairController =
      InformRepairController();
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
  Report_PicturesController report_picturesController =
      Report_PicturesController();

  ReportController reportController = ReportController();

  TextEditingController detailsTextController = TextEditingController();

  InformRepair? informRepair;
  List<ReportRepair>? reports;
  InformRepairDetails? informRepairDetail;

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

  String? statusroomEquipmentId;

  final _repairerList = ["นายอนุวัฒน์ คำเมืองลือ", "นายรชานนท์ พรหมมา"];
  final _statusList = ["กำลังดำเนินการ", "เสร็จสิ้น"];

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];
  int selectedImageCount = 0;

  List<File> _selectedImages = [];

  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      selectedImageCount += selectedImages.length;
      imageFileList.addAll(selectedImages);
      // เพิ่มรูปภาพที่เลือกเข้า _selectedImages
      _selectedImages.addAll(selectedImages.map((image) => File(image.path)));
    }
    setState(() {});
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isNotEmpty) {
      final uri = Uri.parse(baseURL + '/report_pictures/uploadMultiple');
      final request = http.MultipartRequest('POST', uri);

      for (final image in _selectedImages) {
        final file = await http.MultipartFile.fromPath(
          'files',
          image.path,
          filename: image.path.split('/').last,
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        print('รูปภาพถูกอัพโหลดและข้อมูลถูกบันทึกเรียบร้อย');
        // เพิ่มโค้ดหลังการอัพโหลดสำเร็จ
      } else {
        print('เกิดข้อผิดพลาดในการอัพโหลดและบันทึกไฟล์');
        // เพิ่มโค้ดหลังการอัพโหลดไม่สำเร็จ
      }
    }
  }

  void getInformDetailsById(int informdetails_id) async {
    informRepairDetail = await informRepairDetailsController
        .getviewInformDetailsById(informdetails_id);
    setState(() {
      isDataLoaded = true;
    });
  }

  void listAllReportRepairs() async {
    reports = await reportController.listAllReportRepairs();
    print({reports?[0].report_id});
    print("getreports ปัจจุบัน : ${reports?[reports!.length - 1].report_id}");
    print(
        "getreports +1 : ${(reports?[reports!.length - 1].report_id ?? 0) + 1}");

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllReportRepairs();
    if (widget.detailId != null) {
      getInformDetailsById(widget.detailId! as int);
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd' ' HH:mm:ss.000').format(now);

    print(widget.detailId);
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
                          return HomeStaff(user: 0);
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
                    "${informRepairDetail?.informRepair?.informrepair_id}",
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
                    "${informRepairDetail?.informRepair?.informdate}",
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
                        if (_dropdownstatus == "กำลังดำเนินการ") {
                          statusroomEquipmentId = "กำลังซ่อม";
                        } else if (_dropdownstatus == "เสร็จสิ้น") {
                          statusroomEquipmentId = "ดี";
                        }
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
                Expanded(
                  child: MaterialButton(
                      color: Color.fromARGB(255, 243, 103, 33),
                      child: Text(
                        "อัปโหลดรูปภาพ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _selectImages();
                        _uploadImages();
                        print('imageFileNames----${imageFileNames}');
                      }),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 คอลัมน์
              ),
              itemCount: imageFileList.length,
              itemBuilder: (BuildContext context, int index) {
                String fileName = imageFileList[index].path.split('/').last;
                imageFileNames.add(fileName); // เพิ่มชื่อไฟล์ลงใน List
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Image.file(File(imageFileList[index].path)),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 79,
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            fileName, // ใช้ชื่อไฟล์แทน
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.highlight_remove_sharp,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // ลบรูปออกจาก imageFileList
                            setState(() {
                              imageFileList.removeAt(index);
                            });
                            // ลบชื่อรูปภาพที่เกี่ยวข้องออกจาก imageFileNames
                            String fileNameToRemove = imageFileNames[index];
                            imageFileNames.removeWhere(
                                (fileName) => fileName == fileNameToRemove);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                await _uploadImages();
                var response = await reportController.addReport(
                    _dropdownrepairer.toString(),
                    detailsTextController.text,
                    widget.detailId as int,
                    _dropdownstatus.toString(),
                    statusroomEquipmentId.toString());
                final List<Map<String, dynamic>> data = [];

                for (final imageName in imageFileNames) {
                  if (!data.any((item) => item["pictureUrl"] == imageName)) {
                    data.add({
                      "pictureUrl": imageName,
                      "reportrepair": {
                        "report_id":
                            ((reports?[reports!.length - 1].report_id ?? 0) +
                                1),
                      },
                    });
                  }
                }

                final List<Report_pictures> savedInformPictures =
                    await Report_PicturesController.saveReport_pictures(data);
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
