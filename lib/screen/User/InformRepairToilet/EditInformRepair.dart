import 'dart:io';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:flutterr/model/inform_pictures_model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/ResultInformRepair.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import '../../../controller/informrepair_controller.dart';
import 'package:intl/intl.dart';
import '../../../model/Building_Model.dart';
import '../../../model/informrepair_model.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class EditInformRepairs extends StatefulWidget {
  final int? user;
  final int? informrepair_id;
  EditInformRepairs({required this.user, required this.informrepair_id});

  @override
  Form createState() => Form();
}

class Form extends State<EditInformRepairs> {
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
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
  InformRepair_PicturesController informRepair_PicturesController =
      InformRepair_PicturesController();

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
  int user_id = 1001;

  Color backgroundColor = Colors.white;
  // รายละเอียด
  TextEditingController _tapCheckBoxController = TextEditingController();
  TextEditingController _toiletbowlBoxController = TextEditingController();
  TextEditingController _bidetCheckBoxController = TextEditingController();
  TextEditingController _urinalCheckBoxController = TextEditingController();
  TextEditingController _sinkCheckBoxController = TextEditingController();
  TextEditingController _lightbulbCheckBoxController = TextEditingController();
  TextEditingController _doorCheckBoxController = TextEditingController();
  TextEditingController _otherCheckBoxController = TextEditingController();

  // จำนวน
  TextEditingController _tapCountController = TextEditingController();
  TextEditingController _toiletbowlCountController = TextEditingController();
  TextEditingController _bidetCheckCountController = TextEditingController();
  TextEditingController _urinalCheckCountController = TextEditingController();
  TextEditingController _sinkCheckCountController = TextEditingController();
  TextEditingController _lightbulbCheckCountController =
      TextEditingController();
  TextEditingController _doorCheckCountController = TextEditingController();
  TextEditingController _otherCheckCountController = TextEditingController();

  bool? _tapCheckBox = false;
  bool? _toiletbowlCheckBox = false;
  bool? _bidetCheckBox = false;
  bool? _urinalCheckBox = false;
  bool? _sinkCheckBox = false;
  bool? _lightbulbCheckBox = false;
  bool? _doorCheckBox = false;
  bool? _otherCheckBox = false;

  List<InformRepair>? informrepairs;
  List<InformRepairDetails>? informRepairDetails;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  InformRepair? informRepair;
  List<Building>? buildings;
  String? roomname;
  String? roomfloor;
  String? roomposition;
  Building? building;
  List<Room>? rooms;
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
  String RoomType = "ห้องน้ำ";
  String? selectedRoom;
  LoginController loginController = LoginController();
  User? users;

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

  final InformRepairController informrepairController =
      InformRepairController();

  void listAllInformRepairDetails() async {
    informRepairDetails =
        await informRepairDetailsController.listAllInformRepairDetails();
    // print({informdetails?[0].informdetails_id});
    if (informrepairs != null && informrepairs!.isNotEmpty) {
      print("Informrepair ID: ${informrepairs![0].informrepair_id}");
      print(
          "getInform ปัจจุบัน : ${informrepairs![informrepairs!.length - 1].informrepair_id}");
      print(
          "getInform +1 : ${informrepairs![informrepairs!.length - 1].informrepair_id! + 1}");
    } else {
      print("Informrepairs เป็น null หรือว่าง");
    }

    setState(() {
      // isDataLoaded = true;
    });
  }

  void listAllBuildings() async {
    List<Building?> buildingsList = [];
    buildingsList =
        (await informrepairController.listAllBuildings()).cast<Building>();
    print("listAllBuildings : ${buildingsList[0]!.building_id}");
    setState(() {
      buildings = buildingsList.cast<Building>();
    });
  }

  List<String> equipmentIds = [];
  String? selectedRoomId;
  List<String>? Room_id = [];
  List<String> equipmentName = [];

  void findequipmentByIdByAll(String building_id, String floor, String position,
      String roomname) async {
    Room_id = await informrepairController.findroom_idByIdByAll(
        building_id, floor, position, roomname);
    if (Room_id != null && Room_id!.isNotEmpty) {
      selectedRoomId = Room_id![0]; // ยกตัวอย่างว่าเลือก index 0

      // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูล equipment_ids
      equipmentIds = await informrepairController
          .findequipment_idByIdByroom_id(selectedRoomId);

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
    setState(() {
      // isDataLoaded = true;
    });
  }

  List<String>? room_id = [];

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  Future<void> initialize() async {
    isChecked = List.filled(10, false);
    detailscontrollers = List.generate(10, (index) => TextEditingController());
    amountcontrollers = List.generate(10, (index) => TextEditingController());
  }

  void findlistRoomByIdBybuilding_id(int building_id, String roomtype) async {
    List<Room> listrooms;
    listrooms = await informrepairController.findlistRoomByIdBybuilding_id(
        building_id, roomtype);
    print("findlistRoomByIdBybuilding_id : ${listrooms.length}");
    setState(() {
      rooms = listrooms;
    });
  }

  List<InformRepairDetails>? informRepairDetail = [];
  void ViewListInformDetails() async {
    informRepairDetail =
        await informRepairDetailsController.ViewListInformDetails(
            widget.informrepair_id!);
    findlistRoomByIdBybuilding_id(
        informRepairDetail![0].informRepair!.room!.building!.building_id as int,
        RoomType.toString());
    setState(() {
      selectedRoom =
          informRepairDetail?[0].roomEquipment!.room!.room_id.toString();
      buildingId = informRepairDetail?[0]
          .roomEquipment!
          .room!
          .building!
          .building_id
          .toString();
    });
  }

  void fetchInformRepairs() async {
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? quipment_idcheked = [];

  void findequipment_idByIdByinformrepair_id(String informrepair_id) async {
    quipment_idcheked = await informRepairDetailsController
        .findequipment_idByIdByinformrepair_id(informrepair_id);
    print(" quipment_idcheked : ${quipment_idcheked}");
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

    // listAllInformRepairDetails();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // fetchListBuilding();
    initialize();
    main();
    print("user-----------Edit------------${widget.user}");
    print(
        "user-----------informrepair_id------------${widget.informrepair_id}");
    ViewListInformDetails();

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
              'images/profile-user.png',
              width: 30,
              height: 30,
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
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
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
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 390,
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 390,
                                height: 200,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFFF0573D)),
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
                              left: 50,
                              top: 11,
                              child: SizedBox(
                                width: 450,
                                height: 27,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.list,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'เลขที่แจ้งซ่อม :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: '${widget.informrepair_id}',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50,
                              top: 50,
                              child: SizedBox(
                                width: 450,
                                height: 27,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.date_range,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'วันที่แจ้งซ่อม  :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: '$formattedDate',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50,
                              top: 90,
                              child: SizedBox(
                                width: 450,
                                height: 90,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.business,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'อาคาร  :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      WidgetSpan(
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              // color: Colors.red, // สีพื้นหลัง
                                              // borderRadius: BorderRadius.circular(
                                              //     30), // เพิ่มขอบมน
                                              ),
                                          child: DropdownButton<String>(
                                            value: buildingId,
                                            items: [
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  'กรุณากรอกอาคาร',
                                                  style: GoogleFonts.prompt(
                                                    textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 6, 6, 6),
                                                      fontSize: 20,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                  ),
                                                ),

                                                value: '', // หรือค่าว่าง
                                              ),
                                              ...buildings!
                                                  .map((Building building) {
                                                return DropdownMenuItem<String>(
                                                  child: Text(
                                                      building.buildingname ??
                                                          ''),
                                                  value: building.building_id
                                                      .toString(),
                                                );
                                              }).toList(),
                                            ],
                                            onChanged: (val) {
                                              setState(() {
                                                buildingId = val;
                                                if (val != '') {
                                                  int? intBuildingId =
                                                      int.tryParse(buildingId!);
                                                  if (intBuildingId != null) {
                                                    findlistRoomByIdBybuilding_id(
                                                        intBuildingId,
                                                        RoomType);
                                                  } else {
                                                    print(
                                                        "Invalid buildingId format");
                                                  }
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.arrow_drop_down_circle,
                                              color: Colors.red,
                                            ),
                                            dropdownColor: Colors.white,
                                            underline: null,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50,
                              top: 140,
                              child: SizedBox(
                                width: 500,
                                height: 200,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(Icons.linear_scale_outlined,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      TextSpan(
                                        text: 'ห้อง  :',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                      ),
                                      if (rooms != null &&
                                          rooms!.isNotEmpty) ...{
                                        WidgetSpan(
                                          child: Container(
                                            height: 40,
                                            width: 190,
                                            decoration: BoxDecoration(
                                                // เพิ่มขอบมน
                                                ),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: selectedRoom ??
                                                  rooms!.first.room_id
                                                      .toString(), // ใช้ตัวแปร selectedRoom เพื่อกำหนดค่าเริ่มต้น
                                              items: [
                                                ...rooms!.map((Room room) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    child: Text("ห้อง " +
                                                        room.room_id
                                                            .toString() +
                                                        " ชั้น " +
                                                        room.floor.toString() +
                                                        " ตำแหน่ง " +
                                                        room.position
                                                            .toString() +
                                                        " " +
                                                        room.roomname
                                                            .toString()), // หรือเลือกฟิลด์ที่คุณต้องการแสดง
                                                    value: room.room_id
                                                        .toString(), // ใช้ค่าของห้องเป็นค่า value
                                                  );
                                                }),
                                              ],
                                              onChanged: (val) {
                                                // setState(() {
                                                //   print(
                                                //       "Selected Room: $val");
                                                //   selectedRoom = val;
                                                //   findequipmentByIdByAll(
                                                //       selectedRoom!);
                                                //   equipmentName.clear();
                                                //   // findrooom_idByIdByAll(buildingId!,
                                                //   //     roomfloor!, roomposition!, roomname!);
                                                //   // findequipmentByIdByAll(buildingId!,
                                                //   //     roomfloor!, roomposition!, roomname!);
                                                //   // ทำอะไรก็ตามที่คุณต้องการเมื่อเลือกห้อง
                                                // });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.red,
                                              ),
                                              dropdownColor: Colors.white,
                                              underline: null,
                                            ),
                                          ),
                                        )
                                      }
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // CustomTextFormField(
                    //     controller: informtypeTextController,
                    //     hintText: "ประเภทห้องน้ำ",
                    //     maxLength: 50,
                    //     validator: (value) {
                    //       if (value!.isNotEmpty) {
                    //         return null;
                    //       } else {
                    //         return "กรุณากรอกประเภทห้องน้ำ";
                    //       }
                    //     },
                    //     icon: const Icon(Icons.account_circle),
                    //   ),

                    // Padding(
                    //   padding: EdgeInsets.only(left: 0, top: 25, right: 0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Padding(
                    //           padding:
                    //               EdgeInsets.fromLTRB(10.0, 10, 10.0, 10), //
                    //           child: Icon(Icons.list),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Padding(
                    //           padding:
                    //               EdgeInsets.only(left: 00, top: 0, right: 0),
                    //           child: Text(
                    //             "เลขที่แจ้งซ่อม :",
                    //             style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Padding(
                    //           padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0), //
                    //           child: Text(
                    //             "${widget.informrepair_id}",
                    //             style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(child: Icon(Icons.date_range)),
                    //     Expanded(
                    //       child: Text(
                    //         "วันที่แจ้งซ่อม  :",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "$formattedDate",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // //  //--------------------------------------------
                    // Row(
                    //   children: [
                    //     Expanded(child: Icon(Icons.business)),
                    //     Expanded(
                    //       child: Text(
                    //         "อาคาร  :",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: buildingId,
                    //         items: [
                    //           DropdownMenuItem<String>(
                    //             child: Text('กรุณาเลือกอาคาร'),
                    //             value: '',
                    //           ),
                    //           ...buildings!.map((Building? building) {
                    //             return DropdownMenuItem<String>(
                    //               child: Text(building!.buildingname ?? ''),
                    //               value: building.building_id.toString(),
                    //             );
                    //           }).toList(),
                    //         ],
                    //         onChanged: (val) {
                    //           setState(() {
                    //             buildingId = val;
                    //             selectedRoom = '';
                    //             if (val != '') {
                    //               print("Controller: $buildingId");
                    //               findlistRoomByIdBybuilding_id(
                    //                   int.parse(val!), RoomType);
                    //             }
                    //           });
                    //         },
                    //         icon: const Icon(
                    //           Icons.arrow_drop_down_circle,
                    //           color: Colors.red,
                    //         ),
                    //         dropdownColor: Colors.white,
                    //       ),
                    //     )
                    //   ],
                    // ),

                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Expanded(child: Icon(Icons.business)),
                    //       Expanded(
                    //         child: Text(
                    //           "ห้อง  :",
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: DropdownButton<String>(
                    //           isExpanded: true,
                    //           value: selectedRoom,
                    //           items: [
                    //             DropdownMenuItem<String>(
                    //               child: Text('กรุณาเลือกห้อง'),
                    //               value: '', // หรือค่าว่าง
                    //             ),
                    //             ...rooms!.map((Room? room) {
                    //               return DropdownMenuItem<String>(
                    //                 child: Text("ห้อง " +
                    //                     room!.room_id.toString() +
                    //                     " ชั้น " +
                    //                     room.floor.toString() +
                    //                     " ตำแหน่ง " +
                    //                     room.position.toString() +
                    //                     " " +
                    //                     room.roomname.toString()),
                    //                 value: room.room_id.toString(),
                    //               );
                    //             }).toList(),
                    //           ],
                    //           onChanged: (val) {
                    //             setState(() {
                    //               selectedRoom = val;
                    //             });
                    //           },
                    //           icon: const Icon(
                    //             Icons.arrow_drop_down_circle,
                    //             color: Colors.red,
                    //           ),
                    //           dropdownColor: Colors.white,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    //  //---------------------------------------------------------------------------------------------
                    //  //---------------------------------------------------------------------------------------------
                    Row(children: [
                      // Expanded(child: Icon(Icons.topic_outlined)),
                      Expanded(
                        child: Text(
                          "อุปกรณ์ชำรุด",
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
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
                  if (room_id != null && room_id!.isNotEmpty) {
                    int? roomIdInt = int.tryParse(room_id![0]);
                    if (roomIdInt != null) {
                      var response =
                          await informRepairController.addInformRepair(
                        informtype,
                        statusinform,
                        user_id,
                        roomIdInt,
                      );
                      List<Map<String, dynamic>> data = [];
                      Set<String> uniqueImageFileNames = Set();

                      List<Inform_Pictures> savedInformPictures =
                          await InformRepair_PicturesController
                              .saveInform_Pictures(data);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ResultInformRepair(
                                informrepair_id:
                                    ((informrepairs?[informrepairs!.length - 1]
                                                .informrepair_id ??
                                            0) +
                                        1),
                                user: widget.user)),
                      );
                    } else {
                      // Handle the case where room_id is empty or null.
                    }
                  }
                },
              ),
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
  Map<String, List<XFile>> equipmentImages = {};

  List<bool> isChecked = [];
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  List<Widget> buildEquipmentWidgets() {
    List<Widget> widgets = [];

    for (int index = 0; index < equipmentIds.length; index++) {
      final equipmentId = equipmentIds[index];
      widgets.add(
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(equipmentName[index]),
          value: isChecked[index],
          onChanged: (bool? value) {
            setState(() {
              isChecked[index] = value ?? false;
              if (value == true) {
                detailscontrollers[index].text = '';
                amountcontrollers[index].text = '';
              }
            });
          },
        ),
      );

      widgets.add(
        Visibility(
          visible:
              isChecked[index], // Control visibility based on checkbox state
          child: Column(
            children: [
              TextFormField(
                controller: detailscontrollers[index],
                decoration: const InputDecoration(
                  hintText: 'Enter details',
                ),
                onChanged: (value) {
                  setState(() {
                    detailscontrollers[index].text = value;
                  });
                  print(detailscontrollers[index].text);
                },
              ),
              TextFormField(
                controller: amountcontrollers[index],
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                ),
                onChanged: (value) {
                  setState(() {
                    amountcontrollers[index].text = value;
                  });
                  print(amountcontrollers[index].text);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // เรียกฟังก์ชันเพิ่มรูป
                  // _addImageForEquipment(equipmentIds[index]);
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
                  final image = equipmentImages[equipmentId]![imageIndex];
                  final imagePath = image.path; // Get the image file path
                  final imageName =
                      imagePath.split('/').last; // Get the image file name

                  if (!imageFileNames.contains(imageName)) {
                    imageFileNames.add(imageName);
                  }
                  // Add the image name to the list

                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        Image.file(File(imagePath)), // Display the image
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 79,
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              imageName, // Display the image name
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
                                  (fileName) => fileName == fileNameToRemove);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
