import 'package:flutter/material.dart';

class ViewDetails extends StatefulWidget {
  final int? informrepair_id;
  const ViewDetails({
    super.key,
    this.informrepair_id,
  });

  @override
  State<ViewDetails> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ViewDetails> {
  @override
  void initState() {
    super.initState();
    print("getinformrepair_id : ${widget.informrepair_id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        child: Text("informrepair_id: ${widget.informrepair_id}"),
      ),
    );
  }
}
