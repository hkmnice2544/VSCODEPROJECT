import 'package:flutter/material.dart';

import 'Addinform.dart';

void main() => runApp(MyHome());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(),
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Addinform();
                }));
              },
              child: Text('User'),
            ),
            ElevatedButton(
              onPressed: () {
                // รายการการคลิกปุ่ม "Admin"
                print('Admin Button Clicked');
              },
              child: Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
