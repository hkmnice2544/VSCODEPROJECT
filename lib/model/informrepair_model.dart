import 'dart:ui';

import 'package:flutterr/model/%E0%B9%8AUser_Model.dart';
import 'package:intl/intl.dart';

import 'Equipment_Model.dart';
import 'Room_Model.dart';

class InformRepair {
  int? informrepair_id;
  DateTime? informdate;
  String? informtype;
  String? status;
  User? user;

  String formattedInformDate() {
    if (informdate != null) {
      final thailandLocale = const Locale('th', 'TH');
      final outputFormat =
          DateFormat('dd-MM-yyyy HH:mm', thailandLocale.toString());
      return outputFormat.format(informdate!);
    } else {
      return 'N/A';
    }
  }

  InformRepair({
    required this.informrepair_id,
    this.informdate,
    this.status,
    this.user,
  });

  factory InformRepair.fromJsonToInformRepair(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;

    final user = User.fromJsonToUser(userJson);

    final informRepair = InformRepair(
      informrepair_id: json['informrepair_id'] as int,
      informdate: json['informdate'] != null
          ? DateTime.parse(json['informdate'] as String)
          : null,
      user: user,
    );

    return informRepair;
  }

  Map<String, dynamic> fromInformRepairToJson() {
    return <String, dynamic>{
      'informrepair_id': informrepair_id,
      'informdate': informdate?.toIso8601String(),
      'status': status,
      'user': user?.toJson(),
    };
  }
}
