import 'package:flutter/material.dart';

class Reviews {
 int? review_id;
 String? reviewer;
 String? repairscore;
 String? comment;

  
Reviews({
  required this.review_id,
  // this.informdate,
  this.reviewer,
  this.repairscore,
  this.comment,
});

factory Reviews.fromJsonToReview(Map<String, dynamic> json) => Reviews(
  review_id: int.parse(json["review_id"].toString()),
  reviewer: json["reviewer"],
  // reportdate: json["reportdate"],
  // enddate: json["enddate"],
  repairscore: json["repairscore"],
  comment: json["comment"],
  // informdate: DateTime.parse(json["informdate"].toString()),
);

Map<String, dynamic> fromReviewToJson() {
  return <String, dynamic> {
    'review_id': review_id,
    'reviewer': reviewer,
    // 'reportdate': reportdate,
    // 'enddate': enddate,
    'repairscore': repairscore,
    'comment': comment,
    
  };
}
}