import 'dart:typed_data';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/Summary/View_Sum.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Model/Building_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:table_calendar/table_calendar.dart';

class Summary extends StatefulWidget {
  final int? user;
  const Summary({
    super.key,
    this.user,
  });

  @override
  Form createState() => Form();
}

class Form extends State<Summary> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedStatus;
  String? _selectedYear;
  String? _selectedThisMon;
  String? _selectedTomon;
  final _statusList = ["ยังไม่ได้ดำเนินการ", "กำลังดำเนินการ", "เสร็จสิ้น"];

  String formattedDate = '';
  DateTime informdate = DateTime.now();

  TextEditingController defectiveEquipmentTextController =
      TextEditingController();
  TextEditingController informTypeTextController = TextEditingController();
  final InformRepairController informController = InformRepairController();
  Color backgroundColor = Colors.white;
  TextEditingController textEditingController = TextEditingController();
  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];
  String isChecked = '';
  List<InformRepair>? informRepairs;
  bool? isDataLoaded = false;
  InformRepair? informRepair;
  List<Building>? buildings;
  String? buildingName;
  Building? building;
  DateTime date = DateTime.now();
  DateTime? _selectedDateStart;
  DateTime? _selectedDate;
  int initialYear = DateTime.now().year;
  List<InformRepair> filteredInformRepairs = [];

  final InformRepairController informRepairController =
      InformRepairController();

  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();
  List<InformRepairDetails>? informRepairDetails;

  void _updateFilteredInformRepairs() {
    setState(() {
      filteredInformRepairs = informRepairs!.where((informRepair) {
        // ตรวจสอบสถานะ (ถ้าเลือกสถานะเท่านั้น)
        bool statusCondition =
            _selectedStatus == null || _selectedStatus == informRepair.status;

        // ตรวจสอบว่าวันที่เริ่มต้นและสิ้นสุดอยู่ในช่วงของวันที่ใน informRepair
        bool dateCondition = true;

        if (_startDate != null && _endDate != null) {
          DateTime startDateStartOfDay = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
          );

          DateTime endDateEndOfDay = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
          ).add(Duration(days: 1));

          dateCondition =
              informRepair.informdate!.isAfter(startDateStartOfDay) &&
                  informRepair.informdate!.isBefore(endDateEndOfDay);
        }

        return statusCondition && dateCondition;
      }).toList();
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedStartDate != null) {
      // ตั้งค่า _startDate เป็น null ก่อนเพื่อป้องกันความผิดพลาด
      setState(() {
        _startDate = null;
      });

      setState(() {
        _startDate = pickedStartDate;
      });
      _updateFilteredInformRepairs();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final pickedEndDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedEndDate != null) {
      // ตั้งค่า _endDate เป็น null ก่อนเพื่อป้องกันความผิดพลาด
      setState(() {
        _endDate = null;
      });

      setState(() {
        _endDate = pickedEndDate;
      });
      _updateFilteredInformRepairs();
    }
  }

  void listAllInformRepairDetails() async {
    // เรียกใช้งาน listAllInformRepairDetails และรอข้อมูลเสร็จสมบูรณ์
    informRepairDetails =
        (await informRepairDetailsController.listAllInformRepairDetails())
            .cast<InformRepairDetails>();

    // หลังจากที่ข้อมูลถูกโหลดเสร็จแล้ว คุณสามารถทำตามที่คุณต้องการกับข้อมูลได้
    informRepairs?.sort((a, b) {
      if (a.informdate == null && b.informdate == null) {
        return 0;
      } else if (a.informdate == null) {
        return 1;
      } else if (b.informdate == null) {
        return -1;
      }
      return b.informdate!.compareTo(a.informdate!);
    });

    // อัปเดตสถานะแสดงว่าข้อมูลถูกโหลดแล้ว
    setState(() {
      isDataLoaded = true;
    });
  }

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  void getInformId(int informRepairId) async {
    // informRepair = await informRepairController.getInform(informRepairId);
    print("getInform : ${informRepair?.informrepair_id}");
    print("getDate : ${informRepair?.informdate}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? amounts = [];
  void listAllInformRepair() async {
    informRepairs = await informRepairController.listAllInformRepairs();
    for (int i = 0; i < informRepairs!.length; i++) {
      amounts!.add(await informRepairController
          .findSumamountById(informRepairs![i].informrepair_id ?? 0));
    }
    print("------------${informRepairs![0].informrepair_id}-------------");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    listAllInformRepair();
    main();
    print("getDate : ${informRepairs?[0].informdate}");
    DateTime date = DateTime.now(); // รูปแบบข้อความจากฐานข้อมูล
    // DateTime parsedDate = inputFormat.parse(informRepair!.informdate);
    informRepairs?.sort((a, b) {
      if (a.informdate == null && b.informdate == null) {
        return 0;
      } else if (a.informdate == null) {
        return 1;
      } else if (b.informdate == null) {
        return -1;
      }
      return b.informdate!.compareTo(a.informdate!);
    });
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
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                color: Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HomeStaff(user: 0);
                    },
                  ));
                },
              ),
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
                },
              ),
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
          ],
        ),
      ),
      body: Column(
        children: [
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
                : "รายงานประจำปี",
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
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
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
                    _updateFilteredInformRepairs(); // เรียกให้คลิกสถานะแล้วกรองข้อมูล
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
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                  child: Text(
                    "วันที่เริ่มต้น :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _selectStartDate(context);
                  },
                  child: Text(
                    _startDate != null
                        ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                        : "เลือกวันที่เริ่มต้น",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                  child: Text(
                    "วันที่สิ้นสุด :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _selectEndDate(context);
                  },
                  child: Text(
                    _endDate != null
                        ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                        : "เลือกวันที่สิ้นสุด",
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: isDataLoaded == false
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _selectedStatus != null
                        ? filteredInformRepairs.length
                        : (informRepairs?.length ?? 0),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final informRepair = _selectedStatus != null
                          ? filteredInformRepairs[index]
                          : informRepairs![index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_circle, color: Colors.red),
                            ],
                          ),
                          title: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "เลขที่แจ้งซ่อม",
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair.informrepair_id}",
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "วันที่แจ้งซ่อม",
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      informRepair.informdate != null
                                          ? DateFormat('dd/MM/yyyy')
                                              .format(informRepair.informdate!)
                                          : "N/A",
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "สถานะ",
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      informRepair.status as String,
                                      style: const TextStyle(
                                        fontFamily: 'Itim',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => View_Sum(
                                        informrepair_id: informRepairs?[index]
                                            .informrepair_id)),
                              );
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
