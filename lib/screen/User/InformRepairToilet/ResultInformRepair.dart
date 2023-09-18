import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/EditInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/List_NewItem.dart';
import 'package:intl/intl.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';

class ResultInformRepair extends StatefulWidget {
  final int? informrepair_id;
  const ResultInformRepair({
    super.key,
    this.informrepair_id,
  });

//   MyResult(
//     {Key?key,required this.informRepairs}):super(key:key);
// InformRepair informRepairs;

  @override
  State<ResultInformRepair> createState() => _MyResultState();
}

class _MyResultState extends State<ResultInformRepair> {
  bool isChecked = false;

  String formattedDate = '';
  DateTime informdate = DateTime.now();

  // MyResult(
  final InformRepairController informrepairController =
      InformRepairController();

  bool? isDataLoaded = false;
  List<InformRepair>? informrepairs;
  InformRepair? informRepairs;
  InformRepair? informRepair;
  int? informrepair_id;

  void fetchInformRepairs() async {
    informRepairs =
        await informrepairController.deleteInformRepair(informrepair_id);
    print(informrepairs?[informrepairs!.length - 1].informrepair_id);
    setState(() {
      isDataLoaded = true;
    });
  }

  void fetchInformRepair() async {
    informrepairs = await informrepairController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    print("informtype : ${informRepair!.informtype}");

    // print(informRepairs?.defectiveequipment);
    setState(() {
      isDataLoaded = true;
    });
  }

  void fetchgetListInform(int informrepair_id) async {
    informRepair = await informrepairController.getInform(informrepair_id);
    print("fetchgetListInform : ${informRepair!.informtype}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInformRepairs();
    fetchgetListInform(widget.informrepair_id!);
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า ResultInformToilet",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
              fontWeight: FontWeight.w100),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "แจ้งซ่อมห้องน้ำเสร็จสิ้น",
              style: TextStyle(
                color: Color.fromARGB(255, 7, 94, 53),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'images/ResultInformToilet.png',
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
                    "${informRepair?.informrepair_id}",
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
                    informRepair?.equipment?.rooms != null
                        ? informRepair!.equipment!.rooms!
                            .map((room) => room.roomname!)
                            .join(', ')
                        : 'N/A',
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
                    informRepair?.equipment?.rooms != null
                        ? informRepair!.equipment!.rooms!
                            .map((room) => room.building?.buildingname ?? 'N/A')
                            .join(', ')
                        : 'N/A',
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
                    informRepair?.equipment?.rooms != null
                        ? informRepair!.equipment!.rooms!
                            .map((room) => room.floor ?? 'N/A')
                            .join(', ')
                        : 'N/A',
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
                    informRepair?.equipment?.rooms != null
                        ? informRepair!.equipment!.rooms!
                            .map((room) => room.position ?? 'N/A')
                            .join(', ')
                        : 'N/A',
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
                  "-------------------------------------------",
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
                  "${informRepair?.defectiveequipment}",
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
                Expanded(
                  child: Text(
                    "รายละเอียด   :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${informRepair?.informdetails}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            //     Row(
            //       children: [
            //       informRepair.toiletbowl //โถชักโครก
            //       ?(const Chip(
            //       label: Text("โถชักโครก"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //       informRepair.bidet //สายชำระ
            //       ?(const Chip(
            //       label: Text("สายชำระ"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //       informRepair.urinal //โถฉี่ชาย
            //       ?(const Chip(
            //       label: Text("โถฉี่ชาย"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //       informRepair.sink //อ่างล้างมือ
            //       ?(const Chip(
            //       label: Text("อ่างล้างมือ"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //       informRepair.lightbulb //หลอดไฟ
            //       ?(const Chip(
            //       label: Text("หลอดไฟ"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //       informRepair.other //อื่นๆ
            //       ?(const Chip(
            //       label: Text("อื่นๆ"),
            //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       backgroundColor: Colors.red,
            //       labelStyle: TextStyle(color: Colors.white)))
            //       :Text(""),
            //       ],
            //     ),
            Row(// Button Click
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
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return listAllInformRepairs();
                                    },
                                  ));
                                }),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 234, 112, 5), // สีพื้นหลังของปุ่ม
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
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      EditInformRepairs editInformRepair = EditInformRepairs();
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
                                informrepair_id:
                                    (informRepair?.informrepair_id))),
                      );

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EditInformRepairs(informrerair_id: informrepairs?[index].informrepair_id)));

                      // Navigator.pushNamed(context, '/one');
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color.fromARGB(255, 234, 112, 5), // สีพื้นหลังของปุ่ม
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
                      'แก้ไข',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                                var response = await informrepairController
                                    .deleteInformRepair(
                                        informRepair?.informrepair_id);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home();
                                }));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 234, 112, 5),
                    textStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
