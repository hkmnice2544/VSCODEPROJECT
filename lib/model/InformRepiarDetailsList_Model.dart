import 'dart:ui';

class InformRepairDetailsList {
  final int totalAmount;
  final int informrepair_id;
  final DateTime informDate;
  final String status;
  final int informRepairDetails; // แก้ชื่อตัวแปรให้ตรงกับความหมาย

  InformRepairDetailsList({
    required this.totalAmount,
    required this.informrepair_id,
    required this.informDate,
    required this.status,
    required this.informRepairDetails, // แก้ชื่อตัวแปรให้ตรงกับความหมาย
  });

  // เพิ่ม constructor สำหรับแปลง JSON เป็นอ็อบเจ็กต์
  factory InformRepairDetailsList.fromJson(Map<String, dynamic> json) {
    return InformRepairDetailsList(
      totalAmount: json['TotalAmount'],
      informrepair_id: json['informrepair_id'],
      informDate: DateTime.parse(json['InformDate']),
      status: json['Status'],
      informRepairDetails:
          json['InformRepairDetails'], // แก้ชื่อตัวแปรให้ตรงกับความหมาย
    );
  }
}
