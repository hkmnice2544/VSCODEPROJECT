import 'package:flutter/material.dart';

class User with ChangeNotifier {
  int? user_id;
  String? usertype;
  String? firstname;
  String? lastname;
  String? username;
  String? password;
  String? mobile;
  User({
    required this.user_id,
    this.usertype,
    this.firstname,
    this.lastname,
    this.username,
    this.password,
    this.mobile,
  });

  factory User.fromJsonToUser(Map<String, dynamic> json) {
    return User(
      user_id: json[
          'user_id'], // แปลงเป็น String เนื่องจาก userId เป็น String ในคลาส Flutter
      usertype: json['usertype'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      mobile: json['mobile'] as String,
    );
  }

  void setUserId(String id) {
    user_id = user_id;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'usertype': usertype,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
      'mobile': mobile,
    };
  }
}
