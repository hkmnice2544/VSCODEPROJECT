import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterr/constant/constant_value.dart';
import 'package:flutterr/controller/login_controller.dart';
import 'package:flutterr/controller/review_controller.dart';
import 'package:flutterr/controller/review_pictures_controller.dart';
import 'package:flutterr/model/Review_Model.dart';
import 'package:flutterr/model/Review_pictures_Model.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../controller/report_controller.dart';
import '../../../model/Report_Model.dart';
import '../../Home.dart';
import '../../Login.dart';
import 'ListInformRepair.dart';
import 'Rating.dart';
import 'package:http/http.dart' as http;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class Reviews extends StatefulWidget {
  final int? report_id;
  final int? user;
  const Reviews({super.key, this.report_id, this.user});

  @override
  State<Reviews> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Reviews> {
  TextEditingController textEditingController = TextEditingController();
  List<Uint8List> imageBytesList = [];
  List<String> imageNames = [];
  String reviewer = 'ไม่ประสงคอออกนาม';
  int? _rating;
  String formattedDate = '';
  DateTime informdate = DateTime.now();
  List<Review>? reviews;
  Review? review;
  bool? isDataLoaded = false;
  ReportRepair? reportRepair;
  bool forIos = false;

  final ReviewController reviewController = ReviewController();
  final ReportController reportController = ReportController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageFileNames = [];
  int selectedImageCount = 0;

  List<File> _selectedImages = [];
  User? users;
  late String storeduser;
  bool isOn = false;
  int value = 0;
  bool positive = true;

  Review_PicturesController review_picturesController =
      Review_PicturesController();
  LoginController loginController = LoginController();

  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      selectedImageCount += selectedImages.length;
      imageFileList.addAll(selectedImages);
      // เพิ่มรูปภาพที่เลือกเข้า _selectedImages
      _selectedImages.addAll(selectedImages.map((image) => File(image.path)));
    }
    setState(() {});
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isNotEmpty) {
      final uri = Uri.parse(baseURL + '/review_pictures/uploadMultiple');
      final request = http.MultipartRequest('POST', uri);

      for (final image in _selectedImages) {
        final file = await http.MultipartFile.fromPath(
          'files',
          image.path,
          filename: image.path.split('/').last,
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        print('รูปภาพถูกอัพโหลดและข้อมูลถูกบันทึกเรียบร้อย');
        // เพิ่มโค้ดหลังการอัพโหลดสำเร็จ
      } else {
        print('เกิดข้อผิดพลาดในการอัพโหลดและบันทึกไฟล์');
        // เพิ่มโค้ดหลังการอัพโหลดไม่สำเร็จ
      }
    }
  }

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
    fetchReview_id();
    if (widget.report_id != null) {
      getInform(widget.report_id!);
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);

    print("user-------------${widget.user}");
    getLoginById(widget.user!);
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
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
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
                      return Home(user: widget.user);
                    },
                  ));
                },
              ),
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
              child: Text(
                "ออกจากระบบ",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
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
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 7, 94, 53),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${reportRepair?.informRepairDetails?.informRepair?.informrepair_id}",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "$formattedDate",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                        "รูปภาพ   :",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                          color: Color.fromARGB(255, 243, 103, 33),
                          child: Text(
                            "อัปโหลดรูปภาพ",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selectImages();
                            _uploadImages();
                            print('imageFileNames----${imageFileNames}');
                            print('imageFileNames----${imageFileNames}');
                          }),
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 คอลัมน์
                  ),
                  itemCount: imageFileList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String fileName = imageFileList[index].path.split('/').last;
                    imageFileNames.add(fileName); // เพิ่มชื่อไฟล์ลงใน List
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Stack(
                        children: [
                          Image.file(File(imageFileList[index].path)),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 79,
                            child: Container(
                              color: Colors.black.withOpacity(0.7),
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                fileName, // ใช้ชื่อไฟล์แทน
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 30,
                            child: IconButton(
                              icon: Icon(
                                Icons.highlight_remove_sharp,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // ลบรูปออกจาก imageFileList
                                setState(() {
                                  imageFileList.removeAt(index);
                                });
                                // ลบชื่อรูปภาพที่เกี่ยวข้องออกจาก imageFileNames
                                String fileNameToRemove = imageFileNames[index];
                                imageFileNames.removeWhere(
                                    (fileName) => fileName == fileNameToRemove);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "ผู้รีวิว  :",
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 7, 94, 53),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: positive,
                        first: false,
                        second: true,
                        borderWidth: 5.0,
                        height: 55,
                        onChanged: (b) {
                          if (b != null) {
                            setState(() {
                              positive = b;
                              if (b) {
                                reviewer = 'ไม่ประสงค์ออกนาม';
                              } else {
                                if (users != null && users!.firstname != null) {
                                  reviewer = users!.firstname! +
                                      " " +
                                      users!.lastname!;
                                } else {
                                  reviewer = '';
                                }
                              }
                              print(reviewer);
                            });
                          }
                        },
                        iconBuilder: (value) => value
                            ? Icon(
                                Icons.no_accounts_sharp,
                                color: Color.fromARGB(255, 255, 0,
                                    0), // สีของ Icon เมื่อเป็น "on"
                                size: 32, // ขนาดของ Icon เมื่อเป็น "on"
                              )
                            : Icon(
                                Icons.supervised_user_circle_rounded,
                                color: Color.fromARGB(255, 7, 94,
                                    53), // สีของ Icon เมื่อเป็น "off"
                                size: 32, // ขนาดของ Icon เมื่อเป็น "off"
                              ),
                        textBuilder: (value) => Center(
                          child: Text(
                            value ? reviewer : reviewer,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: value
                                    ? Color.fromARGB(255, 0, 0, 0)
                                    : Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // CupertinoSwitch(
                      //   activeColor: Color.fromARGB(255, 251, 217, 149),
                      //   thumbColor: Color.fromARGB(255, 219, 85, 12),
                      //   trackColor: Colors.black12,
                      //   value: forIos,
                      //   onChanged: (bool? value) {
                      //     if (value != null) {
                      //       setState(() {
                      //         forIos = value;
                      //         if (value) {
                      //           reviewer = 'ไม่ประสงคอออกนาม';
                      //         } else {
                      //           if (users != null && users!.firstname != null) {
                      //             reviewer =
                      //                 users!.firstname! + " " + users!.lastname!;
                      //           } else {
                      //             reviewer = '';
                      //           }
                      //         }
                      //         print(reviewer);
                      //       });
                      //     }
                      //   },
                      // ),
                      // SizedBox(height: 20),
                      // Text(
                      //   '$reviewer', // แสดงค่า reviewer ด้วย Text
                      //   style: TextStyle(fontSize: 15),
                      // ),
                      // Expanded(
                      //   child: Row(
                      //     children: [
                      //       Checkbox(
                      //         value: reviewer == 'ไม่ประสงคอออกนาม',
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             if (value != null && value) {
                      //               reviewer = 'ไม่ประสงคอออกนาม';
                      //             } else {
                      //               if (users != null &&
                      //                   users!.firstname != null) {
                      //                 reviewer = users!.firstname! +
                      //                     " " +
                      //                     users!.lastname!;
                      //               } else {
                      //                 reviewer =
                      //                     ''; // Set to an empty string if the user's first name is not available
                      //               }
                      //             }
                      //             print(reviewer);
                      //           });
                      //         },
                      //         shape: CircleBorder(),
                      //       ),
                      //       Text(reviewer),
                      //     ],
                      //   ),
                      // )

                      // Expanded(
                      //   child: Row(
                      //     children: [
                      //       Checkbox(
                      //         value: reviewer == 'ไม่ประสงคอออกนาม',
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             if (value != null && value) {
                      //               reviewer = 'ไม่ประสงคอออกนาม';
                      //             } else {
                      //               if (users != null &&
                      //                   users!.firstname != null) {
                      //                 reviewer = users!.firstname! +
                      //                     " " +
                      //                     users!.lastname!;
                      //               } else {
                      //                 reviewer =
                      //                     ''; // Set to an empty string if the user's first name is not available
                      //               }
                      //             }
                      //             print(reviewer);
                      //           });
                      //         },
                      //         shape: CircleBorder(),
                      //       ),
                      //       Text(reviewer),
                      //     ],
                      //   ),
                      // )
                    )
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
              label: Text(
                "ยืนยัน",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                await _uploadImages();
                var response = await reviewController.addReview(
                    reviewer,
                    _rating != null
                        ? _rating.toString()
                        : "", // แปลง _rating เป็น String
                    textEditingController.text,
                    reportRepair?.report_id as int);

                final List<Map<String, dynamic>> data = [];

                for (final imageName in imageFileNames) {
                  if (!data.any((item) => item["pictureUrl"] == imageName)) {
                    data.add({
                      "pictureUrl": imageName,
                      "review": {
                        "review_id": ((reviews?.isEmpty ?? true)
                            ? 10001
                            : ((reviews?[reviews!.length - 1]?.review_id ?? 0) +
                                1)),
                      },
                    });
                  }
                }

                final List<Review_pictures> savedInformPictures =
                    await Review_PicturesController.saveReview_pictures(data);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ListInformRepair(user: widget.user);
                  }),
                );
              },
            ),
          ),
          SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
          Container(
            width: 120, // Set the width of the button here
            child: FloatingActionButton.extended(
              label: Text(
                "ยกเลิก",
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
