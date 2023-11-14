import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/informrepair_model.dart';
import '../../../controller/review_controller.dart';
import '../../../model/Review_Model.dart';
import 'View_ResultReview.dart';
import 'package:google_fonts/google_fonts.dart';

class listReviewResult extends StatefulWidget {
  final int? user;
  const listReviewResult({
    super.key,
    required this.user,
  });

  @override
  State<listReviewResult> createState() => _listAllInformRepairsState();
}

class _listAllInformRepairsState extends State<listReviewResult> {
  List<Review>? reviews;
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  String formattedDate = '';
  DateTime informdate = DateTime.now();

  final ReviewController reviewController = ReviewController();

  void fetchReviews() async {
    reviews = await reviewController.listAllReviews();
    print({reviews?[0].review_id});
    // print("ID : ${reviews?[informrepairs!.length - 1].informrepair_id}");
    // print(informRepairs?.defectiveequipment);
    reviews?.sort((a, b) {
      if (a.reviewdate == null && b.reviewdate == null) {
        return 0;
      } else if (a.reviewdate == null) {
        return 1;
      } else if (b.reviewdate == null) {
        return -1;
      }
      return b.reviewdate!.compareTo(a.reviewdate!);
    });
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    reviews?.sort((a, b) {
      if (a.reviewdate == null && b.reviewdate == null) {
        return 0;
      } else if (a.reviewdate == null) {
        return 1;
      } else if (b.reviewdate == null) {
        return -1;
      }
      return b.reviewdate!.compareTo(a.reviewdate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body:
              //  isDataLoaded == false
              //     ? CircularProgressIndicator()
              //     : //ถ้ามีค่าว่างให้ขึ้นตัวหมุนๆ
              Container(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: reviews?.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_border_outlined, color: Colors.red)
                      ],
                    ),
                    title: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text("เลขที่แจ้งซ่อม",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Text("${reviews?[index].review_id}",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Text("วันที่รีวิว",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                "${reviews?[index].formattedreviewdateDate()}",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Text("ความคิดเห็น ",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Text("${reviews?[index].comment}",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Text("ผู้แจ้ง ",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                "${reviews?[index].informRepair!.user!.firstname} ${reviews?[index].informRepair!.user!.lastname} ",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: Text("ประเภทการแจ้งซ่อม ",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                "${reviews?[index].informRepair!.informtype}",
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ]),
                      ],
                    ),
                    // trailing:
                    //     const Icon(Icons.zoom_in, color: Colors.red),
                    onTap: () {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewResultReview(
                                  review_id: reviews?[index].review_id,
                                  user: widget.user)),
                        );
                      });
                    },
                  ),
                );
              },
            ),
          )),
    );
  }
}
