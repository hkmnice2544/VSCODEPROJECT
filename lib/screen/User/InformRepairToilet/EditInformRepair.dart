import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutterr/screen/Home.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/ResultInformRepair.dart';
import 'package:intl/intl.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';

class EditInformRepairs extends StatefulWidget {
  final int? informrepair_id;
  const EditInformRepairs({
    super.key,
    this.informrepair_id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EditInformRepair"),
        backgroundColor: Colors.red,
      ),
      body: Material(
        child: Center(
          child: Text(
            "แก้ไขแจ้งซ่อมห้องน้ำ",
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

class Form extends State<EditInformRepairs> {
  Color backgroundColor = Colors.white;

  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];
  String isChecked = 'ก๊อกน้ำ';

  final InformRepairController informrepairController =
      InformRepairController();

  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  InformRepair? informRepair;

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
    _dropdowninformtype = _informtypeList[0]; //ประเภทห้องน้ำ
    _dropdownbuildngname = _buildngnameList[0]; //ประเภทอาคาร
    _dropdownfloor = _floorList[0]; //ชั้น
    _dropdownposition = _positionList[0]; //ตำแหน่ง
  }
  TextEditingController textEditingController = TextEditingController();
  String? _dropdowninformtype = "";
  String? _dropdownbuildngname = ""; //ประเภทอาคาร
  String? _dropdownfloor = ""; //ชั้น
  String? _dropdownposition = ""; //ตำแหน่ง

  final _informtypeList = ["ห้องน้ำชาย", "ห้องน้ำหญิง"]; //ประเภทห้องน้ำ
  final _buildngnameList = [
    "อาคาร 60 ปี แม่โจ้",
    "อาคารจุฬาภรณ์",
    "อาคารเสาวรัจ"
  ]; //ประเภทอาคาร
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

  // void fetchInformRepairs() async {
  //   informrepairs = await informrepairController.updateInformRepair(
  //       "informrepair_id", "informtype", "defectiveequipment", "informdetails");
  //   print({informrepairs?[0].informrepair_id});
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  void fetchInformRepair() async {
    // informrepairs = await informrepairController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    // print(informRepairs?.defectiveequipment);
    setState(() {
      isDataLoaded = true;
    });
  }

  // void fetchgetListInform(int informrepair_id) async {
  //   informRepair = await informrepairController.getInform(informrepair_id);
  //   textEditingController.text = informRepair?.informdetails ?? '';
  //   _dropdowninformtype = informRepair?.informtype ?? '';
  //   print("textEditingControllerrr:${textEditingController.text}");
  //   print("id : ${informrepair_id}");
  //   print("informdetails : ${informRepair!.informdetails}");
  //   print("textEditingController:${textEditingController.text}");

  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // fetchInformRepairs();
    fetchInformRepair();
    // fetchgetListInform(widget.informrepair_id!);
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    // if (informRepair != null) {
    //   _dropdowninformtype = informRepair!.informtype!;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "หน้า EditInformRepairToilet",
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
                            return Home(username: 'ชื่อผู้ใช้');
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
                          "${informrepairs?[informrepairs!.length - 1].informrepair_id}",
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
                        '$formattedDate',
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
                      child: // DropdownButton ประเภทห้องน้ำ-------------------------------------
                          DropdownButton(
                        isExpanded: true,
                        value: _dropdowninformtype,
                        items: _informtypeList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _dropdowninformtype = val as String;
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
                          DropdownButton(
                        isExpanded: true,
                        value: _dropdownbuildngname,
                        items: _buildngnameList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _dropdownbuildngname = val as String;
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
                      child: // DropdownButton  ชั้น-------------------------------------
                          DropdownButton(
                        isExpanded: true,
                        value: _dropdownfloor,
                        items: _floorList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _dropdownfloor = val as String;
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
                      child: // DropdownButton  ตำแหน่ง-------------------------------------
                          DropdownButton(
                        isExpanded: true,
                        value: _dropdownposition,
                        items: _positionList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _dropdownposition = val as String;
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
                  Text(""),
                ]),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked == 'ก๊อกน้ำ',
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            isChecked = 'ก๊อกน้ำ';
                          } else {
                            isChecked = '';
                          }
                          print(isChecked);
                        });
                      },
                    ),
                    Icon(Icons.topic_outlined),
                    Text('ก๊อกน้ำ'),
                  ],
                ),
                Row(// Button Click
                    children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          // //   InformRepair informRepairs = InformRepair();
                          // var response =
                          //     await informRepairController.updateInformRepair(
                          //   informRepair!.informrepair_id as String,
                          //   _dropdowninformtype ?? "",
                          //   isChecked,
                          //   textEditingController.text,
                          // );
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (_) => ResultInformRepair(
                          //           informrepair_id:
                          //               (informRepair?.informrepair_id))),
                          // );

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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ResultInformRepair(
                                    informrepair_id:
                                        (informRepair?.informrepair_id))),
                          );

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
