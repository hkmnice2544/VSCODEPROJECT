import 'package:flutter/material.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/InformRepairForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'User/ListInformRepair/ListInformRepair.dart';

class Home extends StatefulWidget {
  final int? user; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  Home({required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LoginController loginController = LoginController();
  User? users;
  late String storeduser;
  bool? isDataLoaded = false;

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

    print('${widget.user}-------------');
    getLoginById(widget.user!);
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
                      color: Color.fromRGBO(7, 94, 53, 1),
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
                          color: Color.fromARGB(255, 85, 58, 58),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 245, 59, 59),
          height: 50,
          shape: CircularNotchedRectangle(), // รูปร่างของแถบ

          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 420, top: 14, right: 16.0),
                ),
                IconButton(
                    icon: Icon(Icons.logout),
                    color: Color.fromARGB(255, 255, 255, 255),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    }),
                GestureDetector(
                  onTap: () {
                    // นำทางไปยังหน้าอื่นที่คุณต้องการ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Login();
                      }),
                    );
                  },
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Welcome, ${widget.username}'),

              Padding(
                padding: EdgeInsets.only(left: 45, top: 10, right: 0),
                child: Align(
                  child: Text(
                    'กรุณาเลือกรายการ',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromRGBO(7, 94, 53, 1),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/inform_Home.png',
                        width: 520, // กำหนดความกว้าง
                        height: 250, // กำหนดความสูง
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_right_sharp,
                            size: 40,
                            color: Color.fromRGBO(255, 255, 255,
                                1), // ปรับขนาดของไอคอนตามที่คุณต้องการ
                          ),
                          padding:
                              EdgeInsets.only(left: 455, top: 105, right: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return InformRepairForm(user: widget.user);
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/informroom_Home.png',
                        width: 520, // กำหนดความกว้าง
                        height: 250, // กำหนดความสูง
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_right_sharp,
                            size: 40,
                            color: Color.fromRGBO(255, 255, 255,
                                1), // ปรับขนาดของไอคอนตามที่คุณต้องการ
                          ),
                          padding:
                              EdgeInsets.only(left: 455, top: 105, right: 20),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   // MaterialPageRoute(builder: (context) {
                            //   //   return InformRepairForm(
                            //   //       user: widget.user);
                            //   // }),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/List_Home.png',
                        width: 520, // กำหนดความกว้าง
                        height: 250, // กำหนดความสูง
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_right_sharp,
                            size: 40,
                            color: Color.fromRGBO(255, 255, 255,
                                1), // ปรับขนาดของไอคอนตามที่คุณต้องการ
                          ),
                          padding:
                              EdgeInsets.only(left: 455, top: 105, right: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ListInformRepair(
                                  user: widget.user,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
