import 'package:flutter/material.dart';
import 'dart:convert';

class Reviews {
  int? review_id;
  String? reviewer;
  String? repairscore;
  String? comment;
  int? report_id;

  Reviews({
    required this.review_id,
    // this.informdate,
    this.reviewer,
    this.repairscore,
    this.comment,
    this.report_id,
  });

  factory Reviews.fromJsonToReview(Map<String, dynamic> json) => Reviews(
        review_id: json["review_id"] as int?,
        reviewer: json["reviewer"],
        // reportdate: json["reportdate"],
        // enddate: json["enddate"],
        repairscore: json["repairscore"],
        comment: json["comment"],
        report_id: json["report_id"] as int?,
        // informdate: DateTime.parse(json["informdate"].toString()),
      );

  Map<String, dynamic> fromReviewToJson() {
    return <String, dynamic>{
      'review_id': review_id,
      'reviewer': reviewer,
      // 'reportdate': reportdate,
      // 'enddate': enddate,
      'repairscore': repairscore,
      'comment': comment,
      'report_id': report_id,
    };
  }
}
