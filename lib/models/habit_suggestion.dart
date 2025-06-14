class HabitSuggestion {
  final String name;
  final String category;
  final String frequency;

  HabitSuggestion({
    required this.name,
    required this.category,
    required this.frequency,
  });

  @override
  String toString() {
    return name;
  }
}
