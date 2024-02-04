import 'package:appfoodpad/views/home_screen.dart';

import 'views/splash_screen.dart'; //
import 'package:flutter/material.dart';
import 'package:appfoodpad/models/recipe.dart';
import 'package:appfoodpad/views/widgets/recipe_details.dart';

import 'package:firebase_core/firebase_core.dart';

// main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        "/recipe_details": (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments is Recipe) {
            return RecipeDetailsScreen(recipe: arguments);
          } else {
            return Container(); // หรือแสดงหน้า error
          }
        },
        "/home_screen": (context) {
          return HomeScreen(); // หรือตัวอื่น ๆ ที่คุณต้องการ
        },
        // เพิ่มเส้นทางอื่น ๆ ที่คุณต้องการในนี้
      },
    );
  }
}
