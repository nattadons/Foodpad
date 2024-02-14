import 'package:firebase_database/firebase_database.dart';

import 'recipe_step.dart';
import 'recipe_score.dart';
import '../../models/recipe.dart';
import 'package:flutter/material.dart';
// recipe_details.dart

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {

  late Recipe recipe;

  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    recipes = [];

    DatabaseReference reference =
    FirebaseDatabase.instance.reference().child('recipes');

    reference.onChildAdded.listen((event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map;

      List<Ingredient> ingredients = [];
      for (var ingredient in values['ingredients']) {
        ingredients.add(Ingredient(
          name: ingredient['name'],
          quantity: ingredient['quantity'],
        ));
      }

      List<Process> process = [];
      for (var step in values['process']) {
        process.add(Process(
          name: step['name'],
          timer: step['timer'],
        ));
      }

      List<Score> score = [];
      if (values['score'] != null) {
        values['score'].forEach((key, data) {
          score.add(Score(
            key: key,
            id: data['id'],
            name: data['name'],
            profileUrl: data['profile_img'],
            scores: data['scores'],
          ));
        });
      }


      Recipe recipe = Recipe(
        key: event.snapshot.key ?? '',
        title: values['title'],
        description: values['description'],
        imageUrl: values['imageUrl'],
        ingredients: ingredients,
        process: process,
        score: score,
      );

      setState(() {
        recipes.add(recipe);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffFF9900), // กำหนดสีของไอคอน
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home_screen', // ตั้งค่า route ของหน้า HomeScreen ที่คุณต้องการไป
              (route) => false, // ลบทุกหน้าที่อยู่บน stack ออกไป
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.recipe.imageUrl,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/img/detail.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'รายละเอียด',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.recipe.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/img/chef_score.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'เเสกนวัตถุดิบ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: widget.recipe.ingredients.map((ingredient) {
                      return ListTile(
                        title: Text(
                          '${ingredient.name}: ${ingredient.quantity}',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/img/chef_score.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'ขั้นตอนการทำ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: widget.recipe.process.map((process) {
                      return ListTile(
                        title: Text(
                          process.name,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32),
                  _buildThirdCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdCard(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ส่วนที่ 1: ปุ่ม "start cooking"
            SizedBox(
              height: 60,
              // กำหนดขนาดตามที่คุณต้องการ
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to RecipeStepScreen on button press
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeStepScreen(recipe: widget.recipe),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text(
                  "Let's Cooking",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Coiny',
                      color: Color.fromARGB(
                          237, 255, 255, 255)), // ปรับขนาดตามที่คุณต้องการ
                ),
              ),
            ),
            // ส่วนที่ 2: รูปภาพ 1
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  'assets/img/scan_icon.png',
                  height: 40,
                ),
              ),
            ),
            // ส่วนที่ 3: รูปภาพ 2
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeScoreScreen(recipe: widget.recipe),
                  ),
                );
              },
              child: Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Image.asset(
                    'assets/img/score_icon.png',
                    height: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
