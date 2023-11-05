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

class MyEdit extends StatefulWidget {
  final int? user;
  final int? informrepair_id;
  const MyEdit({required this.user, required this.informrepair_id});

  @override
  State<MyEdit> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyEdit> {
  bool isDataLoaded = false;
  String? selectedRoom = '';
  String? buildingId = '';
  List<Building?> buildings = [];
  List<Room?> rooms = [];
  String RoomType = "ห้องน้ำ";
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

  List<File> _selectedImages = [];
  void _addImageForEquipment(String equipmentId) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      if (equipmentImages.containsKey(equipmentId)) {
        equipmentImages[equipmentId]!.addAll(selectedImages);
      } else {
        equipmentImages[equipmentId] = selectedImages;
      }
      setState(() {});
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isNotEmpty) {
      final uri = Uri.parse(baseURL + '/review_pictures/uploadMultiple');
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

  List<String> equipmentIds = [];
  String? selectedRoomId;
  String? roomIds;
  List<String>? Room_id = [];
  List<String> equipmentName = [];

  void findequipmentByIdByAll(String selectedRoom) async {
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

    setState(() {
      isDataLoaded = true;
    });
  }

  void listAllBuildings() async {
    List<Building?> buildingsList = [];
    buildingsList =
        (await informrepairController.listAllBuildings()).cast<Building>();
    print("listAllBuildings : ${buildingsList[0]!.building_id}");
    setState(() {
      buildings = buildingsList;
    });
  }

  void findlistRoomByIdBybuilding_id(int building_id, String roomtype) async {
    List<Room> listrooms;
    listrooms = await informrepairController.findlistRoomByIdBybuilding_id(
        building_id, roomtype);
    print("rooms : ${listrooms.length}");
    setState(() {
      rooms = listrooms;
    });
  }

  List<InformRepairDetails>? details = [];
  void findequipment_idByIdByinformrepair_id(String informrepair_id) async {
    details =
        await informRepairDetailsController.findByIdByDetails(informrepair_id);
    setState(() {});
  }

  List<InformRepairDetails>? informRepairDetail = [];
  void ViewListInformDetails() async {
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

  void fetchInformRepairs() async {
    setState(() {
      isDataLoaded = true;
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
    isChecked = List.generate(equipmentIds.length, (index) => false);
    detailscontrollers =
        List.generate(equipmentIds.length, (index) => TextEditingController());
    amountcontrollers =
        List.generate(equipmentIds.length, (index) => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    listAllBuildings();
    ViewListInformDetails();
    fetchInformRepairs();
    findequipment_idByIdByinformrepair_id(widget.informrepair_id.toString());
    initialize();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
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
              Padding(
                padding: EdgeInsets.only(left: 20, top: 0, right: 0),
                child: IconButton(
                  icon: Icon(Icons.home),
                  color: Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Home(user: widget.user);
                      },
                    ));
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Home(user: widget.user);
                      },
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, top: 0, right: 50),
                    child: Text(
                      "หน้าแรก",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Text(" ")), // เพิ่มระยะห่างของข้อความได้ตามต้องการ
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 120, top: 0, right: 0),
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    },
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // นำทางไปยังหน้าอื่นที่คุณต้องการ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Login();
                      }),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 0, right: 0),
                    child: Text(
                      "ออกจากระบบ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
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
                                  color: Color.fromARGB(255, 255, 75, 75),
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
                                        color: Colors.white,
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
                                color: const Color.fromARGB(
                                    255, 255, 255, 255), // สีไอคอน
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
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                                color: const Color.fromARGB(
                                    255, 255, 255, 255), // สีไอคอน
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
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                              color: Colors.redAccent,
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
                              color: Colors.redAccent,
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
                              color: Colors.redAccent,
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
                              color: Colors.redAccent,
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

                    Row(children: [
                      Expanded(child: Icon(Icons.topic_outlined)),
                      Expanded(
                        child: Text(
                          "อุปกรณ์ชำรุด",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("                                "),
                    ]),

                    ...buildEquipmentWidgets(),
                  ]),
                ),
              ),
            ),
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
  Map<String, List<XFile>> equipmentImages = {};
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  List<String> selectedEquipmentIds = [];

  List<Widget> buildEquipmentWidgets() {
    List<Widget> widgets = [];
    selectedEquipmentIds =
        List.generate(equipmentIds.length, (index) => "1001");
    print("object---------------- $selectedEquipmentIds");
    for (int index = 0; index < equipmentIds.length; index++) {
      final equipmentId = equipmentIds[index];
      final bool isEquipmentChecked =
          selectedEquipmentIds[index].contains(equipmentId);

      // ตรวจสอบและอัปเดตค่า CheckboxListTile ตามต้องการ
      print("isEquipmentChecked : ${isEquipmentChecked}");
      widgets.add(
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(equipmentName[index]),
          value: isEquipmentChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null) {
                if (value) {
                  selectedEquipmentIds.add(equipmentId);
                } else {
                  selectedEquipmentIds.remove(equipmentId);
                }
              }
              isChecked[index] = value ?? false;
            });
          },
        ),
      );

      if (isEquipmentChecked) {
        // Checkbox ถูกเลือก
        widgets.add(
          Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter details',
                ),
                initialValue: details![index].details?[index],
                onChanged: (value) {
                  setState(() {
                    detailsMap[equipmentId] = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                ),
                initialValue: details![index].amount.toString()[index],
                onChanged: (value) {
                  setState(() {
                    amountMap[equipmentId] = int.tryParse(value) ?? 0;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _addImageForEquipment(equipmentId);
                  _uploadImages();
                  print('imageFileNames----${imageFileNames}');
                },
                child: Text('เพิ่มรูปภาพ'),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: equipmentImages[equipmentId]?.length ?? 0,
                itemBuilder: (BuildContext context, int imageIndex) {
                  String fileName = equipmentImages[equipmentId]![imageIndex]
                      .path
                      .split('/')
                      .last;
                  imageFileNames.add(fileName);

                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        Image.file(File(
                            equipmentImages[equipmentId]![imageIndex]
                                .path)), // Display the image
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 79,
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              fileName, // Display the image name
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
                              setState(() {
                                final equipmentImagesList =
                                    equipmentImages[equipmentId];
                                if (equipmentImagesList != null &&
                                    imageIndex < equipmentImagesList.length) {
                                  equipmentImagesList.removeAt(imageIndex);
                                }

                                if (imageIndex < imageFileNames.length) {
                                  String fileNameToRemove =
                                      imageFileNames[imageIndex];
                                  imageFileNames.remove(fileNameToRemove);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    }
    return widgets;
  }
}
