import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../../../controller/report_controller.dart';
import '../../../controller/review_controller.dart';
import '../../../model/Report_Model.dart';
import '../../../model/Review_Model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'ListInformRepair.dart';
import 'Rating.dart';

class Review extends StatefulWidget {
  final int? report_id;
  const Review({
    super.key,
    this.report_id,
  });

  @override
  State<Review> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Review> {
  TextEditingController textEditingController = TextEditingController();
  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];
  String reviewer = '';
  int? _rating;
  String formattedDate = '';
  DateTime informdate = DateTime.now();
  List<Reviews>? reviews;
  Reviews? review;
  bool? isDataLoaded = false;
  ReportRepair? reportRepair;

  final ReviewController reviewController = ReviewController();
  final ReportController reportController = ReportController();

  void fetchReview_id() async {
    reviews = await reviewController.listAllReviews();
    print({reviews?[0].review_id});
    print("getreview ปัจจุบัน : ${reviews?[reviews!.length - 1].review_id}");
    print(
        "getreview +1 : ${(reviews?[reviews!.length - 1]?.review_id ?? 0) + 1}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void getInform(int report_id) async {
    reportRepair = await reportController.getReportRepair(report_id);
    print("getInform : ${reportRepair?.report_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReview_id();
    if (widget.report_id != null) {
      getInform(widget.report_id!);
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  // void _pickImage() {
  //   final input = FileUploadInputElement();
  //   input.accept = 'image/*';
  //   input.multiple = true; // อนุญาตให้เลือกไฟล์หลายไฟล์พร้อมกัน
  //   input.click();

  //   input.onChange.listen((event) {
  //     final files = input.files;
  //     if (files != null && files.isNotEmpty) {
  //       int remainingSlots = 5 - imageBytesList.length;
  //       if (remainingSlots > 0) {
  //         final selectedFiles =
  //             files.sublist(0, min(files.length, remainingSlots));

  //         for (final file in selectedFiles) {
  //           final reader = FileReader();

  //           reader.onLoadEnd.listen((e) {
  //             final bytes = reader.result as Uint8List;
  //             setState(() {
  //               imageBytesList.add(bytes);
  //               imageNames.add(file.name);
  //             });
  //           });

  //           reader.readAsArrayBuffer(file);
  //         }
  //       } else {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text('เกิดข้อผิดพลาด'),
  //             content: Text('คุณสามารถเลือกรูปภาพได้ไม่เกิน 5 รูปเท่านั้น'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('ตกลง'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 245, 59, 59),
        height: 50,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // จัดให้ปุ่มตรงกลาง
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                color: Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Home(username: 'ชื่อผู้ใช้');
                    },
                  ));
                },
              ),
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
                },
              ),
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
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "ประเมินผลการแจ้งซ่อม",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 94, 53),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'images/Review.png',
                  // fit: BoxFit.cover,
                  width: 220,
                  alignment: Alignment.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "เลขที่แจ้งซ่อม  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${reportRepair?.informRepair?.informrepair_id}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "วันที่แจ้งซ่อม  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "$formattedDate",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "คะแนนรีวิว  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Rating((rating) {
                  setState(() {
                    _rating = rating;
                  });
                }),
                SizedBox(
                    height: 44,
                    child: _rating != null && _rating! > 0
                        ? Text("You selected $_rating rating",
                            style: TextStyle(fontSize: 18))
                        : SizedBox.shrink()),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "ความคิดเห็น  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          labelText: 'ความคิดเห็น',
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "รูปภาพ  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: _pickImage,
                //   child: Text('เลือกรูปภาพ'),
                // ),
                SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(imageBytesList.length, (index) {
                      final bytes = imageBytesList[index];
                      final imageName = imageNames[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.memory(
                                  bytes,
                                  width: 200,
                                  height: 200,
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imageBytesList.removeAt(index);
                                        imageNames.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.disabled_by_default_rounded,
                                      color: Colors.red,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text('ชื่อภาพ: $imageName'),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "ผู้รีวิว  :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: reviewer == 'ไม่ประสงค์ออกนาม',
                            onChanged: (bool? value) {
                              setState(() {
                                reviewer = value != null && value
                                    ? 'ไม่ประสงค์ออกนาม'
                                    : '';
                                print(reviewer);
                              });
                            },
                            shape: CircleBorder(),
                          ),
                          Text('ไม่ประสงค์ออกนาม'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text("ยืนยัน"),
              onPressed: () async {
                var response = await reviewController.addReview(
                    reviewer,
                    _rating != null
                        ? _rating.toString()
                        : "", // แปลง _rating เป็น String
                    textEditingController.text,
                    reportRepair?.report_id as int);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Home(username: 'ชื่อผู้ใช้');
                  }),
                );
              },
            ),
          ),
          SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text("ยกเลิก"),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
