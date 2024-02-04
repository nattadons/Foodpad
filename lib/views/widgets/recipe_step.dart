import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/recipe.dart';

class RecipeStepScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeStepScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeStepScreenState createState() => _RecipeStepScreenState();
}

class _RecipeStepScreenState extends State<RecipeStepScreen> {
  int currentStepIndex = 0;
  int score = 0;
  late int countdown;

  @override
  void initState() {
    super.initState();
    // เริ่มต้นนับถอยหลังทุกวินาที
    countdown = widget.recipe.process[0].timer;
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

  void showSubmitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 228, 166, 10),
                ),
                SizedBox(width: 8),
                Text(
                  'Congratulations!',
                ),
              ],
            ),
            content: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('You have completed the recipe!'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score : $score',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 153, 36),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/img/chef_score.png',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Pop RecipeStepScreen
                  Navigator.pushReplacementNamed(context, '/recipe_details',
                      arguments: widget.recipe);
                },
                child: Text('OK'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 5,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cooking Steps',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffFF9900),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffF7F6FF),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left Card for Cooking Step
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                color: Colors.orange,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(8.0), // Adjust the radius as needed
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cooking Steps',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right Card for Countdown
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                color: Color.fromARGB(255, 255, 255, 255),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight:
                        Radius.circular(8.0), // Adjust the radius as needed
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: [
                        Image.asset(
                          'assets/img/countdown.png',
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          ' $countdown s',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF3333),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${currentStepIndex + 1}:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.recipe.process[currentStepIndex].name,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (currentStepIndex <
                            widget.recipe.process.length - 1) {
                          setState(() {
                            currentStepIndex++;
                            countdown =
                                widget.recipe.process[currentStepIndex].timer;
                          });
                        } else {
                          showSubmitDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (currentStepIndex <
                                widget.recipe.process.length - 1 &&
                            countdown == 0) {
                          setState(() {
                            currentStepIndex++;
                            countdown =
                                widget.recipe.process[currentStepIndex].timer;
                            score += 100;
                          });
                        } else if (currentStepIndex ==
                                widget.recipe.process.length - 1 &&
                            countdown == 0) {
                          showSubmitDialog();
                          score += 100;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
