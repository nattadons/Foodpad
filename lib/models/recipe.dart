class Recipe {
  final String key;
  final String title;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<Process> process;
  final List<Score> score;
  final String type;

  Recipe({
    required this.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.process,
    required this.score,
    required this.type,
  });
}

class Process {
  final String name;
  final int timer;
  Process({
    required this.name,
    required this.timer,
  });
}

class Ingredient {
  final String name;
  final String quantity;
  final bool isChecked;

  Ingredient(
      {required this.name, required this.quantity, this.isChecked = false});

  // Add copyWith method
  Ingredient copyWith({
    String? name,
    String? quantity,
    bool? isChecked,
  }) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class Score {
  final String key;
  final String id;
  final String name;
  final String profileUrl;
  final int scores;

  Score({
    required this.key,
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.scores,
  });
}
// Dummy data for testing
// Dummy data for testing
