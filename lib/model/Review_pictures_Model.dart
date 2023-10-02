import 'package:flutterr/model/Review_Model.dart';

class Review_pictures {
  int? reviewpictures_id;
  String? picture_url;
  Review? review;

  Review_pictures({
    this.reviewpictures_id,
    this.picture_url,
    this.review,
  });
  factory Review_pictures.fromJsonToReview_pictures(Map<String, dynamic> json) {
    final reviewJson = json['review'] as Map<String, dynamic>;

    final review = Review.fromJsonToReviews(reviewJson);

    final inform_Pictures = Review_pictures(
        reviewpictures_id: json['reviewpictures_id'] as int,
        picture_url: json['pictureUrl'],
        review: review);

    return inform_Pictures;
  }

  Map<String, dynamic> fromReview_picturesToJson() {
    return <String, dynamic>{
      'reviewpictures_id': reviewpictures_id,
      'picture_url': picture_url,
      'review': review?.fromReviewsToJson(),
    };
  }
}
