import 'dart:convert';
import 'dart:io';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/inform_pictures_model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import '../../../controller/informrepair_controller.dart';
import 'package:intl/intl.dart';
import '../../../model/Building_Model.dart';
import '../../../model/InformRepairDetails_Model.dart';
import '../../../model/informrepair_model.dart';
import 'package:http/http.dart' as http;

class InformRepairForm extends StatefulWidget {
  final int? user;
  InformRepairForm({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าที่ InformRepairForm"),
        backgroundColor: Colors.red,
      ),
      body: Material(
        child: Center(
          child: Text(
            "แจ้งซ่อมห้องน้ำ",
            style: TextStyle(
              color: Color.fromARGB(255, 7, 94, 53),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: Color.fromARGB(255, 245, 59, 59),
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 245, 59, 59),
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Form createState() => Form();
}

class Form extends State<InformRepairForm> {
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

  // จำนวน
  TextEditingController _tapCountController = TextEditingController();
  TextEditingController _toiletbowlCountController = TextEditingController();
  TextEditingController _bidetCheckCountController = TextEditingController();
  TextEditingController _urinalCheckCountController = TextEditingController();
  TextEditingController _sinkCheckCountController = TextEditingController();
  TextEditingController _lightbulbCheckCountController =
      TextEditingController();

  String _tapCheckBox = '';
  String _toiletbowlCheckBox = '';
  String _bidetCheckBox = '';
  String _urinalCheckBox = '';
  String _sinkCheckBox = '';
  String _lightbulbCheckBox = '';

  List<InformRepair>? informrepairs;
  List<InformRepairDetails>? informdetails;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  InformRepair? informRepair;
  List<Building>? buildings;
  String? buildingname;
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
  String room_id = '';
  String? informrepair_idvar;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
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

  void listAllInformRepairDetails() async {
    informdetails =
        await informRepairDetailsController.listAllInformRepairDetails();
    // print({informdetails?[0].informdetails_id});
    print(
        "getinformdetails_id ปัจจุบัน : ${informdetails?[informdetails!.length - 1].informdetails_id}");
    print(
        "getinformdetails_id +1 : ${(informdetails?[informdetails!.length - 1].informdetails_id ?? 0) + 1}");

    setState(() {
      isDataLoaded = true;
    });
  }

  void listAllBuildings() async {
    buildings =
        (await informrepairController.listAllBuildings()).cast<Building>();
    print("listAllBuildings : ${buildings?[0].building_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  @override
  void initState() {
    super.initState();
    fetchInformRepairs();
    listAllBuildings();
    fetchRoomNames();
    fetchRoomfloors();
    fetchRoompositions();
    // listAllInformRepairDetails();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // fetchListBuilding();
    main();
    // print('user_id----${user_id}');
    // print('imageFileNames----${imageFileNames}');
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
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return Home(username: widget.username);
                      //   },
                      // ));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // นำทางไปยังหน้าอื่นที่คุณต้องการ
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return Home(username: widget.username);
                      //   },
                      // ));
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(children: [
                Text(
                  "แจ้งซ่อมห้องน้ำ",
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
                          padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10), //
                          child: Icon(Icons.list),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 00, top: 0, right: 0),
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
                            "${(informrepairs?[informrepairs!.length - 1].informrepair_id ?? 0) + 1}",
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
                    Expanded(child: Icon(Icons.featured_play_list_outlined)),
                    Expanded(
                      child: Text(
                        "ประเภทห้องน้ำ  :",
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
                        value: roomname != null && roomNames.contains(roomname)
                            ? roomname
                            : roomNames.isNotEmpty
                                ? roomNames[0]
                                : null,
                        items: roomNames.map((String roomname) {
                          return DropdownMenuItem<String>(
                            child: Text(roomname),
                            value: roomname,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            roomname = val;
                            print("Controller: $roomname");
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
                      child: // DropdownButton  ประเภทอาคาร-------------------------------------
                          DropdownButton<String>(
                        isExpanded: true,
                        value: buildingname != null &&
                                buildings?.any((building) =>
                                        building.buildingname ==
                                        buildingname) ==
                                    true
                            ? buildingname
                            : buildings?.isNotEmpty == true
                                ? buildings![0].buildingname
                                : null,
                        items: buildings?.map((Building building) {
                          return DropdownMenuItem<String>(
                            child: Text(building.buildingname ?? ''),
                            value: building.buildingname,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            buildingname = val;
                            print("Controller: $buildingname");
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
                    Expanded(child: Icon(Icons.linear_scale_outlined)),
                    Expanded(
                      child: Text(
                        "ชั้น  :",
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
                        value:
                            roomfloor != null && roomfloors.contains(roomfloor)
                                ? roomfloor
                                : roomfloors.isNotEmpty
                                    ? roomfloors[0]
                                    : null,
                        items: roomfloors.map((String roomfloor) {
                          return DropdownMenuItem<String>(
                            child: Text(roomfloor),
                            value: roomfloor,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            roomfloor = val;
                            print("Controller: $roomfloor");
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
                    Expanded(child: Icon(Icons.location_on)),
                    Expanded(
                      child: Text(
                        "ตำแหน่ง  :",
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
                        value: roomposition != null &&
                                roompositions.contains(roomposition)
                            ? roomposition
                            : roompositions.isNotEmpty
                                ? roompositions[0]
                                : null,
                        items: roompositions.map((String roomposition) {
                          return DropdownMenuItem<String>(
                            child: Text(roomposition),
                            value: roomposition,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            roomposition = val;
                            print("Controller: $roomposition");
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
                Row(
                  children: [
                    Checkbox(
                      value: _tapCheckBox == '1001',
                      onChanged: (bool? value) {
                        setState(() {
                          _tapCheckBox = value != null && value ? '1001' : '';
                          print(_tapCheckBox);
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('ก๊อกน้ำ'),
                  ],
                ),
                if (_tapCheckBox.isNotEmpty) ...[
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3, // 3 คอลัมน์
                  //   ),
                  //   itemCount: imageFileList.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     String fileName =
                  //         imageFileList[index].path.split('/').last;
                  //     imageFileNames.add(fileName); // เพิ่มชื่อไฟล์ลงใน List
                  //     return Padding(
                  //       padding: const EdgeInsets.all(2),
                  //       child: Stack(
                  //         children: [
                  //           Image.file(File(imageFileList[index].path)),
                  //           Positioned(
                  //             bottom: 0,
                  //             left: 0,
                  //             right: 79,
                  //             child: Container(
                  //               color: Colors.black.withOpacity(0.7),
                  //               padding: EdgeInsets.all(5.0),
                  //               child: Text(
                  //                 fileName, // ใช้ชื่อไฟล์แทน
                  //                 style: TextStyle(color: Colors.white),
                  //               ),
                  //             ),
                  //           ),
                  //           Positioned(
                  //             top: 0,
                  //             right: 30,
                  //             child: IconButton(
                  //               icon: Icon(
                  //                 Icons.highlight_remove_sharp,
                  //                 color: Colors.red,
                  //               ),
                  //               onPressed: () {
                  //                 // ลบรูปออกจาก imageFileList
                  //                 setState(() {
                  //                   imageFileList.removeAt(index);
                  //                 });
                  //                 // ลบชื่อรูปภาพที่เกี่ยวข้องออกจาก imageFileNames
                  //                 String fileNameToRemove =
                  //                     imageFileNames[index];
                  //                 imageFileNames.removeWhere((fileName) =>
                  //                     fileName == fileNameToRemove);
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  // MaterialButton(
                  //     color: Colors.blue,
                  //     child: Text(
                  //       "Pick",
                  //       style: TextStyle(
                  //           color: Colors.white, fontWeight: FontWeight.bold),
                  //     ),
                  //     onPressed: () {
                  //       selectImages();
                  //       print('imageFileNames----${imageFileNames}');
                  //     }),
                  TextField(
                    controller: _tapCheckBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_tapCheckBox == "") {
                        _tapCheckBoxController.clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _tapCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_tapCheckBox == "") {
                        _tapCountController.clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],

                Row(
                  children: [
                    Checkbox(
                      value: _toiletbowlCheckBox == '1002',
                      onChanged: (bool? value) {
                        setState(() {
                          _toiletbowlCheckBox =
                              value != null && value ? '1002' : '';
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('โถชักโครก'),
                  ],
                ),
                if (_toiletbowlCheckBox.isNotEmpty) ...[
                  TextField(
                    controller: _toiletbowlBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_toiletbowlCheckBox == "") {
                        _toiletbowlBoxController.clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _toiletbowlCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_toiletbowlCheckBox == "") {
                        _toiletbowlCountController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],
                Row(
                  children: [
                    Checkbox(
                      value: _bidetCheckBox == '1003',
                      onChanged: (bool? value) {
                        setState(() {
                          _bidetCheckBox = value != null && value ? '1003' : '';
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('สายชำระ'),
                  ],
                ),
                if (_bidetCheckBox.isNotEmpty) ...[
                  TextField(
                    controller: _bidetCheckBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_bidetCheckBox == "") {
                        _bidetCheckBoxController.clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _bidetCheckCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_bidetCheckBox == "") {
                        _bidetCheckCountController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],
                Row(
                  children: [
                    Checkbox(
                      value: _urinalCheckBox == '1004',
                      onChanged: (bool? value) {
                        setState(() {
                          _urinalCheckBox =
                              value != null && value ? '1004' : '';
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('โถฉี่ชาย'),
                  ],
                ),
                if (_urinalCheckBox.isNotEmpty) ...[
                  TextField(
                    controller: _urinalCheckBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_urinalCheckBox == "") {
                        _urinalCheckBoxController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _urinalCheckCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_urinalCheckBox == "") {
                        _urinalCheckCountController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],
                Row(
                  children: [
                    Checkbox(
                      value: _sinkCheckBox == '1005',
                      onChanged: (bool? value) {
                        setState(() {
                          _sinkCheckBox = value != null && value ? '1005' : '';
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('อ่างล้างมือ'),
                  ],
                ),
                if (_sinkCheckBox.isNotEmpty) ...[
                  TextField(
                    controller: _sinkCheckBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_sinkCheckBox == "") {
                        _sinkCheckBoxController.clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _sinkCheckCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_sinkCheckBox == "") {
                        _sinkCheckCountController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],
                Row(
                  children: [
                    Checkbox(
                      value: _lightbulbCheckBox == '1006',
                      onChanged: (bool? value) {
                        setState(() {
                          _lightbulbCheckBox =
                              value != null && value ? '1006' : '';
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('โถชักโครก'),
                  ],
                ),
                if (_lightbulbCheckBox.isNotEmpty) ...[
                  TextField(
                    controller: _lightbulbCheckBoxController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                    onChanged: (value) {
                      if (_lightbulbCheckBox == "") {
                        _lightbulbCheckBoxController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                  TextField(
                    controller: _lightbulbCheckCountController,
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                    ),
                    onChanged: (value) {
                      if (_lightbulbCheckBox == "") {
                        _lightbulbCheckCountController
                            .clear(); // ล้างค่าใน TextField
                      }
                    },
                  ),
                ],

                Row(// Button Click
                    children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          var response =
                              await informRepairController.addInformRepair(
                                  informtype, statusinform, user_id);

                          List<Map<String, String>> dataList = [];

                          void addToDataList(
                              String equipmentId,
                              TextEditingController detailsController,
                              TextEditingController countController) {
                            if (roomname == "ห้องน้ำชาย" &&
                                buildingname == "อาคาร 60 ปี แม่โจ้" &&
                                roomfloor == "1" &&
                                roomposition == "ข้างบันได" &&
                                equipmentId.isNotEmpty)
                              print(
                                  "-------dataList---countController---${countController.text}--------------");
                            print(
                                "-------dataList--detailsController----${detailsController.text}--------------");
                            print(
                                "-------dataList---informrepairs---${((informrepairs?[informrepairs!.length - 1].informrepair_id ?? 0) + 1).toString()}--------------");
                            print(
                                "-------dataList--equipmentId----${equipmentId}--------------");
                            print(
                                "-------dataList---statusinformdetails---${statusinformdetails}--------------");

                            {
                              dataList.add({
                                'amount': countController.text,
                                'details': detailsController.text,
                                'informrepair_id':
                                    ((informrepairs?[informrepairs!.length - 1]
                                                    .informrepair_id ??
                                                0) +
                                            1)
                                        .toString(),
                                'equipment_id': equipmentId,
                                'room_id': "101",
                                'status': statusinformdetails,
                              });
                            }
                            if (roomname == "ห้องน้ำหญิง" &&
                                buildingname == "อาคาร 60 ปี แม่โจ้" &&
                                roomfloor == "1" &&
                                roomposition == "ข้างบันได" &&
                                equipmentId.isNotEmpty) {
                              dataList.add({
                                'amount': countController.text,
                                'details': detailsController.text,
                                'informrepair_id':
                                    ((informrepairs?[informrepairs!.length - 1]
                                                    .informrepair_id ??
                                                0) +
                                            1)
                                        .toString(),
                                'equipment_id': equipmentId,
                                'room_id': "102",
                                'status': statusinformdetails,
                              });
                            }
                          }

                          addToDataList('1001', _tapCheckBoxController,
                              _tapCountController);
                          addToDataList('1002', _toiletbowlBoxController,
                              _toiletbowlCountController);
                          addToDataList('1003', _bidetCheckBoxController,
                              _bidetCheckCountController);
                          addToDataList('1004', _urinalCheckBoxController,
                              _urinalCheckCountController);
                          addToDataList('1005', _sinkCheckBoxController,
                              _sinkCheckCountController);
                          addToDataList('1006', _lightbulbCheckBoxController,
                              _lightbulbCheckCountController);
                          InformRepairDetailsController.saveInformRepairDetails(
                              dataList);

                          // final List<Map<String, dynamic>> data = [];
                          // for (final imageName in imageFileNames) {
                          //   if (!data.any(
                          //       (item) => item["pictureUrl"] == imageName)) {
                          //     data.add({
                          //       "pictureUrl": imageName,
                          //       "informRepairDetails": {
                          //         "informdetails_id": 10001,
                          // ((informdetails?[
                          //                 informdetails!.length - 1]
                          //             .informdetails_id ??
                          //         0) +
                          //     1),
                          //       },
                          //     });
                          //   }
                          // }

                          // final List<Inform_Pictures> saveInform_Pictures =
                          //     await InformRepair_PicturesController
                          //         .saveInform_Pictures(data);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Home(user: widget.user);
                            }),
                          );

                          // int u = 1001; // User ID

                          // // สร้างรายการ ID และรายละเอียดที่มีค่าไม่เป็นว่าง
                          // List<Map<String, String>> idDetailsList = [];

                          // if (roomname == "ห้องน้ำชาย" &&
                          //     buildingname == "อาคาร 60 ปี แม่โจ้" &&
                          //     roomfloor == "1" &&
                          //     roomposition == "ข้างบันได") {
                          //   // ให้เพิ่มรายการสำหรับอุปกรณ์ก๊อกน้ำ
                          //   String detail1 = _tapCheckBoxController.text;
                          //   idDetailsList.add({
                          //     "informdetails": detail1,
                          //     "status": "ยังไม่ได้ดำเนินการ",
                          //     "equipment_id": "1001",
                          //     "user_id": u.toString(),
                          //   });
                          // }

                          // if (_toiletbowlCheckBox == 'โถชักโครก' &&
                          //     roomname == "ห้องน้ำชาย" &&
                          //     buildingname == "อาคาร 60 ปี แม่โจ้" &&
                          //     roomfloor == "1" &&
                          //     roomposition == "ข้างบันได") {
                          //   // ให้เพิ่มรายการสำหรับอุปกรณ์โถชักโครก
                          //   String detail2 = _toiletbowlBoxController.text;
                          //   idDetailsList.add({
                          //     "informdetails": detail2,
                          //     "status": "ยังไม่ได้ดำเนินการ",
                          //     "equipment_id": "1001",
                          //     "user_id": u.toString(),
                          //   });
                          // }
                          // if (idDetailsList.isNotEmpty) {
                          //   // เรียกใช้ addInformRepair ด้วยข้อมูลที่เตรียมไว้
                          //   var response = await informController
                          //       .addInformRepair(idDetailsList);

                          //   // หลังจากส่งข้อมูลไปยังเซิร์ฟเวอร์เรียบร้อยแล้ว
                          //   // คุณสามารถนำผู้ใช้ไปยังหน้า ListManage หรือทำอย่างอื่นตามที่ต้องการ
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => ResultInformRepair(
                          //             informrepair_id: (informrepairs?[
                          //                             informrepairs!.length - 1]
                          //                         ?.informrepair_id ??
                          //                     0) +
                          //                 1)),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                          textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // สีข้อความภายในปุ่ม
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
                            return Home(user: widget.user);
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                          textStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 255, 255, 255)), // สีข้อความภายในปุ่ม
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
}
