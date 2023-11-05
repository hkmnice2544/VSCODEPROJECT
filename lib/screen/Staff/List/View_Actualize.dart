import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:intl/intl.dart';
import '../../../controller/informrepair_controller.dart';
import '../../../model/informrepair_model.dart';
import '../../Home.dart';
import '../../Login.dart';
import '../../User/ListInformRepair/ListInformRepair.dart';
import 'ListManage.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewActualize extends StatefulWidget {
  final int? informrepair_id;
  final int? user;
  const ViewActualize({super.key, this.informrepair_id, this.user});

  @override
  State<ViewActualize> createState() => _ViewViewActualizeState();
}

class _ViewViewActualizeState extends State<ViewActualize> {
  final InformRepairController informController = InformRepairController();
  InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  InformRepair? informRepair;
  List<InformRepair>? informrepairs;
  List<InformRepairDetails>? informRepairDetails;

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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.informrepair_id ?? 'N/A' : 'N/A'}',
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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].informRepair?.formattedInformDate() ?? 'N/A' : 'N/A'}',
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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.roomname ?? 'N/A' : 'N/A'}',
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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.building?.buildingname ?? 'N/A' : 'N/A'}',
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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.floor ?? 'N/A' : 'N/A'}',
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
                                          '${informDetails != null && informDetails.isNotEmpty ? informDetails[0].roomEquipment?.room?.position ?? 'N/A' : 'N/A'}',
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
                    itemCount: informDetails.length,
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
                                      "${informDetails?[index].roomEquipment?.equipment?.equipmentname}",
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
                                      "${informDetails?[index].details}",
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                // Wrap(
                                //   spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
                                //   runSpacing:
                                //       8.0, // ระยะห่างระหว่างรูปภาพในแนวดิ่ง
                                //   children: List.generate(
                                //     1,
                                //     (index) {
                                //       final informPicture =
                                //           pictures!.firstWhere(
                                //         (inform) {
                                //           final parts = inform.split(',');
                                //           return parts.length == 2 &&
                                //               parts[0] == "1002";
                                //         },
                                //         orElse: () => "",
                                //       );

                                //       if (informPicture != null) {
                                //         final parts = informPicture.split(',');
                                //         final imageName = parts[1];
                                //         return Container(
                                //           width: 200,
                                //           height: 350,
                                //           child: Image.network(
                                //             baseURL +
                                //                 '/informrepairdetails/image/$imageName',
                                //             fit: BoxFit.cover,
                                //           ),
                                //         );
                                //       } else {
                                //         return Container(); // หากไม่พบข้อมูลรูปภาพสำหรับอุปกรณ์นี้
                                //       }
                                //     },
                                //   ),
                                // )
                              ])));
                    },
                  ),
                ]),
              ),
            ),
      floatingActionButton: Row(
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
                        builder: (_) => ListManage(user: widget.user)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
