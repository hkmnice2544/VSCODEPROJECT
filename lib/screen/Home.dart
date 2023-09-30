import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/InformRepairForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User/ListInformRepair/ListInformRepair.dart';

class Home extends StatefulWidget {
  final String username; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  Home({required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LoginController loginController = LoginController();
  String? user;
  late String storedUsername;
  bool isUsernameLoaded = false;
  bool? isDataLoaded = false;

  void getviewInformDetailsById(String username) async {
    user = await loginController.getviewInformDetailsById(username);
    print("getuser : ${user}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!isUsernameLoaded) {
      loadUsername();
    }
    getviewInformDetailsById(widget.username!);
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedUsername = prefs.getString('username') ?? '';
    isUsernameLoaded = true;
    setState(() {});
  }

  void clearUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username'); // ลบข้อมูล username จาก SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Login();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isUsernameLoaded) {
      // ถ้าข้อมูล username ยังไม่ถูกโหลด ให้แสดง Placeholder หรือ Loading Screen
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
                  '${user}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
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
                            'หัสยา',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Expanded(
                        child: Text(
                      'ขาวใหม่',
                      style: TextStyle(fontSize: 20),
                    )),
                  ],
                ),
                ListTile(
                    leading: Icon(
                      Icons.business,
                      color: Colors.red,
                    ),
                    title: Text(
                      'นักศึกษา',
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      widget.username,
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.password,
                      color: Colors.red,
                    ),
                    title: Text(
                      '************',
                      style: TextStyle(fontSize: 20),
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
                'หัสยา ขาวใหม่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
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

          // leading: Container(
          // // padding: EdgeInsets.only(left: 10, top: 2, right: 120.0),
          // alignment: Alignment.centerLeft,
          // child: Image.asset(
          // 'images/MJU_LOGO.png',
          // fit: BoxFit.cover,
          // ),
          // ),

          // actions: <Widget>[
          //   Text("หัสยา ขาวใหม่",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),)),
          //    Icon(
          //     Icons.supervised_user_circle,
          //     ),

          //    IconButton(
          //     onPressed: () {
          //     },
          //     icon: const Icon(Icons.menu)),
          // ],

          // automaticallyImplyLeading: false,
          // leading: IconButton(
          //         icon: const Icon(Icons.menu),
          //         color: Color.fromARGB(255, 255, 255, 255),
          //         onPressed: () {}
          //     ),
          //   title: Text("หัสยา ขาวใหม่",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),)),
          //   backgroundColor: Colors.red,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                )
              ]),
        ),
        body: isUsernameLoaded
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('Welcome, ${widget.username}'),
                    const Padding(
                      padding: EdgeInsets.only(left: 45, top: 10, right: 0),
                      child: Text(
                        "กรุณาเลือกรายการ",
                        style: TextStyle(
                          color: Color.fromRGBO(7, 94, 53, 1),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
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
                                padding: EdgeInsets.only(
                                    left: 455, top: 105, right: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return InformRepairForm(
                                          username: widget.username);
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
                        padding: EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
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
                                padding: EdgeInsets.only(
                                    left: 455, top: 105, right: 20),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   // MaterialPageRoute(builder: (context) {
                                  //   //   return InformRepairForm(
                                  //   //       username: widget.username);
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
                        padding: EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
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
                                padding: EdgeInsets.only(
                                    left: 455, top: 105, right: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      var username;
                                      return ListInformRepair();
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
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
