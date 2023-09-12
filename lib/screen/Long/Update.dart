import 'package:flutter/material.dart';

import '../../Model/informrepair_model.dart';
import '../../controller/informrepair_controller.dart';

import 'Detail.dart';

class Updateinform extends StatefulWidget {
  final int? informrepair_id;
  const Updateinform({
    super.key,
    this.informrepair_id,
  });

  @override
  State<Updateinform> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Updateinform> {
  List<InformRepair>? informrepairs;
  bool? isDataLoaded = false;
  TextEditingController detailsController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController eq_idController = TextEditingController();
  TextEditingController informrepair_idController = TextEditingController();
  final InformRepairController informController = InformRepairController();

  InformRepair? informRepair;

  void fetchgetInform(int informrepair_id) async {
    informRepair = await informController.getInform(informrepair_id);
    detailsController.text = informRepair?.informdetails ?? '';
    statusController.text = informRepair?.status ?? '';
    print("fetchgetInform : ${informRepair?.informrepair_id}");
    setState(() {
      isDataLoaded = true;
    });
  }

  void fetchUpdateInformRepair() async {
    informrepairs = await informController.updateInformRepair(
        "informdetails", "status", "equipment_id", "informrepair_id");
    print({informrepairs?[0].informrepair_id});
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUpdateInformRepair();
    fetchgetInform(widget.informrepair_id!);
    print("getinformrepair_id : ${widget.informrepair_id!}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "หน้า Update",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
              fontWeight: FontWeight.w100,
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
            // child: isDataLoaded == true && informRepair != null?
            child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                ),
                onChanged: (value) {},
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                  labelText: 'สถานะ',
                ),
                onChanged: (value) {},
              ),
              TextField(
                controller: eq_idController,
                decoration: InputDecoration(
                  labelText: 'Equipment_id',
                ),
                onChanged: (value) {},
              ),
              TextField(
                controller: informrepair_idController,
                decoration: InputDecoration(
                  labelText: 'informrepair_id',
                ),
                onChanged: (value) {},
              ),
              Text("${widget.informrepair_id}"),
              ElevatedButton(
                  onPressed: () async {
                    var response = await informController.updateInformRepair(
                        detailsController.text,
                        statusController.text,
                        eq_idController.text,
                        informrepair_idController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Details();
                    }));
                    print("object");
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                    textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                    padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                    ),
                  ),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    var response = await informController
                        .deleteInformRepair(informRepair?.informrepair_id);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Details();
                    }));
                    print("object");
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 234, 112, 5), // สีพื้นหลังของปุ่ม
                    textStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255)), // สีข้อความภายในปุ่ม
                    padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20), // การจัดพื้นที่รอบข้างปุ่ม
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // กำหนดรูปร่างของปุ่ม (ในที่นี้เป็นรูปแบบมน)
                    ),
                  ),
                  child: Text(
                    'ลบ',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ))
            ],
          ),
        )
            // : CircularProgressIndicator(),
            ));
  }
}
