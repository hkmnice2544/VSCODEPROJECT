import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Reviews {
  int? review_id;
  DateTime? reviewdate;
  String? reviewer;
  String? repairscore;
  String? comment;
  int? report_id;

  Reviews({
    required this.review_id,
    this.reviewdate,
    this.reviewer,
    this.repairscore,
    this.comment,
    this.report_id,
  });
  String formattedReviewDate(DateTime? reviewDate) {
    if (reviewDate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat =
          DateFormat('dd-MM-yyyy HH:mm', thailandLocale.toString());

      // แปลง DateTime เป็นสตริงและตัด 'Z' ออก
      final dateString = outputFormat.format(reviewDate).replaceAll('Z', '');

      return dateString;
    } else {
      return 'N/A'; // หรือข้อความที่คุณต้องการให้แสดงถ้าไม่มีวันที่
    }
  }

  factory Reviews.fromJsonToReviews(Map<String, dynamic> json) {
    final reviewdateString = json["reviewdate"] as String?;
    DateTime? reviewdate;

    if (reviewdateString != null) {
      final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      final DateTime dateTime = inputFormat.parse(reviewdateString);

      // ปรับเวลาเป็นโซนเวลาไทย (ICT - Indochina Time)
      final thailandOffset = Duration(hours: 7);
      final thailandDateTime = dateTime.add(thailandOffset);

      reviewdate = thailandDateTime; // กำหนดค่าให้กับ informdate
    }

    final reviewId = json["review_id"] != null
        ? int.tryParse(json["review_id"].toString())
        : null;

    final reportId = json["report_id"] != null
        ? int.tryParse(json["report_id"].toString())
        : null;

    return Reviews(
      review_id: reviewId,
      reviewer: json["reviewer"],
      repairscore: json["repairscore"],
      comment: json["comment"],
      reviewdate: reviewdate,
      report_id: reportId,
    );
  }

  Map<String, dynamic> fromReviewsToJson() {
    return <String, dynamic>{
      'review_id': review_id,
      'reviewer': reviewer,
      'repairscore': repairscore,
      'comment': comment,
      'reviewdate': reviewdate,
      'report_id': report_id,
    };
  }
}
