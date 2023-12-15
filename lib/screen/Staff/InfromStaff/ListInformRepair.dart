import 'package:flutter/material.dart';
import 'package:flutterr/screen/Staff/InfromStaff/List_%20Check%20status.dart';
import '../../../Model/informrepair_model.dart';
import '../../Login.dart';
import 'List_InformCompleted.dart';
import 'List_NewItem.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../HomeStaff.dart';

class ListInformRepair extends StatefulWidget {
  final int? user;
  const ListInformRepair({super.key, this.user});

  @override
  State<ListInformRepair> createState() => _ListInformRepairState();
}

class _ListInformRepairState extends State<ListInformRepair> {
  List<InformRepair>? informrepairs;

  bool? isDataLoaded = false;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("ListInformRepair",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                )),
            backgroundColor: Colors.red,
            bottom: TabBar(
              unselectedLabelColor: Colors.blue, // สีของแถบที่ไม่ได้เลือก
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
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  child: Text(
                    'ตรวจสอบสถานะ',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  child: Text(
                    'รีวิว',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
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
                                    HomeStaff(user: widget.user), // หน้า A
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
                    child: Text("ออกจากระบบ",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  )
                ]),
          ),
          body: TabBarView(children: [
            listNewItem(
              user: widget.user,
            ),
            listCheckStatus(user: widget.user),
            InformCompleted(user: widget.user),
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
