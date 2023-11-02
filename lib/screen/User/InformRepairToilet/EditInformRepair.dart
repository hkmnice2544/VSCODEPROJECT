import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
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

  @override
  void initState() {
    super.initState();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  padding: EdgeInsets.all(16.0),
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

                      Padding(
                        padding: EdgeInsets.only(left: 0, top: 25, right: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 10, 10.0, 10), //
                                child: Icon(Icons.list),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 00, top: 0, right: 0),
                                child: Text(
                                  "เลขที่แจ้งซ่อม :",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0), //
                                child: Text(
                                  "${widget.informrepair_id}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Icon(Icons.date_range)),
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

                      //  //--------------------------------------------
                      Row(
                        children: [
                          Expanded(child: Icon(Icons.business)),
                          Expanded(
                            child: Text(
                              "อาคาร  :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: buildingId,
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('กรุณาเลือกอาคาร'),
                                  value: '',
                                ),
                                ...buildings!.map((Building? building) {
                                  return DropdownMenuItem<String>(
                                    child: Text(building!.buildingname ?? ''),
                                    value: building.building_id.toString(),
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
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.red,
                              ),
                              dropdownColor: Colors.white,
                            ),
                          )
                        ],
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: Icon(Icons.business)),
                            Expanded(
                              child: Text(
                                "ห้อง  :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedRoom,
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text('กรุณาเลือกห้อง'),
                                    value: '', // หรือค่าว่าง
                                  ),
                                  ...rooms!.map((Room? room) {
                                    return DropdownMenuItem<String>(
                                      child: Text("ห้อง " +
                                          room!.room_id.toString() +
                                          " ชั้น " +
                                          room.floor.toString() +
                                          " ตำแหน่ง " +
                                          room.position.toString() +
                                          " " +
                                          room.roomname.toString()),
                                      value: room.room_id.toString(),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    selectedRoom = val;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.red,
                                ),
                                dropdownColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      //  //---------------------------------------------------------------------------------------------
                      //  //---------------------------------------------------------------------------------------------
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

                      Row(// Button Click
                          children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                if (room_id != null && room_id!.isNotEmpty) {
                                  int? roomIdInt = int.tryParse(room_id![0]);
                                  if (roomIdInt != null) {
                                    var response = await informRepairController
                                        .addInformRepair(
                                      informtype,
                                      statusinform,
                                      user_id,
                                      roomIdInt,
                                    );
                                    List<Map<String, dynamic>> data = [];
                                    Set<String> uniqueImageFileNames = Set();

                                    // ทำการบันทึกข้อมูลใน dataList

                                    // for (int i = 0;
                                    //     i < equipmentIds.length;
                                    //     i++) {
                                    //   if (isChecked[i]) {
                                    //     int? parsedEquipmentId = int.tryParse(
                                    //         amountcontrollers[i].text);
                                    //     int? parsedEquipmentId2 =
                                    //         int.tryParse(equipmentIds[i]);
                                    //     var jsonResponse =
                                    //         await informRepairDetailsController
                                    //             .saveInformRepairDetails(
                                    //                 parsedEquipmentId ?? 1,
                                    //                 detailscontrollers[i].text,
                                    //                 ((informrepairs?[informrepairs!
                                    //                                     .length -
                                    //                                 1]
                                    //                             .informrepair_id ??
                                    //                         0) +
                                    //                     1),
                                    //                 parsedEquipmentId2 ?? 0,
                                    //                 roomIdInt);

                                    //     for (int j = 0;
                                    //         j < imageFileNames.length;
                                    //         j++) {
                                    //       if (isChecked[j]) {
                                    //         if (int.tryParse(equipmentIds[j]) ==
                                    //             parsedEquipmentId2) {
                                    //           data.add({
                                    //             "informPicturesList": [
                                    //               {
                                    //                 "pictureUrl":
                                    //                     imageFileNames[j]
                                    //               }
                                    //             ],
                                    //             "equipment_id": int.tryParse(
                                    //                     equipmentIds[j]) ??
                                    //                 0,
                                    //             "room_id": roomIdInt,
                                    //             "informrepair_id":
                                    //                 jsonResponse[0]
                                    //                         ["informrepairid"]
                                    //                     ["informrepair_id"],
                                    //           });
                                    //         }
                                    //       }
                                    //     }
                                    //   }
                                    // }

                                    List<Inform_Pictures> savedInformPictures =
                                        await InformRepair_PicturesController
                                            .saveInform_Pictures(data);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ResultInformRepair(
                                              informrepair_id: ((informrepairs?[
                                                              informrepairs!
                                                                      .length -
                                                                  1]
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
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                                textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255,
                                        255)), // สีข้อความภายในปุ่ม
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                                ),
                              ),
                              child: Text(
                                'ยืนยัน',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ResultInformRepair(
                                      informrepair_id: widget.informrepair_id,
                                      user: widget.user);
                                }));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                                textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255,
                                        255)), // สีข้อความภายในปุ่ม
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                                ),
                              ),
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ));
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
