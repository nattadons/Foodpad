import 'dart:async';
import 'package:flutter/material.dart';

class timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int countdown = 10;

  @override
  void initState() {
    super.initState();
    // เริ่มต้นนับถอยหลังทุกวินาที
    startCountdown();
  }

  void startCountdown() {
    const duration = Duration(seconds: 1);

    Timer.periodic(duration, (timer) {
      setState(() {
        // ลดเวลาลงทุกวินาที
        countdown--;

        // ตรวจสอบเงื่อนไขหยุดนับถอยหลังเมื่อถึง 0
        if (countdown == 0) {
          timer.cancel(); // ยกเลิกการทำงานของ Timer
          print("นับถอยหลังเสร็จสิ้น!");
        }
      });
    });

    print("เริ่มต้นนับถอยหลัง 10 วินาที...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Countdown App"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: countdown == 0 ? () => print("ปุ่มถูกกด!") : null,
          child: Text("นับถอยหลัง: $countdown วินาที"),
        ),
      ),
    );
  }
}
