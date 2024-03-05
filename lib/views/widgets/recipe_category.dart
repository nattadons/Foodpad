import 'package:flutter/material.dart';
import 'package:food_pad/models/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_pad/views/Login/with_google.dart';
import 'package:food_pad/views/widgets/recipe_card.dart';
import 'package:firebase_database/firebase_database.dart';

import '../recipe_profile.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final List<Recipe> filteredRecipes;

  final String type; // เพิ่ม parameter สำหรับรับประเภทของสูตรอาหาร

  CategoryRecipesScreen({required this.filteredRecipes, required this.type});

  @override
  _CategoryRecipesScreenState createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  late List<Recipe> recipesToShow;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    recipesToShow = widget.filteredRecipes;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('recipes');

    reference.onChildAdded.listen((event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFF9900),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the ',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Coiny',
                color: Color(0xFF8A8A8A),
              ),
            ),
            Text(
              'recipe you love',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Coiny',
                color: Color(0xFF4F4F4F),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {
                    recipesToShow = widget.filteredRecipes.where((recipe) {
                      bool titleContainsQuery = recipe.title
                          .toLowerCase()
                          .contains(query.toLowerCase());

                      bool ingredientContainsQuery = recipe.ingredients.any(
                          (ingredient) => ingredient.name
                              .toLowerCase()
                              .contains(query.toLowerCase()));

                      return titleContainsQuery || ingredientContainsQuery;
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ประเภท' + widget.type,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Sriracha',
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: recipesToShow.isNotEmpty || searchController.text.isEmpty
                  ? ListView.builder(
                      itemCount: recipesToShow.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipe: recipesToShow[index],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No recipes found.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Coiny',
                          color: Colors.grey,
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
