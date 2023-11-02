import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/inform_pictures_model.dart';
import 'package:flutterr/screen/User/InformRepairToilet/EditInformRepair.dart';
import 'package:flutterr/screen/User/ListInformRepair/ListInformRepair.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'package:google_fonts/google_fonts.dart';

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
    print("user-----------Re----------------${widget.user}");
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
                                var username;
                                return Home(user: widget.user);
                              },
                            ));
                          }),
                    ),
                    Expanded(
                      child: Text(
                        "หน้าแรก",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
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
                            color: Color.fromARGB(255, 255, 255, 255),
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
                : SingleChildScrollView(
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
                        Image.asset(
                          'images/View_Inform.png',
                          // fit: BoxFit.cover,
                          width: 220,
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            width: 390,
                            height: 220,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 390,
                                    height: 220,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Color(0xFFF0573D)),
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
                                  left: 50,
                                  top: 11,
                                  child: SizedBox(
                                    width: 450,
                                    height: 27,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(Icons.list,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                                '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.informrepair_id ?? 'N/A' : 'N/A'}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                            child: Icon(Icons.date_range,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                                '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.formattedInformDate() ?? 'N/A' : 'N/A'}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                            child: Icon(Icons.ballot_outlined,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                                '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.roomname ?? 'N/A' : 'N/A'}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                            child: Icon(Icons.business,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width:
                                                    25), // ระยะห่าง 10 พิกเซลระหว่าง TextSpan
                                          ),
                                          TextSpan(
                                            text: 'ชั้น   ',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                                '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.floor ?? 'N/A' : 'N/A'}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                            child: Icon(Icons.place_outlined,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                                '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.position ?? 'N/A' : 'N/A'}',
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                        Row(
                          children: [
                            Text(
                              "อุปกรณ์ชำรุด",
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "-----------------------------------------------------------------------",
                        //       style: GoogleFonts.prompt(
                        //         textStyle: TextStyle(
                        //           color: Color.fromARGB(255, 0, 0, 0),
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${informDetails?[index].roomEquipment?.equipment?.equipmentname}",
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 22,
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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${informDetails?[index].details}",
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 22,
                                              ),
                                            ),
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
                                                    return ListInformRepair(
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
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    // EditInformRepairs editInformRepair =
                                    //     EditInformRepairs();
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
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
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
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ))));
  }
}
