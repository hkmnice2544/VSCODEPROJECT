import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Login.dart';
import 'Staff/List/ListManage.dart';
import 'Staff/Summary/Sammary.dart';
import 'User/ListInformRepair/ListInformRepair.dart';

class HomeStaff extends StatelessWidget {
  const HomeStaff({super.key});

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
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
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
                      color: Color.fromRGBO(255, 255, 255, 1),
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
            Container(
              padding:
                  EdgeInsets.only(left: 25, top: 670, right: 20, bottom: 20),
              child: Stack(
                children: [
                  Image.asset(
                    'images/List_Manage.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right_sharp),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      padding: EdgeInsets.only(left: 327, top: 75, right: 20),
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
            Container(
              padding:
                  EdgeInsets.only(left: 25, top: 870, right: 20, bottom: 20),
              child: Stack(
                children: [
                  Image.asset(
                    'images/List_Summary.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right_sharp),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      padding: EdgeInsets.only(left: 327, top: 65, right: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Sammary();
                          }),
                        );
                      },
                    ),
                  ),
                ],
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
