class Recipe {
  final String key;
  final String title;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<Process> process;
  final List<Score> score;

  Recipe({
    required this.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.process,
    required this.score,
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

  Ingredient({
    required this.name,
    required this.quantity,
  });
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
