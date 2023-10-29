import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/inform_pictures_model.dart';
import 'package:flutterr/screen/User/InformRepairToilet/EditInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/List_NewItem.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';

class ResultInformRepair extends StatefulWidget {
  final int? informrepair_id;
  final int? user;
  const ResultInformRepair({super.key, this.informrepair_id, this.user});

  @override
  State<ResultInformRepair> createState() => _ViewResultState();
}

class _ViewResultState extends State<ResultInformRepair> {
  final InformRepairController informController = InformRepairController();
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
  InformRepair_PicturesController informRepair_PicturesController =
      InformRepair_PicturesController();

  InformRepair? informRepair;
  List<InformRepair>? informrepairs;
  List<InformRepairDetails>? informRepairDetails;
  List<Inform_Pictures>? informpictures;

  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  void fetchlistAllInformRepairDetails() async {
    informRepairDetails =
        await informRepairDetailsController.getAllInformRepairDetails();
    print({informRepairDetails?[0].informdetails_id});
    setState(() {
      isDataLoaded = true;
    });
  }

  void getListInformRepairDetails() async {
    informRepairDetails =
        await informRepairDetailsController.getListInformRepairDetails();
    print({informRepairDetails?[0].details});
    setState(() {
      isDataLoaded = true;
    });
  }

  void getInform(int informrepair_id) async {
    informRepair = await informController.getInform(informrepair_id);
    print("getInform : ${informRepair?.informrepair_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void ViewListInformDetails(int informrepair_id) async {
    informRepairDetails =
        await informRepairDetailsController.ViewListInformDetails(
            informrepair_id);
    print(
        "ViewListInformDetails : ${informRepairDetails?[0].roomEquipment?.equipment?.equipment_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<InformRepairDetails> informDetails = [];

  Future getInformDetails(int informrepair_id) async {
    List<InformRepairDetails> result = await informRepairDetailsController
        .getInformDetailsById(informrepair_id);
    for (int i = 0; i < result.length; i++) {
      informDetails.add(result[i]);
    }
    // print("------ส่ง ${informDetails?[0].amount}--------");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String> Inform_pictures = [];

  // void getListinform_picturesId(
  //     int equipment_id, int informrepair_id, int room_id) async {
  //   List<String> nameList = [];
  //   informpictures = await informRepair_PicturesController
  //       .getListinform_picturesId(equipment_id, informrepair_id, room_id);
  //   for (int i = 0; i < informpictures!.length; i++) {
  //     nameList.add(informpictures![i].pictureUrl.toString());
  //     print("-------report_picture-----${nameList[i]}-------------");
  //   }
  //   setState(() {
  //     Inform_pictures = nameList;
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchlistAllInformRepairDetails();
    if (widget.informrepair_id != null) {
      getInform(widget.informrepair_id!);
    }
    getListInformRepairDetails();
    getInformDetails(widget.informrepair_id!);
    ViewListInformDetails(widget.informrepair_id!);
    print("user${widget.user}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "หน้า รายละเอียดการแจ้งซ่อม",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 21,
                    fontWeight: FontWeight.w100),
              ),
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ListInformRepair();
                  }));
                },
              ),
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
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                var username;
                                return Home(user: widget.user);
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
            backgroundColor: Colors.white,
            body: isDataLoaded == false
                ? CircularProgressIndicator()
                : //คือตัวหมนุๆ
                SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Center(
                      child: Column(children: [
                        Center(
                          child: Text(
                            "รายละเอียด",
                            style: TextStyle(
                              color: Color.fromARGB(255, 7, 94, 53),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          'images/View_Inform.png',
                          // fit: BoxFit.cover,
                          width: 220,
                          alignment: Alignment.center,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "เลขที่แจ้งซ่อม  :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.informrepair_id ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
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
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.informdate ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "ประเภทห้องน้ำ   :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.roomname ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "อาคาร   :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                // informRepair?.rooms != null
                                //     ? informRepair!.rooms!
                                //         .map((room) =>
                                //             room.building?.buildingname ??
                                //             'N/A') // ดึงข้อมูลอาคารจากอ็อบเจกต์ Room
                                //         .join(', ')
                                //     : 'N/A',
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.building?.buildingname ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "ชั้น   :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                // informRepair?.rooms != null
                                //     ? informRepair!.rooms!
                                //         .map((room) =>
                                //             room.floor ??
                                //             'N/A') // ดึงประเภทห้องน้ำจากอ็อบเจกต์ Room
                                //         .join(', ')
                                //     : 'N/A',
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.floor ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "ตำแหน่ง   :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                // informRepair?.rooms != null
                                //     ? informRepair!.rooms!
                                //         .map((room) =>
                                //             room.position ??
                                //             'N/A') // ดึงประเภทห้องน้ำจากอ็อบเจกต์ Room
                                //         .join(', ')
                                //     : 'N/A',
                                "${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.position ?? 'N/A' : 'N/A'}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "อุปกรณ์ชำรุด",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "-----------------------------------",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap:
                              true, // ตั้งค่า shrinkWrap เป็น true เพื่อให้ ListView ย่อเข้าตัวเมื่อมีเนื้อหาน้อย
                          itemCount: informDetails.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                    title: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            "อุปกรณ์ :",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 22),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${informDetails?[index].roomEquipment?.equipment?.equipmentname}",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 22),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            "รายละเอียด :",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 22),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${informDetails?[index].details}",
                                            style: const TextStyle(
                                                fontFamily: 'Itim',
                                                fontSize: 22),
                                          ),
                                        ),
                                      ]),
                                      Wrap(
                                        spacing:
                                            8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
                                        runSpacing:
                                            8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
                                        children: List.generate(
                                          Inform_pictures.length,
                                          (index) {
                                            return Container(
                                              width: 200,
                                              height: 350,
                                              child: Image.network(
                                                baseURL +
                                                    '/inform_pictures/get/${Inform_pictures[index]}',
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ])));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(// Button Click
                              children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text('ยืนยันสำเร็จ'),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return listNewItem(
                                                      user: widget.user,
                                                    );
                                                  },
                                                ));
                                              }),
                                        ],
                                      );
                                    },
                                  );
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
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    EditInformRepairs editInformRepair =
                                        EditInformRepairs();
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

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => EditInformRepairs(
                                              informrepair_id: (informRepair
                                                  ?.informrepair_id),
                                              user: widget.user)),
                                    );

                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EditInformRepairs(informrerair_id: informrepairs?[index].informrepair_id)));

                                    // Navigator.pushNamed(context, '/one');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(
                                        255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                                    textStyle: TextStyle(
                                        color: Color.fromARGB(255, 255, 255,
                                            255)), // สีข้อความภายในปุ่ม
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical:
                                            20), // การจัดพื้นที่รอบข้างปุ่ม
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                                    ),
                                  ),
                                  child: Text(
                                    'แก้ไข',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  )),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text('ยืนยันการยกเลิก'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () async {
                                              var informRepairId = informRepair
                                                      ?.informrepair_id ??
                                                  0; // 0 เป็นค่าเริ่มต้นที่ไม่เป็น null
                                              var response =
                                                  await informController
                                                      .deleteInformRepair(
                                                          informRepairId);
                                              if (response ==
                                                  "Deleted successfully") {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Home(
                                                      user: widget.user);
                                                }));
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 234, 112, 5),
                                  textStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'ยกเลิก',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ))));
  }
}
