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
import 'package:image_picker/image_picker.dart';

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

  Future<void> initialize() async {
    isChecked = List.filled(10, false);
    detailscontrollers = List.generate(10, (index) => TextEditingController());
    amountcontrollers = List.generate(10, (index) => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    listAllBuildings();
    ViewListInformDetails();
    fetchInformRepairs();
    print(buildingId);
    initialize();
    findequipmentByIdByAll("101");
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
