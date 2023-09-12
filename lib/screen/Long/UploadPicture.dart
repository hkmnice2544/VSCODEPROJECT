import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPicture extends StatefulWidget {
  const UploadPicture({super.key});

  @override
  State<UploadPicture> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadPicture> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: imageFileList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // กำหนดจำนวนคอลัมน์ที่คุณต้องการ
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String fileName = imageFileList[index]
                        .path
                        .split('/')
                        .last; // ดึงชื่อไฟล์จาก path
                    return ListTile(
                      title: Text(fileName), // แสดงชื่อภาพด้วยชื่อไฟล์
                      subtitle: Image.file(
                        File(imageFileList[index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
                color: Colors.blue,
                child: Text(
                  "Pick",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  selectImages();
                })
          ],
        ),
      ),
    );
  }
}
