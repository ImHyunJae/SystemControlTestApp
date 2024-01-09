import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class CurrentDateTimeWidget extends StatefulWidget {
  @override
  _CurrentDateTimeWidgetState createState() => _CurrentDateTimeWidgetState();
}

class _CurrentDateTimeWidgetState extends State<CurrentDateTimeWidget> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      // Use format without "H:mm:ss.S"
      "${_dateTime.hour}:${_dateTime.minute}:${_dateTime.second}",
      style: TextStyle(fontSize: 30), // Customize the text style as needed
    );
  }
}
