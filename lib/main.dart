import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: Scaffold(
        body: Center(
          child: Text('Your App Content'),
        ),
      ),
    );
  }
}

class MyDataReceiver {
  static const platform = MethodChannel('com.example.fututi_mortii_matii/data');

  static Future<bool> receiveData() async {
    try {
      bool data = await platform.invokeMethod('getData');
      return data;
    } on PlatformException catch (e) {
      print("Failed to receive data: '${e.message}'.");
      return false;
    }
  }
}
