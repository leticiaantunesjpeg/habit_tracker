import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/firebase_service.dart';
import '../services/habit_suggestion_service.dart';

class HabitProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Habit> _habits = [];
  bool _isLoading = true;
  bool _initialized = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  bool get initialized => _initialized;

  HabitProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    if (!_initialized) {
      await _loadHabits();
      _initialized = true;
    }
  }

  Future<void> _loadHabits() async {
    _isLoading = true;
    notifyListeners();
    try {
      print('Iniciando carregamento de hábitos do Firestore...');
      final habitsData = await _firebaseService.getHabits();
      _habits = habitsData.map((data) => Habit.fromMap(data, data['id'])).toList();
      print('Hábitos carregados com sucesso: ${_habits.length} hábitos');
    } catch (e, stackTrace) {
      print('Erro ao carregar hábitos do Firestore:');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      _habits = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(String name, String frequency, int total, {String? startTime, String? endTime, required String category}) async {
    try {
      _isLoading = true;
      notifyListeners();
      print('Adicionando novo hábito: $name, frequência: $frequency, total: $total, início: $startTime, fim: $endTime, categoria: $category');
      
      String normalizedFrequency = frequency == 'Diário' ? 'Diária' : frequency;
      
      final habitData = {
        'name': name,
        'name_lower': name.toLowerCase(),
        'frequency': normalizedFrequency,
        'isCompleted': false,
        'progress': 0,
        'total': total,
        'startTime': startTime,
        'endTime': endTime,
        'category': category
      };
      
      await _firebaseService.createHabit(habitData);
      await _loadHabits();
    } catch (e, stackTrace) {
      print('Erro ao adicionar hábito no Firestore:');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      if (habit.total > 1) {
        habit.progress += 1;
        if (habit.progress >= habit.total) {
          habit.isCompleted = true;
        }
      } else {
        habit.isCompleted = !habit.isCompleted;
      }

      if (habit.id != null) {
        await _firebaseService.updateHabit(habit.id!, {
          'isCompleted': habit.isCompleted,
          'progress': habit.progress,
        });
      }
      notifyListeners();
      await _loadHabits();
    } catch (e) {
      print('Error toggling habit completion in Firestore: $e');
      habit.progress = habit.progress > 0 ? habit.progress - 1 : 0; 
      habit.isCompleted = false;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _firebaseService.deleteHabit(habitId);
      await _loadHabits();
    } catch (e, stackTrace) {
      print('Erro ao excluir hábito no Firestore:');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> deleteAllHabits() async {
    try {
      final habits = await _firebaseService.getHabits();
      for (var habit in habits) {
        await _firebaseService.deleteHabit(habit['id']);
      }
      _habits = [];
      notifyListeners();
    } catch (e) {
      print('Error deleting all habits from Firestore: $e');
    }
  }

  Future<void> updateHabit(Habit habit, String newName, String newFrequency, int newTotal, String? startTime, String? endTime, {required String category}) async {
    try {
      print('Tentando atualizar hábito: ${habit.id}');
      print('Novos dados: nome=$newName, frequência=$newFrequency, total=$newTotal, início=$startTime, fim=$endTime, categoria=$category');

      if (habit.id == null) {
        throw Exception('Tentativa de atualizar hábito sem ID');
      }

      final updateData = {
        'name': newName,
        'frequency': newFrequency,
        'total': newTotal,
        'startTime': startTime,
        'category': category,
        'endTime': endTime,
      };

      print('Atualizando documento no Firestore...');
      await _firebaseService.updateHabit(habit.id!, updateData);
      
      await _loadHabits();
      print('Hábitos recarregados com sucesso');
    } catch (e, stackTrace) {
      print('Erro ao atualizar hábito no Firestore:');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateHabitNotes(Habit habit, String notes) async {
    try {
      if (habit.id == null) {
        throw Exception('Tentativa de atualizar notas de hábito sem ID');
      }

      await _firebaseService.updateHabit(habit.id!, {
        'notes': notes,
      });
      
      await _loadHabits();
    } catch (e, stackTrace) {
      print('Erro ao atualizar notas do hábito no Firestore:');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
