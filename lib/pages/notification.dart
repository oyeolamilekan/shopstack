import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text('Nofications'),
      ),
      body: Container(
        child: Center(
          child: Text(
            "No Notification yet.",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
