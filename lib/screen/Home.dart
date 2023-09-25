import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  late String storedUsername;
  bool isUsernameLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!isUsernameLoaded) {
      loadUsername(); // เรียกเมธอด loadUsername ที่จะโหลดข้อมูล username จาก SharedPreferences ใน initState
    } // เรียกเมธอด loadUsername ที่จะโหลดข้อมูล username จาก SharedPreferences ใน initState
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
        drawer: Drawer(
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: ListView(
              children: [
                DrawerHeader(
                  child: Icon(
                    Icons.supervised_user_circle,
                    size: 150,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'User',
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
          title: Text('หัสยา ขาวใหม่'),
          leading: IconButton(
            icon: Image.asset(
              'images/MJU_LOGO.png',
              width: 300,
              height: 300,
            ),
            // เพิ่มขนาดของรูปภาพด้วย iconSize
            onPressed: () {
              // กระบวนการที่ต้องการเมื่อคลิกรูปภาพ
            },
          ),

          flexibleSpace: Image.asset('images/Top2.png', fit: BoxFit.cover),
          toolbarHeight: 135,
          automaticallyImplyLeading: false,
          actions: [
            // Text(
            //     'John Doe', // ใส่ชื่อที่ต้องการใน Text widget
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),

            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
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
                  padding: EdgeInsets.only(left: 255, top: 14, right: 16.0),
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
                Text(
                  "       ออกจากระบบ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ]),
        ),
        body: isUsernameLoaded
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Welcome, ${widget.username}'),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 5, right: 20),
                      child: Stack(
                        children: [
                          Image.asset(
                            'images/inform_Home.png',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 325, // ปรับตำแหน่งแนวนอนตามความเหมาะสม
                            top: 85, // ปรับตำแหน่งแนวตั้งตามความเหมาะสม
                            child: IconButton(
                              icon: Icon(Icons.chevron_right_sharp),
                              color: Color.fromRGBO(255, 255, 255, 1),
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
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 0, right: 20),
                      child: Stack(
                        children: [
                          Image.asset(
                            'images/informroom_Home.png',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 325, // ปรับตำแหน่งแนวนอนตามความเหมาะสม
                            top: 85, // ปรับตำแหน่งแนวตั้งตามความเหมาะสม
                            child: IconButton(
                              icon: Icon(Icons.chevron_right_sharp),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return InformRepairForm();
                                //   }),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 460, right: 20),
                      child: Stack(
                        children: [
                          Image.asset(
                            'images/List_Home.png',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 325, // ปรับตำแหน่งแนวนอนตามความเหมาะสม
                            top: 85, // ปรับตำแหน่งแนวตั้งตามความเหมาะสม
                            child: IconButton(
                              icon: Icon(Icons.chevron_right_sharp),
                              color: Color.fromRGBO(255, 255, 255, 1),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ListInformRepair();
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
