import 'dart:typed_data';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Model/Building_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:table_calendar/table_calendar.dart';

class Sammary extends StatefulWidget {
  const Sammary({super.key});

  @override
  Form createState() => Form();
}

class Form extends State<Sammary> {
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
  final _yearList = ["2023", "2022", "2021"];
  final _thisMonList = [
    "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"
  ];
  final _toMonList = [
    "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"
  ];
  String formattedDate = '';
  DateTime informdate = DateTime.now();
  final InformRepairController informRepairController = InformRepairController();
  TextEditingController defectiveEquipmentTextController = TextEditingController();
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

  Future<void> _selectStartDate(BuildContext context) async {
    final pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedStartDate != null) {
      setState(() {
        _startDate = pickedStartDate;
      });
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
      setState(() {
        _endDate = pickedEndDate;
      });
    }
  }

  void fetchInformRepairs() async {
    informRepairs = await informRepairController.listAllInformRepairs();
    print("getInform ปัจจุบัน : ${informRepairs?[informRepairs!.length - 1].informrepair_id}");
    print("getInform +1 : ${(informRepairs?[informRepairs!.length - 1]?.informrepair_id ?? 0) + 1}");
    print("getDate 1 : ${informRepairs?[0].informdate}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void main() {
    initializeDateFormatting('th_TH', null).then((_) {});
  }

  void getInformId(int informRepairId) async {
    informRepair = await informRepairController.getInform(informRepairId);
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
    print("getDate : ${informRepairs?[0].informdate}");
    DateTime date = DateTime.now(); // รูปแบบข้อความจากฐานข้อมูล
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
                      return Home();
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
                  onPressed: () => _selectStartDate(context),
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
                  onPressed: () => _selectEndDate(context),
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
                    itemCount: filteredInformRepairs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final informRepair = filteredInformRepairs[index];
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
                                          ? DateFormat('dd/MM/yyyy').format(
                                              informRepair.informdate!)
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
                                      informRepair.status,
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
                            WidgetsBinding.instance!
                                .addPostFrameCallback((_) {
                              // Navigate to the detail page or perform other actions.
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