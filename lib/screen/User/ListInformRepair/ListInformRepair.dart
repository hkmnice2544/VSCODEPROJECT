import 'package:flutter/material.dart';
import 'package:flutterr/screen/User/ListInformRepair/List_%20Check%20status.dart';

import '../../../Model/informrepair_model.dart';
import '../../../controller/informrepair_controller.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'List_InformCompleted.dart';
import 'List_NewItem.dart';

class ListInformRepair extends StatelessWidget {
  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "ListInformRepair",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            backgroundColor: Colors.red,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.fiber_new_rounded,
                    color: Colors.white,
                  ),
                  child: Text(
                    'รายการใหม่',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  child: Text(
                    'ตรวจสอบสถานะ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  child: Text(
                    'รีวิว',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Home(username: 'ชื่อผู้ใช้'), // หน้า A
                              ));
                        }),
                  ),
                  Expanded(
                    child: Text(
                      "หน้าแรก",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  )
                ]),
          ),
          body: TabBarView(children: [
            listAllInformRepairs(),
            listCheckStatus(),
            InformCompleted(),
          ]),
        ),
      );

  Widget buildPage(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 28),
        ),
      );
}
