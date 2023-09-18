import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/ResultInformRepair.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import '../../../controller/informrepair_controller.dart';
import 'package:intl/intl.dart';
import '../../../model/Building_Model.dart';
import '../../../model/informrepair_model.dart';
import 'package:http/http.dart' as http;

class InformRepairForm extends StatefulWidget {
  const InformRepairForm({super.key});
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

//dropdown----------------------------------
  Form() {
    //dropdown
    _dropdowninformtype = rooms?[0].roomname; //ประเภทห้องน้ำ
    _dropdownbuildngname = buildings?[0].buildingname; //ประเภทอาคาร
    _dropdownfloor = _floorList[0]; //ชั้น
    _dropdownposition = _positionList[0]; //ตำแหน่ง
  }

  String? _dropdowninformtype; //ประเภทห้องน้ำ
  String? _dropdownbuildngname = ""; //ประเภทอาคาร
  String? _dropdownfloor = ""; //ชั้น
  String? _dropdownposition = ""; //ตำแหน่ง

  final _floorList = ["1", "2", "3", "4"]; //ชั้น
  final _positionList = ["ข้างลิฟท์", "ข้างบันได"]; //ตำแหน่ง

//CheckBox----------------------------------
  bool? _tapCheckBox = false; //ก๊อกน้ำ
  bool? _toiletbowlCheckBox = false; //โถชักโครก
  bool? _bidetCheckBox = false; //สายชำระ
  bool? _urinalCheckBox = false; //โถฉี่ชาย
  bool? _sinkCheckBox = false; //อ่างล้างมือ
  bool? _lightbulbCheckBox = false; //หลอดไฟ
  bool? _otherCheckBox = false; //อื่นๆ

  Color backgroundColor = Colors.white;
  TextEditingController textEditingController = TextEditingController();
  String isChecked = '';
  List<InformRepair>? informrepairs;
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
        "getInform +1 : ${(informrepairs?[informrepairs!.length - 1]?.informrepair_id ?? 0) + 1}");
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
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // fetchListBuilding();
    main();
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
                Expanded(
                  child: IconButton(
                      icon: Icon(Icons.home),
                      color: Color.fromARGB(255, 255, 255, 255),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Home();
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

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10), //
                        child: Icon(Icons.list),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0), //
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
                          "${(informrepairs?[informrepairs!.length - 1]?.informrepair_id ?? 0) + 1}",
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
                      value: isChecked == 'ก๊อกน้ำ',
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value != null && value ? 'ก๊อกน้ำ' : '';
                          print(isChecked);
                        });
                      },
                    ),
                    Icon(Icons.add_circle),
                    Text('ก๊อกน้ำ'),
                  ],
                ),

                Row(// Button Click
                    children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          // InformRepair informRepairs = InformRepair();
                          // informRepairs.informtype = _dropdowninformtype!;
                          // informRepairs.tap = isChecked;
                          // informRepairs.informdetails = textEditingController;

                          // var response = await informRepairController.addInformRepair(_dropdowninformtype?? "",isChecked,textEditingController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MyResult(
                                    informrepair_id: (informrepairs?[
                                                    informrepairs!.length - 1]
                                                ?.informrepair_id ??
                                            0) +
                                        1)),
                          );
                          print("object");

                          // InformRepair informRepair = InformRepair();
                          // informRepair.informtype = _dropdowninformtype!;
                          // informRepair.buildngname = _dropdownbuildngname!;
                          // informRepair.floor = _dropdownfloor!;
                          // informRepair.position = _dropdownposition!;
                          // informRepair.tap = _tapCheckBox!;
                          // informRepair.toiletbowl = _toiletbowlCheckBox!;
                          // informRepair.bidet = _bidetCheckBox!;
                          // informRepair.urinal = _urinalCheckBox!;
                          // informRepair.sink = _sinkCheckBox!;
                          // informRepair.lightbulb = _lightbulbCheckBox!;
                          // informRepair.other = _otherCheckBox!;

                          // informrepairDetails.informtype = _dropdowninformtype!;
                          // Navigator.push(context,MaterialPageRoute(builder: (context){
                          //   return MyResult(informRepair: informRepair,);
                          // }));

                          // Navigator.pushNamed(context, '/one');
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
                          // var response = await informController.addInformRepair(todoHeaderTextController.text);

                          // informrepairDetails.informtype = _dropdowninformtype!;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Home();
                          }));

                          // Navigator.pushNamed(context, '/one');
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
