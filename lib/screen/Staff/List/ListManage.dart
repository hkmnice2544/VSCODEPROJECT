// import 'package:flutter/material.dart';
// import 'package:flutterr/screen/HomeStaff.dart';
// import '../../../Model/informrepair_model.dart';
// import '../../Home.dart';
// import '../../Login.dart';
// import 'List_Actualize.dart';
// import 'List_Completed.dart';
// import 'List_NewInform.dart';
// import 'List_ReviewResults.dart';

// class ListManage extends StatefulWidget {
//   final int? user;
//   const ListManage({
//     super.key,
//     this.user,
//   });
//   @override
//   State<ListManage> createState() => _ListManageState();
// }

// class _ListManageState extends State<ListManage> {
//   List<InformRepair>? informrepairs;

//   bool? isDataLoaded = false;

//   @override
//   Widget build(BuildContext context) => DefaultTabController(
//         length: 4,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(
//               "ListReview",
//               style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//             ),
//             backgroundColor: Colors.red,
//             bottom: TabBar(
//               indicatorColor: Colors.white,
//               indicatorWeight: 5,
//               tabs: [
//                 Tab(
//                   icon: Icon(
//                     Icons.fiber_new_rounded,
//                     color: Colors.white,
//                   ),
//                   child: Text(
//                     'รายการใหม่',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Tab(
//                   icon: Icon(
//                     Icons.run_circle_outlined,
//                     color: Colors.white,
//                   ),
//                   child: Text(
//                     'กำลังดำเนินการ',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Tab(
//                   icon: Icon(
//                     Icons.settings,
//                     color: Colors.white,
//                   ),
//                   child: Text(
//                     'เสร็จสิ้น',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Tab(
//                   icon: Icon(
//                     Icons.star,
//                     color: Colors.white,
//                   ),
//                   child: Text(
//                     'ผลการรีวิว',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: BottomAppBar(
//             color: Color.fromARGB(255, 245, 59, 59),
//             height: 50,
//             shape: CircularNotchedRectangle(), // รูปร่างของแถบ

//             child: Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Expanded(
//                     child: IconButton(
//                         icon: Icon(Icons.home),
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) {
//                               return HomeStaff(user: widget.user);
//                             },
//                           ));
//                         }),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "หน้าแรก",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w100,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Text("                           ")),
//                   Expanded(
//                     child: IconButton(
//                         icon: Icon(Icons.logout),
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) {
//                               return Login();
//                             },
//                           ));
//                         }),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "ออกจากระบบ",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w100,
//                       ),
//                     ),
//                   )
//                 ]),
//           ),
//           body: TabBarView(children: [
//             listNewInform(user: widget.user),
//             ListActualize(user: widget.user),
//             ListCompleted(user: widget.user),
//             listReviewResult(user: widget.user),
//           ]),
//         ),
//       );

//   Widget buildPage(String text) => Center(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 28),
//         ),
//       );
// }
