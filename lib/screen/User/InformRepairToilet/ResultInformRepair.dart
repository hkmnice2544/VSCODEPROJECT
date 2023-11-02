import 'package:flutter/material.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/informrepair_pictures_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/InformRepairDetails_Model.dart';
import 'package:flutterr/model/User_Model.dart';
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
  LoginController loginController = LoginController();

  InformRepair? informRepair;
  List<InformRepair>? informrepairs;
  List<InformRepairDetails>? informRepairDetails;
  List<Inform_Pictures>? informpictures;

  bool? isDataLoaded = false;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  User? users;

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

  void getLoginById(int user) async {
    users = await loginController.getLoginById(user);
    print("getuser : ${user}");
    print("getuserfirstname : ${users?.firstname}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getLoginById(widget.user!);

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
    // หลังจากโหลดข้อมูล username เสร็จแล้วให้แสดงหน้า Home ตามปกติ
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'images/User.png',
                  width: 80,
                  height: 80,
                ),
              ),
              Text(
                'User',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                        leading: Icon(
                          Icons.face_2,
                          color: Colors.red,
                        ),
                        title: Text(
                          '${users?.firstname}',
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                      child: Text(
                    '${users?.lastname}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
                ],
              ),
              ListTile(
                  leading: Icon(
                    Icons.business,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.usertype}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
              ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.username}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
              ListTile(
                  leading: Icon(
                    Icons.password,
                    color: Colors.red,
                  ),
                  title: Text(
                    '${users?.password}',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(''), // ลบ title ทิ้ง
        leading: Padding(
          padding: EdgeInsets.only(left: 30, top: 0, right: 0),
          child: IconButton(
            icon: Transform.scale(
              scale: 7.0,
              child: Image.asset(
                'images/MJU_LOGO.png',
                width: 50,
                height: 50,
              ),
            ),
            onPressed: () {
              // กระบวนการที่ต้องการเมื่อคลิกรูปภาพ
            },
          ),
        ),
        iconTheme: IconThemeData(
          size: 35,
        ),
        flexibleSpace: Image.asset('images/Top2.png', fit: BoxFit.cover),
        toolbarHeight: 135,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 0, top: 55, right: 15),
            child: Text(
              // "หัสยา ขาวใหม่",
              '${users?.firstname} ${users?.lastname}',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0, right: 10),
            child: Image.asset(
              'images/profile-user.png',
              width: 30,
              height: 30,
            ),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // เปิด Drawer ด้านซ้าย
              },
              icon: const Icon(Icons.menu),
              color: Color.fromARGB(255, 0, 0, 0),
            );
          }),
        ],
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(user: widget.user), // หน้า A
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
              Expanded(child: Text("         ")),
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
          : SingleChildScrollView(
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
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                    child: Icon(Icons.date_range,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                    child: Icon(Icons.ballot_outlined,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                    child: Icon(Icons.business,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                          top: 170,
                          child: SizedBox(
                            width: 450,
                            height: 90,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.place_outlined,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    "อุปกรณ์ :",
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
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
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Wrap(
                                spacing: 8.0, // ระยะห่างระหว่างรูปภาพในแนวนอน
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
              ]),
            )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120, // Set the width of the button here
              child: FloatingActionButton.extended(
                label: Text(
                  "ยืนยัน",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                ),
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
              ),
            ),
          ),
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text(
                "แก้ไข",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 14,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditInformRepairs(
                          informrepair_id: (informRepair?.informrepair_id),
                          user: widget.user)),
                );

                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EditInformRepairs(informrerair_id: informrepairs?[index].informrepair_id)));

                // Navigator.pushNamed(context, '/one');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 120, // Set the width of the button here
              child: FloatingActionButton.extended(
                label: Text(
                  "ยกเลิก",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                ),
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
                              var informRepairId =
                                  informRepair?.informrepair_id ??
                                      0; // 0 เป็นค่าเริ่มต้นที่ไม่เป็น null
                              var response = await informController
                                  .deleteInformRepair(informRepairId);
                              if (response == "Deleted successfully") {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home(user: widget.user);
                                }));
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
