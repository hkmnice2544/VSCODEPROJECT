import 'package:flutter/material.dart';
import 'package:flutterr/model/informrepair_model.dart';

import 'package:intl/intl.dart';

class Review {
  int? review_id;
  DateTime? reviewdate;
  String? repairscore;
  String? comment;
  String? pictureUrl;
  InformRepair? informRepair;

  Review({
    required this.review_id,
    this.reviewdate,
    this.repairscore,
    this.comment,
    this.pictureUrl,
    this.informRepair,
  });
  String formattedreviewdateDate() {
    if (reviewdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat = DateFormat('dd-MM-yyyy', thailandLocale.toString());
      return outputFormat.format(reviewdate!);
    } else {
      return 'N/A';
    }
  }

  factory Review.fromJsonToReviews(Map<String, dynamic> json) {
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
    final informrepairJson = json['informRepair'] as Map<String, dynamic>;
    final informRepair = InformRepair.fromJsonToInformRepair(informrepairJson);

    return Review(
      review_id: reviewId,
      repairscore: json["repairscore"],
      comment: json["comment"],
      reviewdate: reviewdate,
      pictureUrl: json["pictureUrl"],
      informRepair: informRepair,
    );
  }

  Map<String, dynamic> fromReviewsToJson() {
    return <String, dynamic>{
      'review_id': review_id,
      'repairscore': repairscore,
      'comment': comment,
      'pictureUrl': pictureUrl,
      'reviewdate': reviewdate,
      'informRepair': informRepair!.fromInformRepairToJson(),
    };
  }
}
