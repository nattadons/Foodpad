import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_pad/models/recipe.dart';
import 'package:food_pad/views/widgets/recipe_card.dart';

class RecipeProfile extends StatefulWidget {
  final List<Recipe> recipes;
  final User user;

  const RecipeProfile({Key? key, required this.recipes, required this.user})
      : super(key: key);

  @override
  _RecipeProfileState createState() => _RecipeProfileState();
}

class _RecipeProfileState extends State<RecipeProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL!),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ชื่อของคุณ: ${widget.user.displayName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ประวัติการทำอาหาร',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipes.length,
              itemBuilder: (context, index) {
                if (widget.recipes[index].score.isNotEmpty &&
                    widget.recipes[index].score[0].id == widget.user.uid) {
                  // Only return RecipeCard when the condition is met
                  print("index ที่ ${index} มี score");
                  print('context = ${widget.recipes[index].score[0].id}');
                  print('scores = ${widget.recipes[index].score[0].scores}');
                  return RecipeCard(recipe: widget.recipes[index]);
                } else {
                  // Return an empty container or null when the condition is not met
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
