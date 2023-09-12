import 'package:flutter/material.dart';

import '../../Model/informrepair_model.dart';
import '../../controller/informrepair_controller.dart';
import 'Update.dart';
import 'View_Details.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Details> {
  TextEditingController detailsController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController eq_idController = TextEditingController();
  final InformRepairController informController = InformRepairController();
  bool? isDataLoaded = false;
  InformRepair? informRepairs;
  List<InformRepair>? informrepairs;

  void fetchlistAllInformRepairs() async {
    informrepairs = await informController.listAllInformRepairs();
    print({informrepairs?[0].informrepair_id});
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchlistAllInformRepairs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "หน้า Detail",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 21,
              fontWeight: FontWeight.w100,
            ),
          ),
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body:
            // isDataLoaded == false
            // ? CircularProgressIndicator()
            // : //ถ้ามีค่าว่างให้ขึ้นตัวหมุนๆ
            Container(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: informrepairs?.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.account_circle, color: Colors.red)],
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            "เลขที่แจ้งซ่อม",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 22),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${informrepairs?[index].informrepair_id}",
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 22),
                          ),
                        ),
                      ]),
                      // Row(children: [
                      //   Expanded(
                      //     child: Text(
                      //       "วันที่แจ้งซ่อม",
                      //       style: const TextStyle(
                      //           fontFamily: 'Itim', fontSize: 22),
                      //     ),
                      //   ),
                      //   Expanded(
                      //     child: Text(
                      //       "",
                      //       style: const TextStyle(
                      //           fontFamily: 'Itim', fontSize: 22),
                      //     ),
                      //   ),
                      // ]),
                      // Row(children: [
                      //   Expanded(
                      //     child: Text(
                      //       "สถานะ ",
                      //       style: const TextStyle(
                      //           fontFamily: 'Itim', fontSize: 22),
                      //     ),
                      //   ),
                      //   Expanded(
                      //     child: Text(
                      //       "${informrepairs?[index].status}",
                      //       style: const TextStyle(
                      //           fontFamily: 'Itim', fontSize: 22),
                      //     ),
                      //   ),
                      // ]),
                    ],
                  ),
                  trailing: const Icon(Icons.zoom_in, color: Colors.red),
                  onTap: () {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Updateinform(
                                informrepair_id:
                                    informrepairs?[index].informrepair_id)),
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
