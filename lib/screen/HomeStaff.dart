import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'Staff/List/ListManage.dart';
import 'Staff/Summary/Sammary.dart';
import 'User/ListInformRepair/ListInformRepair.dart';

class HomeStaff extends StatefulWidget {
  final String username; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  HomeStaff({required this.username});
  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class _HomeStaffState extends State<HomeStaff> {
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
                  'Staff',
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
                            'มัลลิกา',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Expanded(
                        child: Text(
                      'แซ่ลิ้ม',
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
                      'ผู้รับผิดชอบ ',
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      'staff01',
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.password,
                      color: Colors.red,
                    ),
                    title: Text(
                      '*******',
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'มัลลิกา แซ่ลิ้ม',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'ตำแหน่ง : ผู้รับผิดชอบแผนกห้องน้ำ',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          leading: IconButton(
            icon: Image.asset(
              'images/MJU_LOGO.png',
              width: 300,
              height: 300,
            ),
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
            ? SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome, ${widget.username}'),
                      const Padding(
                        padding: EdgeInsets.only(left: 45, top: 10, right: 0),
                        child: Text(
                          "กรุณาเลือกรายการ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Stack(
                            children: [
                              Image.asset(
                                'images/inform_Home.png',
                                width: 500, // กำหนดความกว้าง
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
                                      left: 435, top: 105, right: 20),
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
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 0, top: 0, right: 0),
                          child: Stack(
                            children: [
                              Image.asset(
                                'images/informroom_Home.png',
                                width: 500, // กำหนดความกว้าง
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
                                      left: 435, top: 105, right: 20),
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) {
                                    //     return InformClassrooms();
                                    //   }),
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
                          padding: EdgeInsets.only(left: 0, top: 0, right: 0),
                          child: Stack(
                            children: [
                              Image.asset(
                                'images/List_Home.png',
                                width: 500, // กำหนดความกว้าง
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
                                      left: 435, top: 110, right: 20),
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
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 0, top: 0, right: 0, bottom: 0),
                          child: Stack(
                            children: [
                              Image.asset(
                                'images/List_Manage.png',
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
                                      left: 465, top: 105, right: 20),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ListManage();
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
                                'images/List_Summary.png',
                                width: 550, // กำหนดความกว้าง
                                height: 250, // กำหนดความสูง
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
                                      left: 490, top: 100, right: 20),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return Summary();
                                      }),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class DataModel {
  final String data;

  DataModel(this.data);
}

class DestinationPage extends StatelessWidget {
  final String data;

  DestinationPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Page'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
