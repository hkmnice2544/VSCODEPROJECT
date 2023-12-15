import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutterr/controller/equipment_controller.dart';
import 'package:flutterr/controller/informrepair_controller.dart';
import 'package:flutterr/model/Building_Model.dart';
import 'package:flutterr/model/Equipment_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/informrepair_model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/InfromStaff/ResultInformRepair.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../constant/constant_value.dart';
import '../../../controller/login_controller.dart';
import '../../../model/User_Model.dart';
import '../../Login.dart';

class NewEditInformRepair extends StatefulWidget {
  final int? user;
  final int? informrepair_id;
  const NewEditInformRepair(
      {super.key, required this.user, required this.informrepair_id});

  @override
  State<NewEditInformRepair> createState() => _NewEditInformRepairState();
}

String RoomType = "ห้องน้ำ";
String? buildingId;
List<Room>? rooms;
String? selectedRoom;
List<Building>? buildings;
InformRepair? informRepair;
List<Equipment>? equipments;
String? pictures;
Room? room;

bool? isLoaded = false;

class _NewEditInformRepairState extends State<NewEditInformRepair> {
  final InformRepairController informrepairController =
      InformRepairController();
  final EquipmentController equipmentController = EquipmentController();

  void fetchData() async {
    informRepair =
        await informrepairController.getInform(widget.informrepair_id ?? 0);
    List<Building?> buildingsList = [];
    buildingsList =
        (await informrepairController.listAllBuildings()).cast<Building>();
    buildings = buildingsList.cast<Building>();

    buildingId =
        informRepair?.equipment?.room?.building?.building_id.toString();

    RoomType = informRepair?.equipment?.room?.roomtype ?? "";

    rooms = await informrepairController.findlistRoomByIdBybuilding_id(
        int.parse(buildingId ?? ""), RoomType);

    equipments = await equipmentController
        .findEquipmentsByRoomId(informRepair?.equipment?.room?.room_id ?? 0);

    pictures = informRepair?.pictures;

    for (int i = 0; i < equipments!.length; i++) {
      if (equipments?[i].equipment_id.toString() ==
          informRepair?.equipment?.equipment_id.toString()) {
        _selectedIndex = i;
      }
    }

    for (int i = 0; i < equipments!.length; i++) {
      detailscontrollers.add(TextEditingController());
      amountcontrollers.add(TextEditingController());
      imageFileNames.add("");
    }
    detailscontrollers[0].text = informRepair?.details ?? "";
    amountcontrollers[0].text = informRepair!.amount.toString();
    rooms?.forEach(
      (element) {
        if (element.room_id.toString() ==
            informRepair?.equipment?.room?.room_id) {
          selectedRoom = element.room_id.toString();
        }
      },
    );

    //print(informRepair?.informrepair_id);
    setState(() {
      isLoaded = true;
    });
  }

  List<File> _selectedImages = [];
  ImagePicker imagePicker = ImagePicker();
  List<String> imageFileNames = [];
  int selectedImageCount = 0;

  Future<void> _uploadImages() async {
    if (_selectedImages.isNotEmpty) {
      final uri = Uri.parse(baseURL + '/informrepairs/upload');
      final request = http.MultipartRequest('POST', uri);

      for (final image in _selectedImages) {
        final file = await http.MultipartFile.fromPath(
          'file',
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

  void updateRoomAfterChangeBuilding() async {
    rooms = await informrepairController.findlistRoomByIdBybuilding_id(
        int.parse(buildingId ?? ""), RoomType);
    selectedRoom = null;
    setState(() {});
  }

  void updateBuildingAfterChangeRoomType() async {
    rooms = [];
    buildingId = "";
    selectedRoom = null;
  }

  void updateEquipmentsAfterChangeRoom() async {
    var roomId = int.tryParse(selectedRoom ?? "");
    equipments = await equipmentController.findEquipmentsByRoomId(roomId ?? 0);
    setState(() {});
  }

  String? selectedRoom;
  List<String> equipmentIds = [];
  List<String> equipmentName = [];
  bool? isDataLoaded = false;

  void findequipmentByIdByAll(String selectedRoom) async {
    setState(() {
      isDataLoaded = false;
    });
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

    //await Future.delayed(Duration(seconds: 1));

    setState(() {
      isDataLoaded = true;
    });
    print("equipmentIds ${equipmentIds.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    getLoginById();
    fetchData();
    super.initState();
  }

  User? users;

  LoginController loginController = LoginController();
  void getLoginById() async {
    users = await loginController.getLoginById(widget.user ?? 0);
    // print("getuser : ${user}");
    // print("getuserfirstname : ${users?.firstname}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'images/User.png',
                  width: 80,
                  height: 80,
                ),
              ),
              Text(
                'User',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                        leading: Icon(
                          Icons.face_2,
                          color: Colors.red,
                        ),
                        title: Text(
                          '${users?.firstname}',
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                      child: Text(
                    '${users?.lastname}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
                ],
              ),
              ListTile(
                  leading: Icon(
                    Icons.business,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.usertype}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
              ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.username}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
              ListTile(
                  leading: Icon(
                    Icons.password,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.password}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(''), // ลบ title ทิ้ง
        leading: Padding(
          padding: EdgeInsets.only(left: 30, top: 0, right: 0),
          child: IconButton(
            icon: Transform.scale(
              scale: 7.0,
              child: Image.asset(
                'images/MJU_LOGO.png',
                width: 50,
                height: 50,
              ),
            ),
            onPressed: () {
              // กระบวนการที่ต้องการเมื่อคลิกรูปภาพ
            },
          ),
        ),
        iconTheme: IconThemeData(
          size: 35,
        ),
        flexibleSpace: Image.asset('images/Top2.png', fit: BoxFit.cover),
        toolbarHeight: 135,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 0, top: 45, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // "มัลลิกา แซ่ลิ้ม",
                    '${users?.firstname} ${users?.lastname}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    // "ตำแหน่ง : หัวหน้างานแผนกห้องน้ำ",
                    '${users?.usertype}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0, right: 10),
            child: Image.asset(
              'images/Staff.png',
              width: 50,
              height: 50,
            ),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // เปิด Drawer ด้านซ้าย
              },
              icon: const Icon(Icons.menu),
              color: Color.fromARGB(255, 0, 0, 0),
            );
          }),
        ],
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
                                HomeStaff(user: widget.user), // หน้า A
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
            ]),
      ),
      body: isLoaded == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Container(
              child: Center(
                child: Column(children: [
                  Text(
                    "แก้ไขการแจ้งซ่อม",
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
                                  borderRadius: BorderRadius.circular(20),
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
                                      strokeAlign: BorderSide.strokeAlignCenter,
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
                                '${informRepair?.informrepair_id}',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                                '${informRepair?.informdate}',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                  Container(
                    width: 200,
                    child: Column(
                      children: [
                        RadioListTile(
                          title: Text("ห้องน้ำ"),
                          value: "ห้องน้ำ",
                          groupValue: RoomType,
                          onChanged: (value) {
                            setState(() {
                              RoomType = value as String;
                            });
                            updateBuildingAfterChangeRoomType();
                          },
                        ),
                        RadioListTile(
                          title: Text("ห้องเรียนรวม"),
                          value: "ห้องเรียนรวม",
                          groupValue: RoomType,
                          onChanged: (value) {
                            setState(() {
                              RoomType = value as String;
                            });
                            updateBuildingAfterChangeRoomType();
                          },
                        ),
                      ],
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
                          ...buildings!.map((Building building) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                building.buildingname ?? '',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              value: building.building_id.toString(),
                            );
                          }).toList(),
                        ],
                        onChanged: (val) {
                          setState(() {
                            buildingId = val;
                            updateRoomAfterChangeBuilding();
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
                              color: Color.fromRGBO(7, 94, 53, 1)),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
                          iconSize: 30,
                          iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
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
                  rooms?.isEmpty == true
                      ? Container()
                      : Padding(
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
                                ],
                              ),
                              value: selectedRoom ??
                                  rooms!.first.room_id.toString(),
                              items: [
                                ...rooms!.map((Room room) {
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
                                              room.room_id.toString() +
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
                                  print("Selected Room: $val");
                                  selectedRoom = val;
                                  updateEquipmentsAfterChangeRoom();
                                  // findequipmentByIdByAll(selectedRoom!);
                                  equipmentName.clear();
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 450,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(66, 255, 255, 255),
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
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      padding: EdgeInsets.all(10), // ระยะห่างขอบของกรอบ
                      decoration: BoxDecoration(
                        color: Color.fromARGB(32, 41, 111, 29),
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255), // สีขอบ
                          width: 2, // ความหนาขอบ
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // กำหนดรัศมีขอบมน
                      ),
                      child: Column(
                        children: [
                          //Text("Hello World!")
                          ...buildEquipmentWidgets()
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120, // Set the width of the button here
                          child: FloatingActionButton.extended(
                            backgroundColor: Color(0xFFEB6727),
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
                              } else {
                                if (formKey.currentState!.validate()) {
                                  var amount =
                                      int.tryParse(amountcontrollers[0].text);
                                  var equipmentId =
                                      equipments?[_selectedIndex].equipment_id;
                                  await informrepairController
                                      .updateInformRepair(
                                          RoomType,
                                          "ยังไม่ได้ดำเนินการ",
                                          amount ?? 0,
                                          detailscontrollers[0].text,
                                          informRepair!.pictures ?? "",
                                          widget.user ?? 0,
                                          equipmentId ?? 0,
                                          informRepair!.informrepair_id ?? 0,
                                          image);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ResultInformRepair(
                                            informrepair_id:
                                                informRepair!.informrepair_id,
                                            user: widget.user)),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 120, // Set the width of the button here
                        child: FloatingActionButton.extended(
                          backgroundColor: Color(0xFFEB6727),
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ResultInformRepair(
                                  informrepair_id: widget.informrepair_id,
                                  user: widget.user);
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ]),
              ),
            )),
    );
  }

  int? selectedValue;
  Map<String, bool> checkboxStates = {};
  Map<String, String> detailsMap = {};
  Map<String, int> amountMap = {};
  List<String> checkedEquipmentIds = [];
  List<String> checkedDetails = [];
  List<String> listdetails = [];
  List<String> amountLists = [];
  Map<String, List<XFile>> equipmentImages = {};

  List<bool> isChecked = [];
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _selectedIndex = -1; // Variable to store the selected index

  File? image;

  void _addImageForEquipment() async {
    final XFile? selectedImages =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      image = File(selectedImages.path);
      setState(() {});
    }
  }

  List<Widget> buildEquipmentWidgets() {
    List<Widget> widgets = [];

    widgets.add(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 450,
          height: 50,
          child: Stack(
            children: [
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
                        width: 1,
                        color: Color.fromRGBO(7, 94, 53, 1),
                      ),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
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
                          child: SizedBox(width: 10),
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
                          child: SizedBox(width: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    for (int index = 0; index < equipments!.length; index++) {
      widgets.add(ListTile(
        title: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: _selectedIndex,
              onChanged: (int? value) {
                setState(() {
                  _selectedIndex = value ?? -1;
                  if (_selectedIndex == index) {
                    detailscontrollers[0].text = '';
                    amountcontrollers[0].text = '';
                  }
                });
              },
            ),
            Icon(
              Icons.bookmark_add_outlined,
              color: Color.fromRGBO(7, 94, 53, 1),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                equipments?[index].equipmentname ?? "",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));

      widgets.add(
        Visibility(
          visible: _selectedIndex == index,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                          controller: amountcontrollers[0],
                          decoration: const InputDecoration(
                            labelText: 'จำนวน',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {
                              amountcontrollers[0].text = value;
                            });
                            print(amountcontrollers[0].text);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกจำนวน';
                            } else if (value.length < 1) {
                              return 'จำนวนต้องมีอย่างน้อย 1 ตัวอักษร';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                      ),
                      Container(
                          child: Text(
                        "  รายการ",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: detailscontrollers[0],
                          decoration: const InputDecoration(
                            labelText: 'ระบุสาเหตุการชำรุด',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณาระบุรายละเอียดการแจ้งซ่อม';
                            } else if (value.length < 4 || value.length > 255) {
                              return 'รายละเอียดการแจ้งซ่อมต้องมีความยาวตั้งแต่ 4 ถึง 255 ตัวอักษร';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              detailscontrollers[0].text = value;
                            });
                            print(detailscontrollers[0].text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      pictures != ""
                          ? Container(
                              width: 200, // Adjust the width as needed
                              height: 200, // Adjust the height as needed
                              child: Image.network(
                                  baseURL + '/informrepairs/$pictures'),
                            )
                          : pictures == "" && image != null
                              ? Container(
                                  width: 200, // Adjust the width as needed
                                  height: 200, // Adjust the height as needed
                                  child: Image.file(image!),
                                )
                              : Container(),
                      pictures != "" || image != null
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (pictures != "") {
                                      pictures = "";
                                    } else if (image != null) {
                                      image = null;
                                    }
                                    setState(() {});
                                  },
                                  child: Text('X')))
                          : Container(),
                    ],
                  ),
                ),
                pictures == "" && image == null
                    ? ElevatedButton(
                        onPressed: () {
                          _addImageForEquipment();
                        },
                        child: Text('เพิ่มรูป'))
                    : Container(),
                Divider(),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
