import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/report_pictures_controller.dart';
import 'package:flutterr/model/Report_pictures_Model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/List/EditReportform.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import '../../../model/informrepair_model.dart';
import '../../Login.dart';
import '../../User/ListInformRepair/ListInformRepair.dart';
import 'ListManage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class ReportInform extends StatefulWidget {
  final int informrepair_id;
  final int room_id;
  final int equipment_id;
  final int user;
  final int report_id;
  final String screencheck;

  const ReportInform(
      {Key? key,
      required this.informrepair_id,
      required this.room_id,
      required this.equipment_id,
      required this.user,
      required this.report_id,
      required this.screencheck})
      : super(key: key);

  @override
  State<ReportInform> createState() => _ReportInformState();
}

class _ReportInformState extends State<ReportInform> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _commentFieldKey =
      GlobalKey<FormFieldState<String>>();
  final InformRepairController informRepairController =
      InformRepairController();
  Report_PicturesController report_picturesController =
      Report_PicturesController();

  ReportController reportController = ReportController();

  TextEditingController detailsTextController = TextEditingController();

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

  String? statusroomEquipmentId;

  final _repairerList = [
    "กรุณาเลือกผู้รับผิดชอบ",
    "นายอนุวัฒน์ คำเมืองลือ",
    "นายรชานนท์ พรหมมา"
  ];
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

  // void getInformDetailsById(int informrepair_id) async {
  //   informRepairDetail = await informRepairDetailsController
  //       .getviewInformDetailsById(informrepair_id);
  //   print("getinformrepair_id${informRepairDetail?.amount}");
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  void getInform(int informrepair_id) async {
    informRepair = await informRepairController.getInform(informrepair_id);
    print("getInform : ${informRepair?.informrepair_id}");
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

  String formattedCurrentDate() {
    final thailandLocale = const Locale('th', 'TH');
    final outputFormat = DateFormat('dd-MM-yyyy', thailandLocale.toString());
    final now = DateTime.now();
    return outputFormat.format(now);
  }

  @override
  void initState() {
    super.initState();
    listAllReportRepairs();
    getInform(widget.informrepair_id!);
    getReport(widget.report_id!);
    print("informrepair_id${widget.informrepair_id}");
    print("room_id${widget.room_id}");
    print("equipment_id${widget.equipment_id}");
  }

  ReportRepair? reportRepair;
  List<Report_pictures>? report_pictures;
  void getReport(int report_id) async {
    reportRepair = await reportController.getReportRepair(report_id);
    print("getInform : ${reportRepair?.report_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า รายงานผลการแจ้งซ่อม",
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListInformRepair(user: widget.user);
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
                          var username;
                          return HomeStaff(user: widget.user);
                        },
                      ));
                    }),
              ),
              Expanded(
                child: Text(
                  "หน้าแรก",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 94, 53),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
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
                    "เลขที่แจ้งซ่อม :",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.informrepair_id ?? 'N/A'}",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informRepair?.formattedInformDate() ?? 'N/A'}",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    formattedCurrentDate(),
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.screencheck == "screen2"
                ? Row(
                    children: [
                      Text(
                        "ผลการแจ้งซ่อม",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),

            Form(
              key: _formKey,
              child: Row(
                children: [
                  widget.screencheck == "screen2"
                      ? Expanded(
                          child: TextFormField(
                            key: _commentFieldKey,
                            controller: detailsTextController,
                            decoration: InputDecoration(
                              labelText: 'ผลการแจ้งซ่อม',
                            ),
                            validator: (value) {
                              if (value!.isEmpty &&
                                  widget.screencheck == "screen2") {
                                return 'กรุณาป้อนผลการแจ้งซ่อม';
                              }
                              return null;
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "ผู้รับผิดชอบ   :",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                        child: Text(
                          value,
                          style: GoogleFonts.prompt(
                            // กำหนดรูปแบบข้อความด้วย Google Fonts
                            textStyle: TextStyle(
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // สีของข้อความ
                              fontSize: 20, // ขนาดข้อความ
                            ),
                          ),
                        ),
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
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _dropdownstatus,
                    items: _statusList
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e,
                                style: GoogleFonts.prompt(
                                  // กำหนดรูปแบบข้อความด้วย Google Fonts
                                  textStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 0, 0, 0), // สีของข้อความ
                                    fontSize: 20, // ขนาดข้อความ
                                  ),
                                ),
                              ),
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
            widget.screencheck == "screen2"
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          "รูปภาพ   :",
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 7, 94, 53),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                            color: Color.fromARGB(255, 243, 103, 33),
                            child: Text(
                              "อัปโหลดรูปภาพ",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _selectImages();
                              _uploadImages();
                              print('imageFileNames----${imageFileNames}');
                            }),
                      ),
                    ],
                  )
                : SizedBox(),
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
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (imageFileNames.isEmpty &&
                      widget.screencheck == "screen2") {
                    // Show an AlertDialog to inform the user to select an image
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('แจ้งเตือน'),
                          content: Text('กรุณาเลือกรูปภาพ'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ปิด'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the AlertDialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (_dropdownrepairer.toString() ==
                      "กรุณาเลือกผู้รับผิดชอบ") {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('แจ้งเตือน'),
                          content: Text('กรุณาเลือกผู้รับผิดชอบ'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ปิด'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the AlertDialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await _uploadImages();
                    var response = await reportController.addReport(
                      _dropdownrepairer.toString(),
                      detailsTextController.text ?? "",
                      _dropdownstatus.toString(),
                      widget.informrepair_id.toString(),
                    );
                    final List<Map<String, dynamic>> data = [];

                    for (final imageName in imageFileNames) {
                      if (!data
                          .any((item) => item["pictureUrl"] == imageName)) {
                        data.add({
                          "pictureUrl": imageName,
                          "reportrepair": {
                            "report_id":
                                ((reports?[reports!.length - 1].report_id ??
                                        0) +
                                    1),
                          },
                        });
                      }
                    }

                    final List<Report_pictures> savedInformPictures =
                        await Report_PicturesController.saveReport_pictures(
                            data);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ListManage(user: widget.user);
                      }),
                    );
                  }
                }
              },
            ),
          ),
          SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
          widget.screencheck == "screen2"
              ? Container(
                  width: 120, // Set the width of the button here
                  child: FloatingActionButton.extended(
                    label: Text(
                      "แก้ไข",
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditReportInform(
                            informrepair_id: widget.informrepair_id,
                            room_id: widget.room_id,
                            equipment_id: widget.equipment_id,
                            user: widget.user ?? 0,
                          ),
                        ),
                      );

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EditInformRepairs(informrerair_id: informrepairs?[index].informrepair_id)));

                      // Navigator.pushNamed(context, '/one');
                    },
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 120, // Set the width of the button here
              child: FloatingActionButton.extended(
                label: Text(
                  "ยกเลิก",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ListManage(user: widget.user);
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
