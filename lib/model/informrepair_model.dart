import 'dart:ui';

import 'package:flutterr/model/%E0%B9%8AUser_Model.dart';
import 'package:intl/intl.dart';

import 'Equipment_Model.dart';
import 'Room_Model.dart';

class InformRepair {
  int? informrepair_id;
  DateTime? informdate;
  String? informdetails;
  String? status;
  User? user;
  List<Room>? rooms;
  List<Equipment>? equipment;

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
    this.informdetails,
    this.status,
    this.user,
    this.rooms,
    this.equipment,
  });

  factory InformRepair.fromJsonToInformRepair(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final roomJsonList = json['rooms'] as List<dynamic>;
    final equipmentJsonList = json['equipment'] as List<dynamic>;

    final user = User.fromJsonToUser(userJson);
    final rooms =
        roomJsonList.map((roomJson) => Room.fromJsonToRoom(roomJson)).toList();
    final equipment = equipmentJsonList
        .map((equipmentJson) => Equipment.fromJsonToEquipment(equipmentJson))
        .toList();

    final informRepair = InformRepair(
      informrepair_id: json['informrepair_id'] as int,
      informdate: json['informdate'] != null
          ? DateTime.parse(json['informdate'] as String)
          : null,
      informdetails: json['informdetails'] as String,
      status: json['status'] as String,
      user: user,
      rooms: rooms,
      equipment: equipment,
    );

    return informRepair;
  }

  Map<String, dynamic> fromInformRepairToJson() {
    return <String, dynamic>{
      'informrepair_id': informrepair_id,
      'informdate': informdate?.toIso8601String(),
      'informdetails': informdetails,
      'status': status,
      'user': user?.toJson(),
      'rooms': rooms?.map((room) => room.toJson()).toList(),
      'equipment': equipment?.map((equipment) => equipment.toJson()).toList(),
    };
  }
}
