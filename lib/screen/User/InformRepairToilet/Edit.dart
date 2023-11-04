import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/model/Building_Model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/informrepair_controller.dart';
import '../../../controller/informrepairdetails_controller.dart';
import '../../../model/InformRepairDetails_Model.dart';
import '../../../model/Room_Model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

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
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];
  List<bool> isChecked = [];

  String? selectedValue;

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

  List<String>? quipment_idcheked = [];

  void findequipment_idByIdByinformrepair_id(String informrepair_id) async {
    quipment_idcheked = await informRepairDetailsController
        .findequipment_idByIdByinformrepair_id(informrepair_id);
    print(" quipment_idcheked : ${quipment_idcheked}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? details_idcheked = [];

  void finddetailsByIdByinformrepair_id(String informrepair_id) async {
    details_idcheked = await informRepairDetailsController
        .finddetailsByIdByinformrepair_id(informrepair_id);
    print(" details_idcheked : ${details_idcheked}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? amount_idcheked = [];

  void findamountByIdByinformrepair_id(String informrepair_id) async {
    amount_idcheked = await informRepairDetailsController
        .findamountByIdByinformrepair_id(informrepair_id);
    print(" amount_idcheked : ${amount_idcheked}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? pictures = [];

  void findpicturesByIdByinformrepair_id(String informrepair_id) async {
    pictures = await informRepairDetailsController
        .findpicturesByIdByinformrepair_id(informrepair_id);
    print(" pictures : ${pictures}");
    setState(() {
      isDataLoaded = true;
    });
  }

  // void findEquipmentCheckedStatus() {
  //   // isChecked = equipmentIds.map((equipmentId) {
  //   //   return quipment_idcheked!.contains(equipmentId);
  //   // }).toList();
  // }

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
    finddetailsByIdByinformrepair_id(widget.informrepair_id.toString());
    findamountByIdByinformrepair_id(widget.informrepair_id.toString());
    findpicturesByIdByinformrepair_id(widget.informrepair_id.toString());
    initialize();
    // findEquipmentCheckedStatus();
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
                          Expanded(
                            child: Text(
                              "",
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

                      DropdownButtonHideUnderline(
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
                            ...buildings.map((Building? building) {
                              return DropdownMenuItem<String>(
                                value: building!.building_id.toString(),
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
                                      building.buildingname ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }),
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
                            width: 380,
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
                            width: 380,
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

                      DropdownButtonHideUnderline(
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
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                            width: 420,
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

                      ...buildEquipmentWidgets(),
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
  List<String> report_picture = ["B.jpg", "P.jpg"];
  List<String> inform_pictures = [];
  Map<String, List<XFile>> equipmentImages = {};
  List<TextEditingController> detailscontrollers = [];
  List<TextEditingController> amountcontrollers = [];
  List<Widget> buildEquipmentWidgets() {
    List<Widget> widgets = [];

    for (int index = 0; index < equipmentIds.length; index++) {
      final equipmentId = equipmentIds[index];

      final bool isEquipmentChecked = quipment_idcheked!.contains(equipmentId);

      widgets.add(
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(equipmentName[index]),
          value: isEquipmentChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null) {
                if (value) {
                  quipment_idcheked!.add(equipmentId);
                } else {
                  quipment_idcheked!.remove(equipmentId);
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
                initialValue: details_idcheked?[index],
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
                initialValue: amount_idcheked?[index],
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
                itemCount: 1, // ให้แสดงเพียงรูปภาพเดียว
                itemBuilder: (BuildContext context, int imageIndex) {
                  final imagesForEquipment = getImagesForEquipment(equipmentId);

                  if (imageIndex < imagesForEquipment.length) {
                    final imageName = imagesForEquipment[imageIndex];
                    final imagePath =
                        '$baseURL/informrepairdetails/image/$imageName';
                    inform_pictures.add(imageName);

                    //       final image = equipmentImages[equipmentId]![imageIndex];
                    // final imagePath = image.path;
                    // final imageName = imagePath.split('/').last;

                    // if (!inform_pictures.contains(imageName)) {
                    //   inform_pictures.add(imageName);
                    // }

                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Stack(
                        children: [
                          Image.network(imagePath),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 79,
                            child: Container(
                              color: Colors.black.withOpacity(0.7),
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                imageName,
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
                  } else {
                    return Container(); // หากไม่มีรูปภาพสำหรับอุปกรณ์นี้
                  }
                },
              ),
              // Wrap(
              //   spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
              //   runSpacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
              //   children: List.generate(
              //     1,
              //     (index) {
              //       final informPicture = inform_pictures.firstWhere(
              //         (inform) {
              //           final parts = inform.split(',');
              //           return parts.length == 2 && parts[0] == equipmentId;
              //         },
              //         orElse: () => "",
              //       );

              //       if (informPicture != null) {
              //         final parts = informPicture.split(',');
              //         final imageName = parts[1];
              //         return Container(
              //           width: 200,
              //           height: 350,
              //           child: Image.network(
              //             baseURL + '/report_pictures/image/$imageName',
              //             fit: BoxFit.cover,
              //           ),
              //         );
              //       } else {
              //         return Container(); // หากไม่พบข้อมูลรูปภาพสำหรับอุปกรณ์นี้
              //       }
              //     },
              //   ),
              // )
            ],
          ),
        );
      }
    }
    return widgets;
  }

  List<String> getImagesForEquipment(String equipmentId) {
    return pictures!.where((image) {
      final parts = image.split(',');
      return parts.length == 2 && parts[0] == equipmentId;
    }).map((image) {
      final parts = image.split(',');
      return parts[1];
    }).toList();
  }
}
