import '../models/recipe.dart';
import 'Login/with_google.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipe_category.dart';
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
  bool isSearching = false;

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
        type: values['type'],
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
        backgroundColor: Colors.orange,
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
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/headlogin.png'),
                  fit: BoxFit.cover,
                ),
              ),
              accountName: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL!),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    user!.displayName ?? 'Guest',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Sriracha',
                    ),
                  ),
                ],
              ),
              accountEmail: null,
            ),
            ListTile(
              title: Text(
                'Profile Cooking',
                style: TextStyle(
                  fontFamily: 'Coiny',
                  color: Color(0xFF4F4F4F),
                ),
              ),
              onTap: () {
                // Handle item 1
              },
            ),
            ListTile(
              title: Text(
                'Post Recipe',
                style: TextStyle(
                  fontFamily: 'Coiny',
                  color: Color(0xFF4F4F4F),
                ),
              ),
              onTap: () {
                // Handle item 2
              },
            ),
            ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(
                  fontFamily: 'Coiny',
                  color: Color.fromARGB(255, 255, 149, 9),
                ),
              ),
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
                    isSearching = query.isNotEmpty;
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
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Coiny',
                color: Color(0xFF4F4F4F),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isSearching
                  ? filteredRecipes.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(recipe: filteredRecipes[index]);
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
                        )
                  : GridView.count(
                      crossAxisCount: 2,
                      children: [
                        _buildCategoryContainer(
                            'ต้ม', 'assets/img/category_tom.png'),
                        _buildCategoryContainer(
                            'ผัด', 'assets/img/category_pad.png'),
                        _buildCategoryContainer(
                            'เเกง', 'assets/img/category_soup.png'),
                        _buildCategoryContainer(
                            'ทอด', 'assets/img/category_fried.png'),
                        _buildCategoryContainer(
                            'ของหวาน', 'assets/img/category_sweet.png'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContainer(String category, String imagePath) {
    return GestureDetector(
      onTap: () {
        List<Recipe> filteredRecipes =
            recipes.where((recipe) => recipe.type == category).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryRecipesScreen(
              filteredRecipes: filteredRecipes,
              type: category,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 17, 10, 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: -2,
            ),
          ],
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Sriracha',
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
