import 'dart:typed_data';
import 'package:flutterr/screen/HomeStaff.dart';
import 'package:flutterr/screen/Staff/Summary/View_Sum.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/Building_Model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Login.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  void _updateFilteredInformRepairs() {
    setState(() {
      filteredInformRepairs = informRepairs!.where((informRepair) {
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

        bool statusCondition =
            _selectedStatus == null || _selectedStatus == informRepair.status;

        return dateCondition && statusCondition;
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
      setState(() {
        _endDate = pickedEndDate;
      });
      _updateFilteredInformRepairs();
    }
  }

  // void listAllInformRepairDetails() async {
  //   // เรียกใช้งาน listAllInformRepairDetails และรอข้อมูลเสร็จสมบูรณ์
  //   informRepairDetails =
  //       (await informRepairDetailsController.listAllInformRepairDetails())
  //           .cast<InformRepairDetails>();

  //   // หลังจากที่ข้อมูลถูกโหลดเสร็จแล้ว คุณสามารถทำตามที่คุณต้องการกับข้อมูลได้
  //   informRepairs?.sort((a, b) {
  //     if (a.informdate == null && b.informdate == null) {
  //       return 0;
  //     } else if (a.informdate == null) {
  //       return 1;
  //     } else if (b.informdate == null) {
  //       return -1;
  //     }
  //     return b.informdate!.compareTo(a.informdate!);
  //   });

  //   // อัปเดตสถานะแสดงว่าข้อมูลถูกโหลดแล้ว
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

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
    _startDate = date;
    _endDate = date;
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
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
            ),
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
                      return HomeStaff(user: widget.user);
                    },
                  ));
                },
              ),
            ),
            Expanded(
              child: Text(
                "หน้าแรก",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : //คือตัวหมนุๆ
          Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "สรุปรายงานการแจ้งซ่อมห้องน้ำ",
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 94, 53),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/Sammary.png',
                    fit: BoxFit.cover,
                    width: 220,
                    alignment: Alignment.center,
                  ),
                  // Text(
                  //   _selectedYear != null
                  //       ? "รายงานประจำปี $_selectedYear"
                  //       : "รายงานประจำปี",
                  //   style: GoogleFonts.prompt(
                  //     textStyle: TextStyle(
                  //       color: Color.fromARGB(255, 7, 94, 53),
                  //       fontSize: 22,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 432,
                      height: 230,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 419,
                              height: 230,
                              decoration: ShapeDecoration(
                                color: Color.fromARGB(32, 41, 111, 29),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 210,
                            top: 23,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, 0.0)
                                ..rotateZ(1.57),
                              child: Container(
                                width: 100,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(7, 94, 53, 1),
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 64,
                            top: 30,
                            child: SizedBox(
                              width: 200,
                              height: 22,
                              child: Text(
                                'วันที่เริ่มต้น',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(7, 94, 53, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 64,
                            top: 80,
                            child: SizedBox(
                              width: 93,
                              height: 52,
                              child: Text(
                                'วันที่สิ้นสุด',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(7, 94, 53, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 64,
                            top: 150,
                            child: SizedBox(
                              width: 93,
                              height: 52,
                              child: Text(
                                'สถานะ',
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(7, 94, 53, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 250,
                            top: 20,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectStartDate(context);
                                });
                                _updateFilteredInformRepairs();
                              },
                              child: Text(
                                _startDate != null
                                    ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                                    : "เลือกวันที่เริ่มต้น",
                                style: TextStyle(
                                  color: Colors.white, // สีของข้อความ
                                  fontSize: 20,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 7, 94, 53), // สีพื้นหลัง
                              ),
                            ),
                          ),
                          Positioned(
                            left: 250,
                            top: 70,
                            child: SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectEndDate(context);
                                  });
                                  _updateFilteredInformRepairs();
                                },
                                child: Text(
                                  _endDate != null
                                      ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                                      : "เลือกวันที่สิ้นสุด",
                                  style: TextStyle(
                                    color: Colors.white, // สีของข้อความ
                                    fontSize: 20,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(
                                      255, 7, 94, 53), // สีพื้นหลัง
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 180,
                            top: 140,
                            child: DropdownButtonHideUnderline(
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
                                        'เลือกสถานะ',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                value: _selectedStatus,
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text(
                                      'เลือกสถานะ',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    value: '', // หรือค่าว่าง
                                  ),
                                  ..._statusList
                                      .map((e) => DropdownMenuItem(
                                            child: Text(
                                              e,
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            value: e,
                                          ))
                                      .toList(),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedStatus = val as String?;
                                  });
                                  _updateFilteredInformRepairs(); // เรียกให้คลิกสถานะแล้วกรองข้อมูล
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 60,
                                  width: 200,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            66, 255, 255, 255),
                                      ),
                                      color: Color.fromRGBO(7, 94, 53, 1)),
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
                                  width: 450,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color.fromRGBO(62, 119, 94, 1),
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: isDataLoaded == false
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            itemCount: _startDate != null
                                ? filteredInformRepairs.length
                                : (informRepairs?.length ?? 0),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final informRepair = _startDate != null
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
                                      Icon(Icons.account_circle,
                                          color:
                                              Color.fromARGB(255, 7, 94, 53)),
                                    ],
                                  ),
                                  title: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "เลขที่แจ้งซ่อม",
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 7, 94, 53),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${informRepair.informrepair_id}",
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
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
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 7, 94, 53),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              informRepair.informdate != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(informRepair
                                                          .informdate!)
                                                  : "N/A",
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
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
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 7, 94, 53),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              informRepair.status as String,
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                          child: Text("ประเภทการแจ้งซ่อม ",
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 20,
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child:
                                              Text("${informRepair.informtype}",
                                                  style: GoogleFonts.prompt(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 20,
                                                    ),
                                                  )),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  onTap: () {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => View_Sum(
                                                informrepair_id:
                                                    informRepairs?[index]
                                                        .informrepair_id,
                                                user: widget.user)),
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
            ),
    );
  }
}
