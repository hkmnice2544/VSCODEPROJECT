import 'package:flutter/material.dart';
import 'package:flutterr/controller/informrepair_controller.dart';
import 'package:flutterr/controller/informrepairdetails_controller.dart';
import 'package:flutterr/model/InformRepiarDetails_Model.dart';
import '../../../model/informrepair_model.dart';
import 'View_NewItem.dart';

class listAllInformRepairs extends StatefulWidget {
  const listAllInformRepairs({super.key});

  @override
  State<listAllInformRepairs> createState() => _listAllInformRepairsState();
}

class _listAllInformRepairsState extends State<listAllInformRepairs> {
  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;
  List<InformRepairDetails>? informrepairsdetails;

  final InformRepairController informController = InformRepairController();
  final InformRepairDetailsController informRepairDetailsController =
      InformRepairDetailsController();

  // void fetchlistAllInformRepairs() async {
  //   informrepairs = await informController.listAllInformRepairs();
  //   print({informrepairs?[0].informrepair_id});
  //   print({informrepairs});
  //   informrepairs?.sort((a, b) {
  //     if (a.informdate == null && b.informdate == null) {
  //       return 0;
  //     } else if (a.informdate == null) {
  //       return 1;
  //     } else if (b.informdate == null) {
  //       return -1;
  //     }
  //     return b.informdate!.compareTo(a.informdate!);
  //   });
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  Future<void> loadInformRepairDetails() async {
    try {
      // เรียกใช้งานฟังก์ชัน listAll() จากคลาส InformRepairDetailsController
      final controller = InformRepairDetailsController();
      final detailsList = await controller.listAll();

      setState(() {
        informrepairsdetails = detailsList;
        isDataLoaded = true;
      });
    } catch (e) {
      // จัดการข้อผิดพลาดที่อาจเกิดขึ้นในกรณีที่ไม่สามารถโหลดข้อมูลได้
      print('Error loading inform repair details: $e');
    }
  }

  // void listAllinformRepairDetails() async {
  //   // เรียกใช้งานฟังก์ชันดึงข้อมูลจาก controller
  //   informrepairsdetails = (await informRepairDetailsController.listAll())
  //       .cast<InformRepairDetails>();
  //   setState(() {
  //     isDataLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    loadInformRepairDetails();
    informrepairs?.sort((a, b) {
      if (a.informdate == null && b.informdate == null) {
        return 0;
      } else if (a.informdate == null) {
        return 1;
      } else if (b.informdate == null) {
        return -1;
      }
      return b.informdate!.compareTo(a.informdate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InformRepairDetails>>(
      future: informRepairDetailsController.listAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ถ้ายังไม่ได้รับข้อมูล
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // ถ้ามีข้อผิดพลาด
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // ถ้าไม่มีข้อมูลหรือข้อมูลเป็นรายการว่าง
          return Text('No Data');
        } else {
          // ถ้าได้รับข้อมูลสำเร็จ
          final informRepairDetailsList = snapshot.data!;
          return ListView.builder(
            itemCount: informRepairDetailsList.length,
            itemBuilder: (context, index) {
              final informRepairDetails = informRepairDetailsList[index];
              // นำข้อมูลมาแสดงใน ListTile หรือ Widget ตามที่คุณต้องการ
              return ListTile(
                title: Text(
                    'InformRepair ID: ${informRepairDetails.informdetails_Id}'),
                subtitle: Text(
                    'Status: ${informRepairDetails.informRepair?.status ?? 'N/A'}'),
                // แสดงข้อมูลเพิ่มเติมได้ตามต้องการ
              );
            },
          );
        }
      },
    );
  }
}
