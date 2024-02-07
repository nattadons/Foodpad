import 'package:firebase_auth/firebase_auth.dart';

import 'Login/checkAuth.dart';
import 'Login/with_google.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Orange Background with rounded bottom corners using Image.asset
          Positioned(
            top: 0,
            bottom: MediaQuery.of(context).size.height / 2 + 130,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/img/headlogin.png',
              fit: BoxFit.cover,
            ),
          ),

          // White Background
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 20,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
            ),
          ),

          // Card Form login
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            bottom: MediaQuery.of(context).size.height / 6,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    // Header
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.orange,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          'User Login',
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontFamily: 'Coiny',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login With
                    Text(
                      'Login With',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffADADAD),
                        fontFamily: 'Coiny',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Google Button with Navigation

                    Flexible(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          UserCredential? userCredential =
                              await signInWithGoogle();

                          if (userCredential != null) {
                            // ลงทะเบียนหรือเข้าสู่ระบบสำเร็จ
                            User user = userCredential.user!;
                            print("User ID: ${user.uid}");
                            print("Display Name: ${user.displayName}");
                            print("Email: ${user.email}");

                            // เรียกใช้ฟังก์ชันเพื่อเปลี่ยนหน้า
                            checkAuth(context);
                          } else {
                            // ผู้ใช้ยกเลิกการลงทะเบียนหรือมีข้อผิดพลาด
                            print("Sign in with Google canceled or failed");
                          }
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/img/google_icon.png',
                                height: 30,
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff4F4F4F),
                                      fontFamily: 'Coiny',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    // Please Give us your profile
                    Flexible(
                      child: Text(
                        '"Please Give us your profile"\nfor your cooking experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffADADAD),
                          fontFamily: 'Coiny',
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),

          // Row with 2 images bottom left and right
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/img/BottomLeft_Login.png',
                    height: 230,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    'assets/img/BottomRight_Login.png',
                    height: 230,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
