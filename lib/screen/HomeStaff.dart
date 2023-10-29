import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'Staff/List/ListManage.dart';
import 'Staff/Summary/Sammary.dart';
import 'User/ListInformRepair/ListInformRepair.dart';

class HomeStaff extends StatefulWidget {
  final int? user;

  HomeStaff({required this.user});
  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class _HomeStaffState extends State<HomeStaff> {
  late String storedUsername;
  bool isUsernameLoaded = false;
  LoginController loginController = LoginController();
  User? users;
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
    return Scaffold(
        endDrawer: Drawer(
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: ListView(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    'images/Staff.png',
                    width: 30,
                    height: 30,
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
                            '${users?.firstname}',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Expanded(
                        child: Text(
                      '${users?.lastname}',
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
                      '${users?.usertype}',
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      '${users?.username}',
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.password,
                      color: Colors.red,
                    ),
                    title: Text(
                      '${users?.password}',
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
              padding: EdgeInsets.only(left: 0, top: 45, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      // "มัลลิกา แซ่ลิ้ม",
                      '${users?.firstname} ${users?.lastname}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Text(
                      // "ตำแหน่ง : หัวหน้างานแผนกห้องน้ำ",
                      'ตำแหน่ง : ${users?.usertype}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
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
          // Text(
          //     'John Doe', // ใส่ชื่อที่ต้องการใน Text widget
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),

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
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Text('Welcome, ${widget.username}'),
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
                        padding:
                            EdgeInsets.only(left: 435, top: 105, right: 20),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) {
                          //     return InformRepairForm(user: widget.user);
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
                        padding:
                            EdgeInsets.only(left: 435, top: 105, right: 20),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) {
                          //     return InformClassrooms(user: widget.user);
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
                        padding:
                            EdgeInsets.only(left: 435, top: 110, right: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ListInformRepair(user: widget.user);
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
                padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
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
                        padding:
                            EdgeInsets.only(left: 465, top: 105, right: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ListManage(user: widget.user);
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
                padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
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
                        padding:
                            EdgeInsets.only(left: 490, top: 100, right: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Summary(user: widget.user);
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
