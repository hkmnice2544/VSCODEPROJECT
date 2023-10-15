import 'dart:ui';

import 'package:flutterr/model/Room_Model.dart';
import 'package:flutterr/model/User_Model.dart';
import 'package:intl/intl.dart';

class InformRepair {
  int? informrepair_id;
  DateTime? informdate;
  String? informtype;
  String? status;
  User? user;
  Room? room;

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
    this.room,
  });

  factory InformRepair.fromJsonToInformRepair(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final roomJson = json['room'] as Map<String, dynamic>;

    final user = User.fromJsonToUser(userJson);
    final room = Room.fromJsonToRoom(roomJson);

    final informRepair = InformRepair(
        informrepair_id: json['informrepair_id'] as int,
        informdate: json['informdate'] != null
            ? DateTime.parse(json['informdate'] as String)
            : null,
        user: user,
        room: room,
        status: json['status']);

    return informRepair;
  }

  Map<String, dynamic> fromInformRepairToJson() {
    return <String, dynamic>{
      'informrepair_id': informrepair_id,
      'informdate': informdate?.toIso8601String(),
      'status': status,
      'user': user?.toJson(),
      'room': room?.toJson(),
    };
  }
}
