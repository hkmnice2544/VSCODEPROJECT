import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/Building_Model.dart';
import 'package:flutterr/screen/User/InformRepairToilet/ResultInformRepair.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../controller/informrepairdetails_controller.dart';
import '../../../model/InformRepairDetails_Model.dart';
import '../../../model/Room_Model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEditRoom extends StatefulWidget {
  final int? user;
  final int? informrepair_id;
  const MyEditRoom({required this.user, required this.informrepair_id});

  @override
  State<MyEditRoom> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyEditRoom> {
  bool isDataLoaded = false;
  String? selectedRoom = '';
  String? buildingId = '';
  List<Building?> buildings = [];
  List<Room?> rooms = [];
  String RoomType = "ห้องเรียนรวม";
  String statusinform = "ยังไม่ได้ดำเนินการ";
  Building? building;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];
  List<bool> isChecked = [];
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  InformRepairController informrepairController = InformRepairController();
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  File? _selectedImages;
  void _addImageForEquipment(String equipmentId) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      if (equipmentImages.containsKey(equipmentId)) {
        //equipmentImages[equipmentId]!.addAll(selectedImages);
      } else {
        //equipmentImages[equipmentId] = selectedImages;
      }
      setState(() {});
    }
  }

  void _addImageForEquipmentNew(String equipmentId) async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      equipmentImages[equipmentId] = selectedImage;
      _selectedImages = File(selectedImage.path);
      details?.forEach((element) {});
      equipmentImages.forEach(
        (key, value) {
          print("KEY : ${key}");
        },
      );
      setState(() {});
    }
  }

  Future<void> _uploadImages(int index) async {
    if (_selectedImages != null) {
      final uri = Uri.parse(baseURL + '/informrepairdetails/upload');
      final request = http.MultipartRequest('POST', uri);

      imageFileNames[index] = _selectedImages?.path.split('/').last ?? "";
      final file = await http.MultipartFile.fromPath(
        'files',
        _selectedImages?.path ?? "",
        filename: imageFileNames[index],
      );
      request.files.add(file);
      // for (final image in _selectedImages) {
      //   print("IMAGE : ${image.path.split('/').last}");

      // }

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

  List<String> equipmentIds = [];
  String? selectedRoomId;
  String? roomIds;
  List<String>? Room_id = [];
  List<String> equipmentName = [];

  Future<void> findequipmentByIdByAll(String selectedRoom) async {
    equipmentIds = await informrepairController
        .findequipment_idByIdByroom_id(selectedRoom);

    for (int i = 0; i < equipmentIds.length; i++) {
      int? equipmentId = int.tryParse(equipmentIds[i]);
      if (equipmentId != null) {
        String name = await informrepairController
            .findequipmentnameByIdByequipment_id(equipmentId)
            .then((value) => value.first);
        equipmentName.add(name);
      }
    }

    print("equipmentIds : $equipmentIds");
    print("equipmentName : $equipmentName");
  }

  Future<void> listAllBuildings() async {
    List<Building?> buildingsList = [];
    buildingsList =
        (await informrepairController.listAllBuildings()).cast<Building>();
    print("listAllBuildings : ${buildingsList[0]!.building_id}");
    setState(() {
      buildings = buildingsList;
    });
  }

  Future<void> findlistRoomByIdBybuilding_id(
      int building_id, String roomtype) async {
    List<Room> listrooms;
    listrooms = await informrepairController.findlistRoomByIdBybuilding_id(
        building_id, roomtype);
    print("rooms : ${listrooms.length}");
    setState(() {
      rooms = listrooms;
    });
  }

  List<InformRepairDetails>? details = [];
  Future<void> findequipment_idByIdByinformrepair_id(
      String informrepair_id) async {
    details =
        await informRepairDetailsController.findByIdByDetails(informrepair_id);
  }

  List<InformRepairDetails>? informRepairDetail = [];
  Future<void> ViewListInformDetails() async {
    informRepairDetail =
        await informRepairDetailsController.ViewListInformDetails(
            widget.informrepair_id!);
    findlistRoomByIdBybuilding_id(
        informRepairDetail![0].informRepair!.room!.building!.building_id as int,
        RoomType.toString());

    findequipmentByIdByAll(
        informRepairDetail![0].informRepair!.room!.room_id.toString());
    setState(() {
      selectedRoom =
          informRepairDetail?[0].roomEquipment!.room!.room_id.toString();
      buildingId = informRepairDetail?[0]
          .roomEquipment!
          .room!
          .building!
          .building_id
          .toString();
      roomIds = informRepairDetail![0].informRepair!.room!.room_id.toString();
      print(" roomIds : ${roomIds}");
      print(" selectedRoom : ${selectedRoom}");
    });
  }

  Future<void> initialize() async {
    informRepairDetail =
        await informRepairDetailsController.ViewListInformDetails(
            widget.informrepair_id!);
    selectedRoom =
        informRepairDetail?[0].roomEquipment!.room!.room_id.toString();
    equipmentIds = await informrepairController
        .findequipment_idByIdByroom_id(selectedRoom.toString());
    print("FT : ${equipmentIds.length}");

    isChecked = List.generate(equipmentIds.length, (index) => false);
    detailscontrollers =
        List.generate(equipmentIds.length, (index) => TextEditingController());
    amountcontrollers =
        List.generate(equipmentIds.length, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า EditInformRepairs",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 21,
            fontWeight: FontWeight.w100,
          ),
        ),
        backgroundColor: Colors.red,
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(user: widget.user), // หน้า A
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
              Expanded(child: Text("         ")),
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
            ],
          )),
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Column(children: [
                    Text(
                      "แก้ไขแจ้งซ่อมห้องน้ำ",
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color.fromRGBO(7, 94, 53, 1),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'images/InformRepairToilet.png',
                      fit: BoxFit.cover,
                      width: 220,
                      alignment: Alignment.center,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: 432,
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 419,
                                height: 160,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(32, 41, 111, 29),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 210,
                              top: 23,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..translate(0.0, 0.0)
                                  ..rotateZ(1.57),
                                child: Container(
                                  width: 120,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: Color.fromRGBO(7, 94, 53, 1),
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 72,
                              top: 20,
                              child: Icon(
                                Icons.favorite, // เปลี่ยนไอคอนตรงนี้
                                color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                                size: 60, // ขนาดไอคอน
                              ),
                            ),
                            Positioned(
                              left: 64,
                              top: 85,
                              child: SizedBox(
                                width: 200,
                                height: 22,
                                child: Text(
                                  'เลขที่แจ้งซ่อม',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(7, 94, 53, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 64,
                              top: 110,
                              child: SizedBox(
                                width: 93,
                                height: 52,
                                child: Text(
                                  '${widget.informrepair_id}',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(7, 94, 53, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 288,
                              top: 20,
                              child: Icon(
                                Icons
                                    .calendar_month_outlined, // เปลี่ยนไอคอนตรงนี้
                                color: Color.fromRGBO(7, 94, 53, 1), // สีไอคอน
                                size: 60, // ขนาดไอคอน
                              ),
                            ),
                            Positioned(
                              left: 279,
                              top: 85,
                              child: SizedBox(
                                width: 81,
                                height: 22,
                                child: Text(
                                  'วันที่แจ้งซ่อม',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(7, 94, 53, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 252,
                              top: 110,
                              child: SizedBox(
                                width: 174,
                                height: 30,
                                child: Text(
                                  '$formattedDate',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(7, 94, 53, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //  //--------------------------------------------

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  'กรุณาเลือกอาคาร',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          value: buildingId,
                          items: [
                            DropdownMenuItem<String>(
                              child: Text(
                                'กรุณาเลือกอาคาร',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              value: '', // หรือค่าว่าง
                            ),
                            ...buildings.map((Building? building) {
                              return DropdownMenuItem<String>(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .business, // ใส่ไอคอนที่คุณต้องการที่นี่
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // สีของไอคอน
                                      size: 24, // ขนาดของไอคอน
                                    ),
                                    SizedBox(
                                        width:
                                            10), // ระยะห่างระหว่างไอคอนและข้อความ
                                    Text(
                                      building!.buildingname ?? '',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                value: building!.building_id.toString(),
                              );
                            }).toList(),
                          ],
                          onChanged: (val) {
                            setState(() {
                              buildingId = val;
                              selectedRoom = '';
                              if (val != '') {
                                print("Controller: $buildingId");
                                findlistRoomByIdBybuilding_id(
                                    int.parse(val!), RoomType);
                              }
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 60,
                            width: 450,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color.fromARGB(66, 255, 255, 255),
                              ),
                              color: Color.fromRGBO(7, 94, 53, 1),
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            iconSize: 30,
                            iconEnabledColor:
                                Color.fromARGB(255, 255, 255, 255),
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 450,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color.fromRGBO(62, 119, 94, 1),
                            ),
                            offset: const Offset(-20, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 30,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  'กรุณาเลือกห้อง',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          value: selectedRoom,
                          items: [
                            DropdownMenuItem<String>(
                              child: Text(
                                'กรุณาเลือกห้อง',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              value: '', // หรือค่าว่าง
                            ),
                            ...rooms.map((Room? room) {
                              return DropdownMenuItem<String>(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .business, // ใส่ไอคอนที่คุณต้องการที่นี่
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // สีของไอคอน
                                      size: 24, // ขนาดของไอคอน
                                    ),
                                    SizedBox(
                                        width:
                                            10), // ระยะห่างระหว่างไอคอนและข้อความ
                                    Text(
                                      "ห้อง " +
                                          room!.room_id.toString() +
                                          " ชั้น " +
                                          room.floor.toString() +
                                          " ตำแหน่ง " +
                                          room.position.toString() +
                                          " " +
                                          room.roomname.toString(),
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                value: room.room_id.toString(),
                              );
                            }).toList(),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedRoom = val;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 60,
                            width: 450,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color.fromARGB(66, 255, 255, 255),
                              ),
                              color: Color.fromRGBO(7, 94, 53, 1),
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            iconSize: 30,
                            iconEnabledColor:
                                Color.fromARGB(255, 255, 255, 255),
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 450,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color.fromRGBO(62, 119, 94, 1),
                            ),
                            offset: const Offset(-20, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    ),

                    ...buildEquipmentWidgets(),
                    SizedBox(
                      height: 80,
                    )
                  ]),
                ),
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120, // Set the width of the button here
              child: FloatingActionButton.extended(
                  label: Text(
                    "ยืนยัน",
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    int? selectedrooom = int.tryParse(selectedRoom!);

                    List<Map<String, dynamic>> data = [];
                    Set<String> uniqueImageFileNames = Set();
                    var result = true;
                    var checkList = 0;
                    for (int i = 0; i < equipmentIds.length; i++) {
                      if (eqCheckBox[i] == true) {
                        result = false;
                        checkList += 1;
                      }
                    }
                    if (buildingId == null || buildingId!.isEmpty) {
                      // Show an AlertDialog to inform the user to select a building
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('แจ้งเตือน'),
                            content: Text('กรุณาเลือกอาคาร'),
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
                    } else if (selectedRoom == null || selectedRoom!.isEmpty) {
                      // Show an AlertDialog to inform the user to select a building
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('แจ้งเตือน'),
                            content: Text('กรุณาเลือกห้อง'),
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
                    } else if (result == true) {
                      // Show an AlertDialog to inform the user to select a building
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('แจ้งเตือน'),
                            content: Text('กรุณาเลือกอุปกรณ์'),
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
                    }

                    // ทำการบันทึกข้อมูลใน dataList

                    for (int i = 0; i < equipmentIds.length; i++) {
                      int? parsedEquipmentId =
                          int.tryParse(arrAmountsTextCon[i].text);
                      int? parsedEquipmentId2 = int.tryParse(equipmentIds[i]);
                      for (int j = 0; j < imageFileNames.length; j++) {}

                      if (eqCheckBox[i]) {
                        print("${arrAmountsTextCon[i]}");
                        var jsonResponse = await informRepairDetailsController
                            .updateInformRepairDetails(
                                parsedEquipmentId ?? 1,
                                arrDetailsTextCon[i].text,
                                details![i].pictures ?? "",
                                widget.informrepair_id!,
                                parsedEquipmentId2 ?? 0,
                                selectedrooom!);
                      }
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ResultInformRepair(
                              informrepair_id: (widget.informrepair_id!),
                              user: widget.user)),
                    );
                  }),
            ),
          ),
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text(
                "ยกเลิก",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ResultInformRepair(
                      informrepair_id: widget.informrepair_id,
                      user: widget.user);
                }));
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Map<String, bool> checkboxStates = {};
  Map<String, String> detailsMap = {};
  Map<String, int> amountMap = {};
  List<String> checkedEquipmentIds = [];
  List<String> checkedDetails = [];
  List<String> listdetails = [];
  List<String> amountLists = [];
  List<String> report_picture = ["B.jpg", "P.jpg"];
  List<String> inform_pictures = [];
  final Map<String, XFile> equipmentImages = {};
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  List<String> selectedEquipmentIds = [];

  bool? loadedYet;

  void allAsync() async {
    final a1 = listAllBuildings();
    final a2 = ViewListInformDetails();
    final a3 = findequipment_idByIdByinformrepair_id(
        widget.informrepair_id.toString());
    final a4 = initialize();

    await Future.wait([a1, a2, a3, a4]);

    print("FINLOAD : ${equipmentIds.length}");
    await Future.delayed(Duration(seconds: 1));

    //await Future.delayed(Duration(seconds: 1));

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    allAsync();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    print("FT2 : ${equipmentIds.length}");
    print("imageFileNames : ${imageFileNames}");
  }

  //Additional code

  List<Widget> newwidgets = [];
  List<bool> eqCheckBox = [];
  List<TextEditingController> arrDetailsTextCon = [];
  List<TextEditingController> arrAmountsTextCon = [];

  List<Widget> buildEquipmentWidgets() {
    List<Widget> widgets = [];

    widgets.add(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 450,
          height: 50,
          child: Stack(children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 450,
                height: 50,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Color.fromRGBO(7, 94, 53, 1)),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 11,
              child: SizedBox(
                width: 400,
                height: 27,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.build,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                            width: 10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                      ),
                      TextSpan(
                        text: 'อุปกรณ์ชำรุด',
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                            width: 15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );

    print("${equipmentName.length}");

    selectedEquipmentIds =
        List.generate(equipmentIds.length, (index) => "1001");

    while (details!.length < equipmentIds.length) {
      details!.add(new InformRepairDetails());
    }

    print("FINAL : ${selectedEquipmentIds.length}");
    for (int i = 0; i < selectedEquipmentIds.length; i++) {
      print("ROUND : ${i + 1}");
      // if (details != null && details!.length > i) {
      //   if (details![i].roomEquipment != null &&
      //       details![i].roomEquipment!.equipment != null &&
      //       details![i].roomEquipment!.equipment!.equipment_id.toString() ==
      //           equipmentIds[i]) {
      //     eqCheckBox.add(true);
      //   } else {
      //     eqCheckBox.add(false);
      //   }
      // } else {
      //   eqCheckBox.add(false);
      // }
      if (arrDetailsTextCon.length < equipmentIds.length) {
        arrDetailsTextCon.add(new TextEditingController());
      }
      if (arrAmountsTextCon.length < equipmentIds.length) {
        arrAmountsTextCon.add(new TextEditingController());
      }

      if (details != null && details!.length > i) {
        if (details![i].roomEquipment != null &&
            details![i].roomEquipment!.equipment != null &&
            details![i].roomEquipment!.equipment!.equipment_id.toString() ==
                equipmentIds[i]) {
          eqCheckBox.add(true);
          arrDetailsTextCon[i].text = details![i].details.toString();
          arrAmountsTextCon[i].text = details![i].amount.toString();
        } else {
          eqCheckBox.add(false);
        }
      } else {
        eqCheckBox.add(false);
      }
      print(" png : ${details![i].pictures}");
      if (imageFileNames.length < equipmentIds.length) {
        imageFileNames.add("");
      }
      widgets.add(Column(
        children: [
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              equipmentName[i],
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                ),
              ),
            ),
            value: eqCheckBox[i],
            onChanged: (bool? value) {
              setState(() {
                eqCheckBox[i] = !(eqCheckBox[i]);
              });
            },
          ),
          eqCheckBox[i] == true
              ? Container(
                  child: Column(
                  children: [
                    TextFormField(
                      controller: arrDetailsTextCon[i],
                      decoration: const InputDecoration(
                        hintText: 'Enter details',
                      ),
                      onChanged: (value) {
                        //showArr();
                      },
                    ),
                    TextFormField(
                      controller: arrAmountsTextCon[i],
                      decoration: const InputDecoration(
                        hintText: 'Enter amount',
                      ),
                      onChanged: (value) {},
                    ),
                    equipmentImages[equipmentIds[i]] != null
                        ? Container(
                            child: Column(children: [
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: Image.file(File(
                                    equipmentImages[equipmentIds[i]]!.path)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _addImageForEquipmentNew(equipmentIds[i]);
                                  _uploadImages(i);
                                  //_uploadImages();
                                  //print('imageFileNames----${imageFileNames}');
                                },
                                child: Text('แก้ไขรูปภาพ'),
                              )
                            ]),
                          )
                        : details![i].pictures == null
                            ? ElevatedButton(
                                onPressed: () {
                                  _addImageForEquipmentNew(equipmentIds[i]);
                                  _uploadImages(i);
                                  //print('imageFileNames----${imageFileNames}');
                                },
                                child: Text('เพิ่มรูปภาพ'),
                              )
                            //Image.file(File(equipmentImages[equipmentIds[i]]![i].path))
                            : Container(
                                child: Column(children: [
                                  SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Image.network(
                                      baseURL +
                                          "/informrepairdetails/image/" +
                                          (details![i].pictures ?? ""),
                                      fit: BoxFit.cover,
                                      width: 220,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     _addImageForEquipmentNew(equipmentIds[i]);
                                  //     _uploadImages(i);
                                  //     //print('imageFileNames----${imageFileNames}');
                                  //   },
                                  //   child: Text('แก้ไขรูปภาพ'),
                                  // )
                                ]),
                              )
                  ],
                ))
              : Container()
        ],
      ));
    }

    print("FINAL DETAILS ROUND : ${arrDetailsTextCon.length}");
    print("AMOUNT DETAILS ROUND : ${arrDetailsTextCon.length}");
    print("WIDGETS ROUND : ${widgets.length}");

    return widgets;
  }
}
