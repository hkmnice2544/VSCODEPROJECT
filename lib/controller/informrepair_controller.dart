import 'dart:convert';
import 'dart:io';

import 'package:flutterr/model/Building_Model.dart';
import 'package:flutterr/model/Room_Model.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import '../model/informrepair_model.dart';

class InformRepairController {
  InformRepair? informRepair;
  List<Map<String, dynamic>> informRepairsList = [];
  final ImagePicker _imagePicker = ImagePicker();

  get body => null;
  Building? building;
  Room? room;

  Future addInformRepair(String informtype, String status, int amount,
      String detail, String pictures, int user_id, int equipment_id) async {
    Map data = {
      // "informdate" : informdate,
      "informtype": informtype,
      "status": status,
      "amount": amount,
      "details": detail,
      "pictures": pictures,
      "user_id": user_id,
      "equipment_id": equipment_id
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/informrepairs/addInformRepair');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    // print("addInformRepair: ${informRepair!.informdate}");
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse(baseURL + "/informrepairs/uploadimg");
    var length = await file.length();
    //print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    //var jsonResponse = jsonDecode(response.body);
    return response.body;
  }

  Future updateInformRepair(
      String informtype,
      String status,
      int amount,
      String detail,
      String pictures,
      int user_id,
      int equipment_id,
      int informrepair_id,
      File? file) async {
    if (file != null) {
      var newFilePath = await upload(file);

      pictures = newFilePath.toString();
      print("NEW FILE IS " + newFilePath.toString());
    }

    Map data = {
      "informtype": informtype,
      "status": status,
      "amount": amount,
      "details": detail,
      "pictures": pictures,
      "user_id": user_id,
      "equipment_id": equipment_id,
      "informrepair_id": informrepair_id
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/informrepairs/update');

    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future findSumamountById(int? informrepair_id) async {
    var url = Uri.parse(baseURL + '/informrepairs/amount/$informrepair_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);
    return response.body == "" ? "0" : response.body;
  }

  Future findInformDetailIDById(int? informrepair_id) async {
    var url = Uri.parse(
        baseURL + '/informrepairs/findInformDetailIDById/$informrepair_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ findInformDetailIDById : " + response.body);
    return response.body == "" ? "0" : response.body;
  }

  Future<List<InformRepair>> listAllInformRepairs() async {
    try {
      var url = Uri.parse(baseURL + '/informrepairs/list');

      http.Response response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        final utf8body = utf8.decode(response.bodyBytes);
        final jsonList = json.decode(utf8body) as List<dynamic>;

        List<InformRepair> list = [];

        for (final jsonData in jsonList) {
          final informRepair = InformRepair.fromJsonToInformRepair(jsonData);
          list.add(informRepair);
        }
        return list;
      } else {
        throw Exception('Failed to load inform repairs');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load inform repairs');
    }
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
      print('informrepair_id is null');
      return;
    }

    var url =
        Uri.parse('$baseURL/informrepairs/deleteInformRepair/$informrepair_id');
    var response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      print('Deleted successfully: ${response.body}');
      return "Deleted successfully";
      // ดำเนินการตามความเหมาะสมหลังจากลบสำเร็จ
    } else {
      print('Failed to delete with status: ${response.statusCode}');
      print('Response JSON: ${response.body}');
      // แสดงข้อมูล JSON ที่ได้รับเพื่อทราบข้อผิดพลาด
      throw Exception('Failed to delete InformRepair');
    }
  }

  Future<List> listAllBuildings() async {
    var url = Uri.parse(baseURL + '/buildings/list');

    http.Response response = await http.post(url, headers: headers);
    print(response.body);

    List<Building> list = [];

    final utf8body = utf8.decode(response.bodyBytes);
    final jsonList = json.decode(utf8body) as List<dynamic>;

    for (final jsonData in jsonList) {
      final building = Building.fromJsonToBuilding(jsonData);
      list.add(building);
    }

    return list;
  }

  // Future<List<Room>> listAllRooms() async {
  //   var url = Uri.parse(baseURL + '/rooms/listAllDistinctRoomNames');

  //   try {
  //     http.Response response = await http.post(url, headers: headers);
  //     print(response.body);

  //     List<Room> list = [];

  //     final utf8body = utf8.decode(response.bodyBytes);
  //     final jsonList = json.decode(utf8body) as List<dynamic>;

  //     for (final jsonData in jsonList) {
  //       final room =
  //           Room.fromJsonToRoom(jsonData); // แปลง JSON เป็น Room object
  //       list.add(room);
  //     }

  //     return list;
  //   } catch (e) {
  //     // ในกรณีที่เกิดข้อผิดพลาด
  //     print('Error fetching room data: $e');
  //     return []; // หรือสามารถจัดการข้อผิดพลาดอื่น ๆ ตามที่คุณต้องการได้ในส่วน catch
  //   }
  // }

  // Future<void> addPicturesToDatabase(
  //     List<String> pictureUrls, int informRepairId) async {
  //   final String apiUrl = '$baseURL/inform_pictures/add'; // baseURL ของคุณ

  //   final Map<String, dynamic> data = {
  //     "pictureUrls": pictureUrls,
  //     "informRepairId": informRepairId,
  //   };

  //   final String jsonData = jsonEncode(data);

  //   try {
  //     final http.Response response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonData,
  //     );

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       print(jsonResponse);
  //       // คุณอาจต้องดำเนินการเพิ่มเติมหรือแสดงผลลัพธ์ตามที่คุณต้องการ
  //     } else {
  //       // จัดการข้อผิดพลาดในการส่งข้อมูลไปยังเซิร์ฟเวอร์
  //       print("เกิดข้อผิดพลาดในการส่งข้อมูล: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("เกิดข้อผิดพลาดในการส่งข้อมูล: $error");
  //   }
  // }

  Future ViewListByinformrepair_id(int informrepair_id) async {
    var url = Uri.parse(
        baseURL + '/informrepairs/ViewListByinformrepair_id/$informrepair_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    InformRepair? informRepair = InformRepair.fromJsonToInformRepair(jsonMap);
    return informRepair;
  }

  Future<List<String>> findfloorByIdbuilding_id(String? building_id) async {
    var url = Uri.parse(baseURL + '/rooms/floor/$building_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future<List<String>> findpositionByIdbuilding_id(
      String? building_id, String? floor) async {
    var url = Uri.parse(baseURL + '/rooms/position/$building_id/$floor');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future<List<String>> findroomnameByIdbuilding_id(
      String? building_id, String? floor, String? position) async {
    var url =
        Uri.parse(baseURL + '/rooms/roomname/$building_id/$floor/$position');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future<List<String>> findroom_idByIdByAll(String? building_id, String? floor,
      String? position, String? roomname) async {
    var url = Uri.parse(baseURL +
        '/rooms/findroom_idByIdByAll/$building_id/$floor/$position/$roomname');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future<List<String>> findequipment_idByIdByroom_id(String? room_id) async {
    var url =
        Uri.parse(baseURL + '/rooms/findequipment_idByIdByroom_id/$room_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future<List<String>> findequipmentnameByIdByequipment_id(
      int? equipment_id) async {
    var url = Uri.parse(
        baseURL + '/rooms/findequipmentnameByIdByequipment_id/$equipment_id');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON จาก String เป็น List<String>
      List<String> floorList =
          (json.decode(response.body) as List).cast<String>();

      return floorList;
    } else {
      throw Exception("ไม่สามารถดึงข้อมูลได้");
    }
  }

  Future findlistRoomByIdBybuilding_id(
      int? building_id, String roomtype) async {
    var url = Uri.parse(baseURL +
        '/rooms/findlistRoomByIdBybuilding_id/$building_id/$roomtype');

    http.Response response = await http.post(url, headers: headers, body: null);
    print("ข้อมูลที่ได้คือ : " + response.body);

    List<dynamic> jsonMap = json.decode(response.body);
    List<Room>? room =
        await jsonMap.map((e) => Room.fromJsonToRoom(e)).toList();
    return room;
  }
}
