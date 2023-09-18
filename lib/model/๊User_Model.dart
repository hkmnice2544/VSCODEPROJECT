import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? userId;

  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }
}
