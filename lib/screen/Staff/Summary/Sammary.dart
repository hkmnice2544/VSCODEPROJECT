import 'dart:math';
import 'dart:typed_data';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import '../../../Model/Building_Model.dart';
import '../../../controller/informrepair_controller.dart';
import 'package:intl/intl.dart';

import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:table_calendar/table_calendar.dart';

class Sammary extends StatefulWidget {
  const Sammary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าที่ Sammary"),
        backgroundColor: Colors.red,
      ),
      body: Material(
        child: Center(
          child: Text(
            "สรุปรายงานการแจ้งซ่อมห้องน้ำ",
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

class Form extends State<Sammary> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  //dropdown----------------------------------
  Form() {
    _selectedStatus = null;
    _selectedYear = null;
    _selectedThisMon = null;
    _selectedTomon = null;
  }

  String? _selectedStatus;
  String? _selectedYear;
  String? _selectedThisMon;
  String? _selectedTomon;

  final _statusList = [
    "ยังไม่ได้ดำเนินการ",
    "กำลังดำเนินการ",
    "เสร็จสิ้น",
  ];

  final _YaerList = [
    "2023",
    "2022",
    "2021",
  ];

  final _ThisMonList = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
  ];
  final _ToMonList = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
  ];

  String formattedDate = '';
  DateTime informdate = DateTime.now();

  final InformRepairController informRepairController =
      InformRepairController();
  TextEditingController defectiveequipmentTextController =
      TextEditingController();
  TextEditingController informtypeTextController = TextEditingController();
  final InformRepairController informController = InformRepairController();

  Color backgroundColor = Colors.white;
  TextEditingController textEditingController = TextEditingController();
  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];
  String isChecked = '';
  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  InformRepair? informRepair;
  List<Building>? buildings;
  String? buildingname;
  Building? building;
  DateTime Date = DateTime.now();
  DateTime? _selectedDate;

  final InformRepairController informrepairController =
      InformRepairController();

  void fetchInformRepairs() async {
    informrepairs = await informrepairController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    print(
        "getInform ปัจจุบัน : ${informrepairs?[informrepairs!.length - 1].informrepair_id}");
    print(
        "getInform +1 : ${(informrepairs?[informrepairs!.length - 1]?.informrepair_id ?? 0) + 1}");
    print("getDate 1 : ${informrepairs?[0].informdate}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  void getInform_id(int informrepair_id) async {
    informRepair = await informrepairController.getInform(informrepair_id);
    print("getInform : ${informRepair?.informrepair_id}");
    print("getDate : ${informRepair?.informdate}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInformRepairs();
    main();
    print("getDate : ${informrepairs?[0].informdate}");
    DateTime Date = DateTime.now(); // รูปแบบข้อความจากฐานข้อมูล
    // DateTime parsedDate = inputFormat.parse(informRepair!.informdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "หน้า Sammary",
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
        body: Column(children: [
          // ส่วนข้อความนอก list
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "สรุปรายงานการแจ้งซ่อมห้องน้ำ",
              style: TextStyle(
                color: Color.fromARGB(255, 7, 94, 53),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Image.asset(
            'images/Sammary.png',
            fit: BoxFit.cover,
            width: 220,
            alignment: Alignment.center,
          ),
          Text(
            _selectedYear != null
                ? "รายงานประจำปี $_selectedYear"
                : "รายงานประจำปี....",
            style: TextStyle(
              color: Color.fromARGB(255, 7, 94, 53),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0), //
                  child: Text(
                    "สถานะ :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedStatus,
                  items: _statusList
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedStatus = val as String?;
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
          Text(
  _selectedDate != null
      ? "วันที่ที่เลือก: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"
      : "เลือกวันที่",
  style: TextStyle(
    color: Color.fromARGB(255, 7, 94, 53),
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),
ElevatedButton(
  onPressed: () {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023, 1, 1), // กำหนดวันแรกของปีที่คุณต้องการ
      lastDate: DateTime(2023, 12, 31), // กำหนดวันสุดท้ายของปีที่คุณต้องการ
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  },
  child: Text("เลือกวันที่"),
),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Padding(
          //         padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0), //
          //         child: Text(
          //           "ปี :",
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: DropdownButton(
          //         isExpanded: true,
          //         value: _selectedYear,
          //         items: _YaerList.map((e) => DropdownMenuItem(
          //               child: Text(e),
          //               value: e,
          //             )).toList(),
          //         onChanged: (val) {
          //           setState(() {
          //             _selectedYear = val as String?;
          //             _selectedTomon =
          //                 null; // รีเซ็ตค่า _selectedTomon เป็น null เมื่อเลือกเปลี่ยน _selectedYear
          //           });
          //         },
          //         icon: const Icon(
          //           Icons.arrow_drop_down_circle,
          //           color: Colors.red,
          //         ),
          //         dropdownColor: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0), //
                  child: Text(
                    "เดือน :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedThisMon,
                  items: _ThisMonList.map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      )).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedThisMon = val as String?;
                      if (_selectedThisMon == null) {
                        _selectedTomon =
                            null; // กำหนด _selectedTomon เป็น null เมื่อ _selectedThisMon เป็น null
                      }
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0), //
                  child: Text(
                    "ถึง :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedTomon,
                  items: _ToMonList.map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      )).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedTomon = val as String?;
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

          Expanded(
              child: isDataLoaded == false
                  ? CircularProgressIndicator()
                  : Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: informrepairs?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if ((_selectedStatus == null ||
                                  informrepairs?[index].status ==
                                      _selectedStatus) &&
                              (_selectedYear == null ||
                                  informrepairs?[index]
                                          .informdate
                                          ?.year
                                          .toString() ==
                                      _selectedYear) &&
                              ((_selectedThisMon == null &&
                                      _selectedTomon == null) ||
                                  (_selectedThisMon != null &&
                                      informrepairs?[index]
                                              .informdate
                                              ?.month
                                              .toString()
                                              .padLeft(2, '0') ==
                                          _selectedThisMon) ||
                                  (_selectedTomon != null &&
                                      informrepairs?[index]
                                              .informdate
                                              ?.month
                                              .toString()
                                              .padLeft(2, '0') ==
                                          _selectedTomon))) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.account_circle,
                                        color: Colors.red)
                                  ],
                                ),
                                title: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          "เลขที่แจ้งซ่อม",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${informrepairs?[index].informrepair_id}",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          "วันที่แจ้งซ่อม",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          // แปลงรูปแบบวันที่และเวลาที่มาจากฐานข้อมูล
                                          informrepairs?[index].informdate !=
                                                  null
                                              ? DateFormat('dd,MM,yyyy').format(
                                                  informrepairs![index]
                                                      .informdate!)
                                              : "N/A", // หรือข้อความที่แสดงถ้าไม่มีวันที่
                                          style: const TextStyle(
                                            fontFamily: 'Itim',
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                        child: Text(
                                          "สถานะ ",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${informrepairs?[index].status}",
                                          style: const TextStyle(
                                              fontFamily: 'Itim', fontSize: 22),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                // trailing: const Icon(Icons.zoom_in, color: Colors.red),
                                onTap: () {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (_) => ViewResult(
                                    //           informrepair_id: informrepairs?[index]
                                    //               .informrepair_id)),
                                    // );
                                  });
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ))
        ]));
  }
}
