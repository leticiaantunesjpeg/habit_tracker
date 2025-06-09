class Habit {
  String? id;
  final String name;
  final String frequency;
  bool isCompleted;
  int progress;
  int total;
  String? notes;
  String? startTime;
  String? endTime; 

  Habit({
    this.id,
    required this.name,
    required this.frequency,
    this.isCompleted = false,
    this.progress = 0,
    this.total = 1,
    this.notes,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency,
      'isCompleted': isCompleted,
      'progress': progress,
      'total': total,
      'notes': notes,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  static Habit fromMap(Map<String, dynamic> map, String id) {
    return Habit(
      id: id,
      name: map['name'],
      frequency: map['frequency'],
      isCompleted: map['isCompleted'] ?? false,
      progress: map['progress'] ?? 0,
      total: map['total'] ?? 1,
      notes: map['notes'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
