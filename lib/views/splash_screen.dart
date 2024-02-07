import 'login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xffFF9900),
                  const Color(0xffFFB800),
                  Color.fromARGB(255, 254, 187, 19),
                  Color.fromARGB(255, 255, 212, 103),
                ],
                stops: [0.0, 0.3, 0.7, 1.0], // กำหนดตำแหน่งของสี
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Splash Screen
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              // Check if the user swiped to the right
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            children: [
              Container(
                padding: EdgeInsets.only(top: 85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/Foodpad_logo.png',
                          height: 80,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '"  Welcome to FoodPad  "\n ....Enjoy your cooking....',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Coiny',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // แก้ไขตรงนี้
                          child: Image.asset(
                            'assets/img/left_splash_img.png',
                          ),
                        ),
                        Expanded(
                          // แก้ไขตรงนี้
                          child: Image.asset(
                            'assets/img/right_splash_img.png',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Homescreen (ซ้อนทับ Splash Screen เมื่อเลื่อนไปทางขวา)
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              // ล็อคการเลื่อน
              children: [
                Container(), // Splash Screen (หน้านี้เป็น Splash Screen)
                LoginScreen(), // Homescreen (หน้านี้เป็น Homescreen)
              ],
            ),
          ),
        ],
      ),
    );
  }
}