import 'package:flutterr/model/InformRepairDetails_Model.dart';

class Inform_Pictures {
  int? informpictures_id;
  String? pictureUrl;
  InformRepairDetails? informRepairDetails;

  Inform_Pictures({
    this.informpictures_id,
    this.pictureUrl,
    this.informRepairDetails,
  });
  factory Inform_Pictures.fromJsonToInform_Pictures(Map<String, dynamic> json) {
    final informRepairDetailsJson =
        json['informRepairDetails'] as Map<String, dynamic>;

    final informRepairDetails =
        InformRepairDetails.fromJsonToInformRepairDetails(
            informRepairDetailsJson);

    final inform_Pictures = Inform_Pictures(
        informpictures_id: json['informpictures_id'] as int,
        pictureUrl: json['pictureUrl'],
        informRepairDetails: informRepairDetails);

    return inform_Pictures;
  }

  Map<String, dynamic> fromInform_PicturesToJson() {
    return <String, dynamic>{
      'informpictures_id': informpictures_id,
      'pictureUrl': pictureUrl,
      'informRepairDetails':
          informRepairDetails?.fromInformRepairDetailsToJson(),
    };
  }

  void setImageUrl(String? pickedFileName) {}

  void setInformRepair(informRepairById) {}
}
