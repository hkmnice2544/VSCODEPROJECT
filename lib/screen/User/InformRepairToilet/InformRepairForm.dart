import 'dart:convert';
import 'dart:io';
import 'package:flutterr/constant/constant_value.dart';

import 'package:flutterr/controller/login_controller.dart';

import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import '../../../controller/informrepair_controller.dart';
import 'package:intl/intl.dart';
import '../../../model/Building_Model.dart';
import '../../../model/informrepair_model.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InformRepairForm extends StatefulWidget {
  final int? user;
  InformRepairForm({required this.user});

  @override
  Form createState() => Form();
}

class Form extends State<InformRepairForm> {
  Map<String, TextEditingController> checkboxControllers = {};
  Map<String, TextEditingController> countControllers = {};
  Map<String, String> checkboxValues = {};

  String formattedDate = '';
  DateTime informdate = DateTime.now();

  final InformRepairController informRepairController =
      InformRepairController();
  TextEditingController defectiveequipmentTextController =
      TextEditingController();
  TextEditingController informtypeTextController = TextEditingController();
  final InformRepairController informController = InformRepairController();

//dropdown----------------------------------

//CheckBox----------------------------------
  // bool? _tapCheckBox = false; //ก๊อกน้ำ
  // bool? _toiletbowlCheckBox = false; //โถชักโครก
  // bool? _bidetCheckBox = false; //สายชำระ
  // bool? _urinalCheckBox = false; //โถฉี่ชาย
  // bool? _sinkCheckBox = false; //อ่างล้างมือ
  // bool? _lightbulbCheckBox = false; //หลอดไฟ
  // bool? _otherCheckBox = false; //อื่นๆ

  TextEditingController detailController1 = TextEditingController();
  TextEditingController detailController2 = TextEditingController();
  TextEditingController detailController3 = TextEditingController();
  TextEditingController idController1 = TextEditingController();
  TextEditingController idController2 = TextEditingController();
  TextEditingController idController3 = TextEditingController();
  TextEditingController imageController1 = TextEditingController();

  int equip_id = 1002;

  Color backgroundColor = Colors.white;

  List<InformRepair>? informrepairs;

  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  InformRepair? informRepair;
  List<Building>? buildings;
  String? roomname;
  String? roomfloor;
  String? roomposition;
  Building? building;
  Room? room;
  List<String> roomNames = [];
  List<String> roomfloors = [];
  List<String> roompositions = [];
  late final String username;
  String informtype = "ห้องน้ำ";
  String statusinform = "ยังไม่ได้ดำเนินการ";
  String statusinformdetails = "เสีย";
  String? informrepair_idvar;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];
  String? buildingId = '';
  int selectedImageCount = 0;
  String? selectedRoom;
  LoginController loginController = LoginController();
  User? users;

  List<File> _selectedImages = [];
  void _addImageForEquipment(String equipmentId) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      if (equipmentImages.containsKey(equipmentId)) {
        selectedImageCount += selectedImages.length;
        equipmentImages[equipmentId]!.addAll(selectedImages);
        _selectedImages.addAll(selectedImages.map((image) => File(image.path)));
      } else {
        equipmentImages[equipmentId] = selectedImages;
        _selectedImages.addAll(selectedImages.map((image) => File(image.path)));
      }

      await _uploadImages(); // เรียก _uploadImages ทันทีหลังจากเลือกรูปภาพ
      setState(() {});
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isNotEmpty) {
      final uri = Uri.parse(baseURL + '/informrepairdetails/uploadMultiple');
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

  Future<void> fetchRoomNames() async {
    var url = Uri.parse(baseURL + '/rooms/listAllDistinctRoomNames');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        roomNames = List<String>.from(data);
      });
    } else {
      throw Exception('Failed to load room names');
    }
  }

  Future<void> fetchRoomfloors() async {
    var url = Uri.parse(baseURL + '/rooms/listAllDistinctRoomfloor');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        roomfloors = List<String>.from(data);
      });
    } else {
      throw Exception('Failed to load room names');
    }
  }

  Future<void> fetchRoompositions() async {
    var url = Uri.parse(baseURL + '/rooms/listAllDistinctRoomposition');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        roompositions = List<String>.from(data);
      });
    } else {
      throw Exception('Failed to load room names');
    }
  }

  Future<void> fetchRoomByBuilding(String building_id) async {
    var url = Uri.parse(baseURL + '/rooms/listAllByBuilding/${building_id}');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        roompositions = List<String>.from(data);
      });
    } else {
      throw Exception('Failed to load room names');
    }
  }

  final InformRepairController informrepairController =
      InformRepairController();

  void fetchInformRepairs() async {
    informrepairs = await informrepairController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    print(
        "getInform ปัจจุบัน : ${informrepairs?[informrepairs!.length - 1].informrepair_id}");
    print(
        "getInform +1 : ${(informrepairs?[informrepairs!.length - 1].informrepair_id ?? 0) + 1}");

    setState(() {
      isDataLoaded = true;
    });
  }

  // void listAllInformRepairDetails() async {
  //   informdetails =
  //       await informRepairDetailsController.listAllInformRepairDetails();
  //   // print({informdetails?[0].informdetails_id});
  //   if (informrepairs != null && informrepairs!.isNotEmpty) {
  //     print("Informrepair ID: ${informrepairs![0].informrepair_id}");
  //     print(
  //         "getInform ปัจจุบัน : ${informrepairs![informrepairs!.length - 1].informrepair_id}");
  //     print(
  //         "getInform +1 : ${informrepairs![informrepairs!.length - 1].informrepair_id! + 1}");
  //   } else {
  //     print("Informrepairs เป็น null หรือว่าง");
  //   }

  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  void listAllBuildings() async {
    buildings =
        (await informrepairController.listAllBuildings()).cast<Building>();
    print("listAllBuildings : ${buildings?[0].building_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? Floor = [];
  void findfloorByIdbuilding_id(String building_id) async {
    Floor = await informrepairController.findfloorByIdbuilding_id(building_id);
    if (Floor != null && Floor!.isNotEmpty) {
      for (var i = 0; i < Floor!.length; i++) {
        print("Floor $i: ${Floor![i]}");
      }
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? Position = [];
  void findpositionByIdbuilding_id(String building_id, String floor) async {
    Position = await informrepairController.findpositionByIdbuilding_id(
        building_id, floor);
    if (Position != null && Position!.isNotEmpty) {
      for (var i = 0; i < Position!.length; i++) {
        print("Floor $i: ${Position![i]}");
      }
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? Roomname = [];
  void findroomnameByIdbuilding_id(
      String building_id, String floor, String position) async {
    Roomname = await informrepairController.findroomnameByIdbuilding_id(
        building_id, floor, position);
    if (Roomname != null && Roomname!.isNotEmpty) {
      for (var i = 0; i < Roomname!.length; i++) {
        print("Floor $i: ${Roomname![i]}");
      }
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String> equipmentIds = [];
  String? selectedRoomId;
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

  List<String>? room_id = [];

  void findrooom_idByIdByAll(String building_id, String floor, String position,
      String roomname) async {
    room_id = await informrepairController.findroom_idByIdByAll(
        building_id, floor, position, roomname);
    print(" findrooom_idByIdByAll : ${room_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  Future<void> initialize() async {
    isChecked = List.filled(10, false);
    detailscontrollers = List.generate(10, (index) => TextEditingController());
    amountcontrollers = List.generate(10, (index) => TextEditingController());
  }

  List<Room>? rooms;
  String RoomType = "ห้องน้ำ";
  List<String> RoomTypeLists = ["ห้องน้ำ", "ห้องเรียนรวม"];
  void findlistRoomByIdBybuilding_id(int building_id, String roomtype) async {
    rooms = await informrepairController.findlistRoomByIdBybuilding_id(
        building_id, roomtype);
    print("ViewListInformDetails : ${rooms?[0].room_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void getLoginById(int user) async {
    users = await loginController.getLoginById(user);
    print("getuser : ${user}");
    print("getuserfirstname : ${users?.firstname}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getLoginById(widget.user!);
    fetchInformRepairs();
    listAllBuildings();
    fetchRoomNames();
    fetchRoomfloors();
    fetchRoompositions();
    // listAllInformRepairDetails();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // fetchListBuilding();
    initialize();
    main();
    print("user----------Inform-------------${widget.user}");

    // findlistRoomByIdBybuilding_id(1001, RoomType);

    // print('user_id----${user_id}');
    // print('imageFileNames----${imageFileNames}');
  }

  @override
  Widget build(BuildContext context) {
    // หลังจากโหลดข้อมูล username เสร็จแล้วให้แสดงหน้า Home ตามปกติ
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
            padding: EdgeInsets.only(left: 0, top: 55, right: 15),
            child: Text(
              // "หัสยา ขาวใหม่",
              '${users?.firstname} ${users?.lastname}',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0, right: 10),
            child: Image.asset(
              'images/User.png',
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
            ]),
      ),
      body: isDataLoaded == false
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 0, top: 0, right: 0),
                child: Center(
                  child: Column(children: [
                    Text(
                      "แจ้งซ่อมห้องน้ำ",
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
                                  '${(informrepairs?.isNotEmpty == true ? (informrepairs![informrepairs!.length - 1].informrepair_id ?? 0) + 1 : 1)}',
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
                                  '$formattedDate',
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
                            title: Text(RoomTypeLists[0]),
                            value: RoomTypeLists[0],
                            groupValue: RoomType,
                            onChanged: (value) {
                              setState(() {
                                RoomType = value as String;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(RoomTypeLists[1]),
                            value: RoomTypeLists[1],
                            groupValue: RoomType,
                            onChanged: (value) {
                              setState(() {
                                RoomType = value as String;
                              });
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
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .business, // ใส่ไอคอนที่คุณต้องการที่นี่
                                      color: Color.fromARGB(
                                          255, 255, 253, 253), // สีของไอคอน
                                      size: 24, // ขนาดของไอคอน
                                    ),
                                    SizedBox(
                                        width:
                                            10), // ระยะห่างระหว่างไอคอนและข้อความ
                                    Text(
                                      building.buildingname ?? '',
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
                                value: building.building_id.toString(),
                              );
                            }).toList(),
                          ],
                          onChanged: (val) {
                            setState(() {
                              buildingId = val;
                              if (val != '') {
                                int? intBuildingId = int.tryParse(buildingId!);
                                if (intBuildingId != null) {
                                  findlistRoomByIdBybuilding_id(
                                      intBuildingId, RoomType);
                                } else {
                                  print("Invalid buildingId format");
                                }
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
                                  color:
                                      const Color.fromARGB(66, 255, 255, 255),
                                ),
                                color: Color.fromRGBO(7, 94, 53, 1)),
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

                    if (rooms != null && rooms!.isNotEmpty) ...{
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
                              ],
                            ),
                            value:
                                selectedRoom ?? rooms!.first.room_id.toString(),
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
                                findequipmentByIdByAll(selectedRoom!);
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
                    },

                    //  //---------------------------------------------------------------------------------------------
                    //  //---------------------------------------------------------------------------------------------

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
                            ...buildEquipmentWidgets(),
                          ],
                        ),
                      ),
                    ),
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
                  var result = true;

                  for (int i = 0; i < equipmentIds.length; i++) {
                    if (isChecked[i] == true) {
                      result = false;
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
                  } else if (result == true || isChecked.isEmpty) {
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
                  } else {
                    int? selectedrooom = int.tryParse(selectedRoom!);
                    if (selectedRoom != null && selectedRoom!.isNotEmpty) {
                      if (selectedrooom != null) {
                        // var response =
                        //     await informRepairController.addInformRepair(
                        //   informtype,
                        //   statusinform,
                        //   widget.user!,
                        //   selectedrooom!,
                        // );

                        // ทำการบันทึกข้อมูลใน dataList

                        // for (int i = 0; i < equipmentIds.length; i++) {
                        //   if (isChecked[i]) {
                        //     int? parsedEquipmentId =
                        //         int.tryParse(amountcontrollers[i].text);
                        //     int? parsedEquipmentId2 =
                        //         int.tryParse(equipmentIds[i]);
                        //     for (int j = 0; j < imageFileNames.length; j++) {
                        //       if (isChecked[j]) {
                        //         if (int.tryParse(equipmentIds[j]) ==
                        //             parsedEquipmentId2) {
                        //           print("imageFileNames${imageFileNames[i]}");
                        //           var jsonResponse =
                        //               await informRepairDetailsController
                        //                   .saveInformRepairDetails(
                        //                       parsedEquipmentId ?? 1,
                        //                       detailscontrollers[i].text,
                        //                       imageFileNames[j],
                        //                       ((informrepairs?[informrepairs!
                        //                                           .length -
                        //                                       1]
                        //                                   .informrepair_id ??
                        //                               0) +
                        //                           1),
                        //                       parsedEquipmentId2 ?? 0,
                        //                       selectedrooom!);
                        //         }
                        //       }
                        //     }
                        //   }
                        // }

                        // List<Inform_Pictures> savedInformPictures =
                        //     await InformRepair_PicturesController
                        //         .saveInform_Pictures(data);

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (_) => ResultInformRepair(
                        //           informrepair_id: ((informrepairs?[
                        //                           informrepairs!.length - 1]
                        //                       .informrepair_id ??
                        //                   0) +
                        //               1),
                        //           user: widget.user)),
                        // );
                      } else {
                        // Handle the case where room_id is empty or null.
                      }
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Home(user: widget.user);
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
  Map<String, List<XFile>> equipmentImages = {};

  List<bool> isChecked = [];
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _selectedIndex = -1; // Variable to store the selected index

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

    for (int index = 0; index < equipmentIds.length; index++) {
      final equipmentId = equipmentIds[index];

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
                equipmentName[index],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: detailscontrollers[0],
                        decoration: const InputDecoration(
                          hintText: 'ระบุสาเหตุการชำรุด',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: TextFormField(
                        controller: amountcontrollers[0],
                        decoration: const InputDecoration(
                          hintText: 'กรุณากรอกจำนวน',
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
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // เรียกฟังก์ชันเพิ่มรูป
                  // _addImageForEquipment(equipmentIds[index]);
                  _addImageForEquipment(equipmentId);
                  _uploadImages();
                  print('imageFileNames----${imageFileNames}');
                  print("--_selectedImages-------------${_selectedImages}");
                },
                child: Text(
                  'อัพโหลดรูปภาพ',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: equipmentImages[equipmentId]?.length ?? 0,
                itemBuilder: (BuildContext context, int imageIndex) {
                  final image = equipmentImages[equipmentId]![imageIndex];
                  final imagePath = image.path; // Get the image file path
                  final filename =
                      imagePath.split('/').last; // Get the image file name
                  // String fileName = equipmentImages[equipmentId]![imageIndex]
                  //     .path
                  //     .split('/')
                  //     .last;
                  // imageFileNames.add(fileName); // เพิ่มชื่อไฟล์ลงใน List
                  if (!imageFileNames.contains(filename)) {
                    imageFileNames.add(filename);
                  }
                  // Add the image name to the list

                  return Center(
                    child: Padding(
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
                                filename, // Display the image name
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
                                // Remove the image from the equipmentImages map
                                setState(() {
                                  equipmentImages[equipmentId]!
                                      .removeAt(imageIndex);
                                });

                                // Remove the image name from the imageFileNames list
                                String fileNameToRemove =
                                    imageFileNames[imageIndex];
                                imageFileNames.removeWhere(
                                    (filename) => filename == fileNameToRemove);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
