
import '../../models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeScanScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScanScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeScanScreenState createState() => _RecipeScanScreenState();
}

class _RecipeScanScreenState extends State<RecipeScanScreen> {
  late List<Ingredient> ingredients;

  @override
  void initState() {
    super.initState();
    ingredients = widget.recipe.ingredients.map((ingredient) => ingredient.copyWith(isChecked: false)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFF9900),
        title: Text(
          widget.recipe.title,
          style: TextStyle(
            fontFamily: 'Sriracha',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home_screen',
                  (route) => false,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'ตรวจสอบรายการวัตถุดิบ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sriracha',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      return Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            '${ingredient.name}: ${ingredient.quantity}',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Sriracha',
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value: ingredient.isChecked,
                              onChanged: (value) {
                                setState(() {
                                  ingredients[index] = ingredient.copyWith(isChecked: value ?? false);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15),
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