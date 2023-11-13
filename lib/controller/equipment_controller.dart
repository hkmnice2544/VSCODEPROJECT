import '../constant/constant_value.dart';
import '../model/Equipment_Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EquipmentController {
  Future<List<Equipment>> findEquipmentsByRoomId(int roomId) async {
    try {
      var url = Uri.parse(baseURL + '/equipments/findeqsbyroom_id/${roomId}');

      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final utf8body = utf8.decode(response.bodyBytes);
        final jsonList = json.decode(utf8body) as List<dynamic>;

        List<Equipment> list = [];

        for (final jsonData in jsonList) {
          final equipments = Equipment.fromJsonToEquipment(jsonData);
          list.add(equipments);
          print("eq -------${equipments.equipmentname}");
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
}
