import '../models/recipe.dart';
import 'Login/with_google.dart';
import 'widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// home_screen.dart


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Recipe> filteredRecipes = [];
  late Recipe recipe;

  // Global variable to store recipes from FirebaseAnimatedList
  late List<Recipe> recipes;

  User? user = FirebaseAuth.instance.currentUser;

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

      Recipe recipe = Recipe(
        title: values['title'],
        description: values['description'],
        imageUrl: values['imageUrl'],
        ingredients: ingredients,
        process: process,
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
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ElevatedButton(
              onPressed: () async {
                // ทำการ signout
                await signOutFromGoogle();

                // เปลี่ยนหน้าไปยังหน้า login หรือหน้าที่คุณต้องการ
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sign Out'),
            ),
          ), // Removed extra child property here
          CircleAvatar(
            backgroundImage: NetworkImage(user!.photoURL!),
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
                    filteredRecipes = recipes.where((recipe) {
                      // Check if the recipe title contains the query
                      bool titleContainsQuery = recipe.title
                          .toLowerCase()
                          .contains(query.toLowerCase());

                      // Check if any ingredient name contains the query
                      bool ingredientContainsQuery = recipe.ingredients.any(
                          (ingredient) => ingredient.name
                              .toLowerCase()
                              .contains(query.toLowerCase()));

                      // Return true if either title or ingredient name contains the query
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
            SizedBox(height: 16),
            Expanded(
              child: filteredRecipes.isNotEmpty || searchController.text.isEmpty
                  ? ListView.builder(
                      itemCount: filteredRecipes.isNotEmpty
                          ? filteredRecipes.length
                          : recipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipe: filteredRecipes.isNotEmpty
                              ? filteredRecipes[index]
                              : recipes[index],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No matching recipes found.',
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

  void navigateToOtherScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
