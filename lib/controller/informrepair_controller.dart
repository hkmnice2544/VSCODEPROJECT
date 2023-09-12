import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import '../Model/informrepair_model.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class InformRepairController {
  InformRepair? informRepair;
  List<Map<String, dynamic>> informRepairsList = [];
  final ImagePicker _imagePicker = ImagePicker();

  get body => null;
  // Building? building;
  Future<void> addInformRepair(List<Map<String, dynamic>> data) async {
    // ทำการเพิ่มข้อมูล JSON objects ใน List ตามที่คุณรับมา
    informRepairsList.addAll(data);

    // หลังจากเพิ่มข้อมูลใน List แล้วคุณสามารถทำส่วนอื่น ๆ ที่ต้องการดังนั้น
    // เช่น ส่งข้อมูลไปยังเซิร์ฟเวอร์หรือทำการอัปเดต UI ในแอปพลิเคชันของคุณ
    // ตามความต้องการ

    // เรียกใช้ฟังก์ชันส่งข้อมูลไปยังเซิร์ฟเวอร์ (ตามความต้องการ)
    await sendDataToServer(data);
  }

  Future<void> sendDataToServer(List<Map<String, dynamic>> data) async {
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/informrepairs/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      // คุณอาจจะต้องดำเนินการเพิ่มเติมหรือแสดงผลลัพธ์ตามที่คุณต้องการ
    } else {
      // จัดการข้อผิดพลาดในการส่งข้อมูลไปยังเซิร์ฟเวอร์
      print("เกิดข้อผิดพลาดในการส่งข้อมูล: ${response.statusCode}");
    }
  }

  Future<List<InformRepair>> listAllInformRepairs() async {
    var url = Uri.parse(baseURL + '/informrepairs/list');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<InformRepair> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonList = json.decode(utf8body) as List<dynamic>;

    for (final jsonData in jsonList) {
      final informRepair = InformRepair.fromJsonToInformRepair(jsonData);
      list.add(informRepair);
    }

    return list;
  }

  Future updateInformRepair(String informdetails, String status,
      String equipment_id, String informrepair_id) async {
    Map data = {
      "informdetails": informdetails,
      "status": status,
      "equipment_id": equipment_id,
      "informrepair_id": informrepair_id,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/informrepairs/update');

    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future getInform(int informrepair_id) async {
    var url =
        Uri.parse(baseURL + '/informrepairs/getInformRepair/$informrepair_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    InformRepair? informRepair = InformRepair.fromJsonToInformRepair(jsonMap);
    return informRepair;
  }

  Future deleteInformRepair(int? informrepair_id) async {
    if (informrepair_id == null) {
      // กรณีค่า informrepair_id เป็น null
      print('informrepair_id is null');
      return;
    }

    var url =
        Uri.parse('$baseURL/informrepairs/deleteInformRepair/$informrepair_id');

    // Create the request body
    Map<String, int> data = {
      "informrepair_id": informrepair_id,
    };
    var body = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

// Future getbuilding (int building_id) async {
//     var url = Uri.parse('$baseURL/informrepair/get/$building_id');

//     http.Response response = await http.get(
//       url
//     );

//     print(response.body);

//     var jsonResponse = jsonDecode(response.body);
//     Building building = Building.fromJsonToBuilding(jsonResponse['result']);
//     print("getbuilding : ${building.building_id}");
//     return building;
//   }

//   Future listAllBuilding () async {

//     var url = Uri.parse('$baseURL/building/list');

//     http.Response response = await http.post(
//       url,
//       headers: headers,
//       body: null
//     );

//     print(response.body);

//     List? list;

//     Map<String, dynamic> mapResponse = json.decode(response.body);
//     list = mapResponse['result'];
//     print("listAllBuilding : ${building?.building_id}");
//     return list!.map((e) => Building.fromJsonToBuilding(e)).toList();
//   }

  Future<void> addPicturesToDatabase(
      List<String> pictureUrls, int informRepairId) async {
    final String apiUrl = '$baseURL/inform_pictures/add'; // baseURL ของคุณ

    final Map<String, dynamic> data = {
      "pictureUrls": pictureUrls,
      "informRepairId": informRepairId,
    };

    final String jsonData = jsonEncode(data);

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        // คุณอาจต้องดำเนินการเพิ่มเติมหรือแสดงผลลัพธ์ตามที่คุณต้องการ
      } else {
        // จัดการข้อผิดพลาดในการส่งข้อมูลไปยังเซิร์ฟเวอร์
        print("เกิดข้อผิดพลาดในการส่งข้อมูล: ${response.statusCode}");
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการส่งข้อมูล: $error");
    }
  }
}
