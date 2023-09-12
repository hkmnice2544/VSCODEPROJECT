import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

import '../../Model/informrepair_model.dart';
import '../../controller/informrepair_controller.dart';
import 'Detail.dart';

class Addinform extends StatefulWidget {
  const Addinform({super.key});

  @override
  State<Addinform> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addinform> {
  final ImagePicker _imagePicker = ImagePicker();
  late List<String> imageUrls; // เก็บ URL ของรูปภาพ
  TextEditingController detailController1 = TextEditingController();
  TextEditingController detailController2 = TextEditingController();
  TextEditingController detailController3 = TextEditingController();
  TextEditingController idController1 = TextEditingController();
  TextEditingController idController2 = TextEditingController();
  TextEditingController idController3 = TextEditingController();
  TextEditingController imageController1 = TextEditingController();

  final InformRepairController informController = InformRepairController();

  File? pickedFile; // ประกาศตัวแปร pickedFile และกำหนดเริ่มต้นเป็น null
  String? pickedFileName; // เพิ่มตัวแปรเพื่อเก็บชื่อของไฟล์ที่เลือก
  List<InformRepair>? informrepairs;

  void fetchInformRepairs() async {
    informrepairs = await informController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    print(
        "getInform ปัจจุบัน : ${informrepairs?[informrepairs!.length - 1].informrepair_id}");
  }

  @override
  void initState() {
    super.initState();
    fetchInformRepairs();
    imageUrls = []; // กำหนดรายการ URL รูปภาพเริ่มต้นเป็นว่าง
    pickedFile = null; // กำหนด pickedFile เป็น null เมื่อ initState
    pickedFileName = null; // กำหนด pickedFileName เป็น null เมื่อ initState
  }

  void _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        List<File> pickedFiles = result.files
            .map((platformFile) => File(platformFile.path!))
            .toList(); // เก็บรายการของไฟล์ที่เลือก

        pickedFile =
            pickedFiles.isNotEmpty ? pickedFiles[0] : null; // เก็บไฟล์ที่เลือก
        pickedFileName = pickedFiles.isNotEmpty
            ? path.basename(pickedFiles[0].path) // ดึงชื่อไฟล์แบบสั้นออกมา
            : null; // เก็บชื่อไฟล์ที่เลือก
      });
    } else {
      setState(() {
        pickedFile = null; // ตั้งค่า pickedFile เป็น null เมื่อไม่มีการเลือกรูป
        pickedFileName =
            null; // ตั้งค่า pickedFileName เป็น null เมื่อไม่มีการเลือกรูป
      });

      // ผู้ใช้ไม่ได้เลือกรูปภาพ หรือเกิดข้อผิดพลาดอื่น ๆ
      print('ผู้ใช้ไม่ได้เลือกรูปภาพ หรือเกิดข้อผิดพลาดอื่น ๆ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า InformRepairToilet",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 21,
            fontWeight: FontWeight.w100,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController1,
              decoration: InputDecoration(
                labelText: 'Equipment_id1',
              ),
              onChanged: (value) {},
            ),
            TextField(
              controller: detailController1,
              decoration: InputDecoration(
                labelText: 'รายละเอียด1',
              ),
              onChanged: (value) {},
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('อัปโหลดรูปภาพ'),
            ),
            if (pickedFile != null &&
                pickedFileName !=
                    null) // ตรวจสอบว่ามีรูปภาพที่ถูกเลือกและมีชื่อไฟล์
              Column(
                children: [
                  Image.file(
                    pickedFile!,
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    'ชื่อไฟล์: $pickedFileName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            TextField(
              controller: idController2,
              decoration: InputDecoration(
                labelText: 'Equipment_id2',
              ),
              onChanged: (value) {},
            ),
            TextField(
              controller: detailController2,
              decoration: InputDecoration(
                labelText: 'รายละเอียด2',
              ),
              onChanged: (value) {},
            ),
            TextField(
              controller: idController3,
              decoration: InputDecoration(
                labelText: 'Equipment_id3',
              ),
              onChanged: (value) {},
            ),
            TextField(
              controller: detailController3,
              decoration: InputDecoration(
                labelText: 'รายละเอียด3',
              ),
              onChanged: (value) {},
            ),
            ElevatedButton(
                onPressed: () async {
                  // ดึงค่า ID และรายละเอียดจาก TextField
                  String id1 = idController1.text;
                  String detail1 = detailController1.text;
                  String id2 = idController2.text;
                  String detail2 = detailController2.text;
                  String id3 = idController3.text;
                  String detail3 = detailController3.text;

                  // สร้างรายการ ID และรายละเอียดที่มีค่าไม่เป็นว่าง
                  List<Map<String, dynamic>> idDetailsList = [];
                  if (id1.isNotEmpty && detail1.isNotEmpty) {
                    idDetailsList.add({"id": id1, "detail": detail1});
                  }
                  if (id2.isNotEmpty && detail2.isNotEmpty) {
                    idDetailsList.add({"id": id2, "detail": detail2});
                  }
                  if (id3.isNotEmpty && detail3.isNotEmpty) {
                    idDetailsList.add({"id": id3, "detail": detail3});
                  }

                  if (idDetailsList.isNotEmpty) {
                    // สร้างข้อมูล JSON จากรายการ ID และรายละเอียด
                    List<Map<String, dynamic>> newInformData = [];
                    idDetailsList.forEach((idDetail) {
                      Map<String, dynamic> informData = {
                        "informdetails": idDetail["detail"],
                        "status": "ยังไม่ได้ดำเนินการ",
                        "equipment_id": idDetail["id"],
                      };
                      newInformData.add(informData);
                    });

                    await informController.addInformRepair(newInformData);

                    // หลังจากเรียกใช้ addInformRepair และเพิ่มข้อมูลรายงานเรียบร้อยแล้ว
                    // คุณสามารถเพิ่มรูปภาพโดยเรียกใช้ addPicturesToDatabase ดังนี้

                    List<String> pictureUrls = ['$pickedFileName'];

                    // รายการ URL ของรูปภาพที่คุณต้องการเพิ่ม
                    int? informRepairId =
                        (informrepairs?[informrepairs!.length - 1]
                                    ?.informrepair_id ??
                                0) +
                            1; // ตั้งค่า ID ของ InformRepair ที่เกี่ยวข้อง

                    await informController.addPicturesToDatabase(
                        pictureUrls, informRepairId!);

                    // หลังจากเพิ่มข้อมูลเสร็จสิ้น คุณสามารถทำอย่างอื่นตามที่ต้องการ เช่น นำผู้ใช้ไปยังหน้า Details
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Details();
                    }));
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color.fromARGB(255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                  textStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                  ),
                ),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                )),
          ],
        ),
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text("List"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Details();
                  }),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
