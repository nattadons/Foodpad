import '../../models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeScoreScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScoreScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeScoreScreen> createState() => _RecipeScoreScreenState();
}

class _RecipeScoreScreenState extends State<RecipeScoreScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // เพิ่มรูปภาพด้านบนสุด
            Image.network(
              widget.recipe.imageUrl,
              height: 300,
              fit: BoxFit.cover,
            ),
            // ต่อด้วยส่วนอื่น ๆ ของหน้า
            ListView.builder(
              physics:
              NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
              shrinkWrap: true,
              itemCount: widget.recipe.score.length,
              itemBuilder: (context, index) {
                return _buildScoreCard(context, widget.recipe, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, Recipe recipe, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // รูปโปรไฟล์ของผู้ใช้
              CircleAvatar(
                backgroundImage: NetworkImage(recipe.score[index].profileUrl),
                radius: 25,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อผู้ใช้
                  Text(
                    recipe.score[index].name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  // คะแนน
                  Text(
                    recipe.score[index].scores.toString(),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // ตำแหน่งของคะแนน
              Text(
                '#1', // ตำแหน่งของผู้ให้คะแนน
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
