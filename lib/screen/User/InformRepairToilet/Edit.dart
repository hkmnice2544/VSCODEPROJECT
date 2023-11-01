import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterr/model/Building_Model.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../controller/informrepairdetails_controller.dart';
import '../../../model/InformRepairDetails_Model.dart';
import '../../../model/Room_Model.dart';
import '../../Home.dart';
import '../../Login.dart';

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
  Building? building;

  InformRepairController informrepairController = InformRepairController();
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
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
    listAllBuildings();
    ViewListInformDetails();
    fetchInformRepairs();
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
                        padding: EdgeInsets.only(left: 0, top: 25, right: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(Icons.list),
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
                                ...buildings.map((Building? building) {
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
                                  ...rooms.map((Room? room) {
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
                    ]),
                  ),
                ),
              ));
  }
}
