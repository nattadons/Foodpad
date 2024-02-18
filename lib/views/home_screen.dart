import '../models/recipe.dart';
import 'Login/with_google.dart';
import 'widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Recipe> filteredRecipes = [];
  late Recipe recipe;

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

      List<Score> score = [];
      if (values['score'] != null) {
        values['score'].forEach((key, data) {
          print("key");
          print(key);
          print("data");
          print(data);
          score.add(Score(
            key: key,
            id: data['id'],
            name: data['name'],
            profileUrl: data['profile_img'],
            scores: data['scores'],
          ));
        });
      }
      score.sort((a, b) => b.scores.compareTo(a.scores));

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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                user!.displayName ?? 'Guest',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile Cooking'),
              onTap: () {
                // Handle item 1
              },
            ),
            ListTile(
              title: Text('Post Recipe'),
              onTap: () {
                // Handle item 2
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await signOutFromGoogle();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
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
}
