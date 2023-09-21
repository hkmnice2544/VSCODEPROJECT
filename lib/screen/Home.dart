import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterr/screen/Login.dart';
import 'package:flutterr/screen/User/InformRepairToilet/InformRepairForm.dart';

import 'User/ListInformRepair/ListInformRepair.dart';

class Home extends StatelessWidget {
  final String username; // สร้างตัวแปรเพื่อเก็บชื่อผู้ใช้

  Home({required this.username}); // รับค่า username ผ่าน constructor
  @override
  Widget build(BuildContext context) {
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
                    username,
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
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
            Container(
              padding: EdgeInsets.only(left: 20, top: 80, right: 20),
              child: Stack(
                children: [
                  Image.asset(
                    'images/inform_Home.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right_sharp),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      padding: EdgeInsets.only(left: 325, top: 85, right: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return InformRepairForm();
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 270, right: 20),
              child: Stack(
                children: [
                  Image.asset(
                    'images/informroom_Home.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right_sharp),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      padding: EdgeInsets.only(left: 330, top: 85, right: 20),
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
            Container(
              padding: EdgeInsets.only(left: 20, top: 460, right: 20),
              child: Stack(
                children: [
                  Image.asset(
                    'images/List_Home.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right_sharp),
                      color: Color.fromRGBO(0, 0, 0, 1),
                      padding: EdgeInsets.only(left: 330, top: 85, right: 20),
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
          ],
        ),
      ),
    );
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
