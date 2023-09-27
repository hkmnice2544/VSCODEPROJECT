import 'dart:ui';

class InformRepairDetailsList {
  final int totalAmount;
  final int informrepair_id;
  final DateTime informDate;
  final String status;

  InformRepairDetailsList({
    required this.totalAmount,
    required this.informrepair_id,
    required this.informDate,
    required this.status,
  });

  // เพิ่ม constructor สำหรับแปลง JSON เป็นอ็อบเจ็กต์
  factory InformRepairDetailsList.fromJson(Map<String, dynamic> json) {
    return InformRepairDetailsList(
      totalAmount: json['totalAmount'],
      informrepair_id: json['informrepair_id'],
      informDate: DateTime.parse(json['informDate']),
      status: json['status'],
    );
  }
}
