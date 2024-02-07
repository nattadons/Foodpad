// recipe_card.dart
import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import 'recipe_details.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipe),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              recipe.imageUrl,
              height: 200, // รูปภาพมีความสูง 200
              fit: BoxFit.cover, // ปรับขนาดรูปภาพเพื่อให้พอดีกับ Container
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.description,
                    maxLines: 2, // กำหนดจำนวนบรรทัดสูงสุดที่แสดง
                    overflow:
                        TextOverflow.ellipsis, // ให้แสดง ... ถ้าข้อมูลยาวเกินไป
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
