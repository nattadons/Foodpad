import 'recipe_step.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
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
                backgroundColor: Color(0xffFF9900),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Start Cooking',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            Image.asset(
              'assets/img/scan_icon.png',
              width: 60,
              height: 60,
            ),
            Image.asset(
              'assets/img/score_icon.png',
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
