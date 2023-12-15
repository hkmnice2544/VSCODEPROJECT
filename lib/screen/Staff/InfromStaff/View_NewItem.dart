import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/screen/HomeStaff.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'ListInformRepair.dart';
import 'package:google_fonts/google_fonts.dart';

class View_NewItem extends StatefulWidget {
  final int? informrepair_id;
  final int? user;

  const View_NewItem({super.key, this.informrepair_id, this.user});

  @override
  State<View_NewItem> createState() => _ViewResultState();
}

class _ViewResultState extends State<View_NewItem> {
  final InformRepairController informController = InformRepairController();
  InformRepair? informRepair;
  List<InformRepair>? informrepairs;

  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  void getInform(int informrepair_id) async {
    informRepair = await informController.getInform(informrepair_id);
    print("rooms : ${informRepair?.equipment!.room}");
    print("getInform : ${informRepair?.informrepair_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  List<String>? pictures = [];

  List<String> equipmentIds = [];
  String? selectedRoomId;
  String? roomIds;
  List<String>? Room_id = [];
  List<String> equipmentName = [];

  void findequipmentByIdByAll(String selectedRoom) async {
    equipmentIds =
        await informController.findequipment_idByIdByroom_id(selectedRoom);

    for (int i = 0; i < equipmentIds.length; i++) {
      int? equipmentId = int.tryParse(equipmentIds[i]);
      if (equipmentId != null) {
        String name = await informController
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

  @override
  void initState() {
    super.initState();

    if (widget.informrepair_id != null) {
      getInform(widget.informrepair_id!);
    }

    print(" pictures : ${informRepair?.pictures}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "หน้า รายละเอียดการแจ้งซ่อม",
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
            ),
          ),
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
                          return HomeStaff(user: widget.user);
                        },
                      ));
                    }),
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
                    }),
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
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 94, 53),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 390,
                      height: 250,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 390,
                              height: 250,
                              decoration: ShapeDecoration(
                                color: Color.fromARGB(32, 41, 111, 29),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 11,
                            child: SizedBox(
                              width: 450,
                              height: 27,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.list, // เปลี่ยนไอคอนตรงนี้
                                        color: Color.fromARGB(
                                            255, 7, 94, 53), // สีไอคอน
                                        // ขนาดไอคอน
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'เลขที่แจ้งซ่อม :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair?.informrepair_id ?? 'N/A' : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 50,
                            child: SizedBox(
                              width: 450,
                              height: 27,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.date_range,
                                        color: Color.fromARGB(255, 7, 94, 53),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'วันที่แจ้งซ่อม  :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair!.formattedInformDate() : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 90,
                            child: SizedBox(
                              width: 450,
                              height: 90,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.ballot_outlined,
                                        color: Color.fromARGB(255, 7, 94, 53),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'ประเภทห้องน้ำ  :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair!.equipment!.room!.roomname ?? 'N/A' : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 130,
                            child: SizedBox(
                              width: 450,
                              height: 90,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.business,
                                        color: Color.fromARGB(255, 7, 94, 53),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'อาคาร   :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair?.equipment!.room!.building!.buildingname ?? 'N/A' : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 170,
                            child: SizedBox(
                              width: 450,
                              height: 90,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.bento_outlined,
                                        color: Color.fromARGB(255, 7, 94, 53),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'ชั้น   :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair!.equipment!.room!.floor ?? 'N/A' : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 210,
                            child: SizedBox(
                              width: 450,
                              height: 90,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.place_outlined,
                                        color: Color.fromARGB(255, 7, 94, 53),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text: 'ตำแหน่ง   :',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width:
                                              10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                    ),
                                    TextSpan(
                                      text:
                                          '${informRepair != null ? informRepair!.equipment!.room!.position ?? 'N/A' : 'N/A'}',
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 450,
                      height: 50,
                      child: Stack(children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 450,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(7, 94, 53, 1)),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 11,
                          child: SizedBox(
                            width: 400,
                            height: 27,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.build,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            10), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                  ),
                                  TextSpan(
                                    text: 'อุปกรณ์ชำรุด',
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            15), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap:
                        true, // ตั้งค่า shrinkWrap เป็น true เพื่อให้ ListView ย่อเข้าตัวเมื่อมีเนื้อหาน้อย
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      int displayIndex = index + 1;
                      return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                              title: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "รายการที่ : ${displayIndex}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 7, 94, 53),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "อุปกรณ์ :",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair?.equipment!.equipmentname}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      "รายละเอียด :",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${informRepair?.details}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Center(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          10), // 100 is half of 200 (width/2)
                                      child: Image.network(
                                        baseURL +
                                            '/informrepairs/image/${informRepair?.pictures}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ])));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120, // Set the width of the button here
                          child: FloatingActionButton.extended(
                            label: Text(
                              "ย้อนกลับ",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ListInformRepair(user: widget.user)),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  )
                ]),
              ),
            ),
    ));
  }
}
