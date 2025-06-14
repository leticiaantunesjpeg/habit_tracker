import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitAnalyticsService {
  static final HabitAnalyticsService _instance = HabitAnalyticsService._internal();
  
  factory HabitAnalyticsService() => _instance;
  
  HabitAnalyticsService._internal();
  
  Map<String, int> analyzeHabitsByCategory(List<Habit> habits) {
    final Map<String, int> categoryCounts = {};
    
    for (var habit in habits) {
      categoryCounts[habit.category] = (categoryCounts[habit.category] ?? 0) + 1;
    }
    
    return categoryCounts;
  }
  
  Map<String, double> analyzeProgressByCategory(List<Habit> habits) {
    final Map<String, int> categoryTotals = {};
    final Map<String, int> categoryProgress = {};
    
    for (var habit in habits) {
      categoryTotals[habit.category] = (categoryTotals[habit.category] ?? 0) + habit.total;
      categoryProgress[habit.category] = (categoryProgress[habit.category] ?? 0) + habit.progress;
    }
    
    final Map<String, double> progressPercentage = {};
    categoryTotals.forEach((category, total) {
      if (total > 0) {
        progressPercentage[category] = categoryProgress[category]! / total;
      } else {
        progressPercentage[category] = 0.0;
      }
    });
    
    return progressPercentage;
  }
  
  String? getMostProgressiveCategory(List<Habit> habits) {
    final progressByCategory = analyzeProgressByCategory(habits);
    
    String? bestCategory;
    double highestProgress = 0.0;
    
    progressByCategory.forEach((category, progress) {
      if (progress > highestProgress) {
        highestProgress = progress;
        bestCategory = category;
      }
    });
    
    return bestCategory;
  }
  
  String? getImprovementArea(List<Habit> habits) {
    final progressByCategory = analyzeProgressByCategory(habits);
    
    String? weakestCategory;
    double lowestProgress = 1.0;
    
    progressByCategory.forEach((category, progress) {
      if (progress < lowestProgress) {
        lowestProgress = progress;
        weakestCategory = category;
      }
    });
    
    return weakestCategory;
  }
  
  List<Map<String, dynamic>> generateInsights(List<Habit> habits) {
    final List<Map<String, dynamic>> insights = [];
    
    if (habits.isEmpty) {
      return insights;
    }
    
    final categoryDistribution = analyzeHabitsByCategory(habits);
    if (categoryDistribution.isNotEmpty) {
      final mostCommonCategory = categoryDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
      
      final formattedCategory = mostCommonCategory == 'Não categorizado' ? 'sem categoria' : 'na categoria "$mostCommonCategory"';
      
      insights.add({
        'type': 'category_distribution',
        'title': 'Distribuição de Hábitos',
        'description': 'Você tem mais hábitos $formattedCategory.',
        'data': categoryDistribution,
        'icon': Icons.pie_chart,
        'color': Colors.blue,
      });
    }
    
    final progressByCategory = analyzeProgressByCategory(habits);
    if (progressByCategory.isNotEmpty) {
      final bestCategory = getMostProgressiveCategory(habits);
      final weakestCategory = getImprovementArea(habits);
      
      if (bestCategory != null) {
        final progress = (progressByCategory[bestCategory]! * 100).toInt();
        final formattedCategory = bestCategory == 'Não categorizado' ? 'hábitos sem categoria' : 'na categoria "$bestCategory"';
        
        insights.add({
          'type': 'best_category',
          'title': 'Seu ponto forte',
          'description': 'Você está indo bem $formattedCategory com $progress% de progresso!',
          'data': progressByCategory[bestCategory],
          'icon': Icons.trending_up,
          'color': Colors.green,
        });
      }
      
      if (weakestCategory != null) {
        final progress = (progressByCategory[weakestCategory]! * 100).toInt();
        final formattedCategory = weakestCategory == 'Não categorizado' ? 'nos hábitos sem categoria' : 'na categoria "$weakestCategory"';
        
        insights.add({
          'type': 'improvement_area',
          'title': 'Oportunidade de melhoria',
          'description': 'Tente focar mais $formattedCategory, atualmente com $progress% de progresso.',
          'data': progressByCategory[weakestCategory],
          'icon': Icons.trending_down,
          'color': Colors.orange,
        });
      }
    }
    
    final completedHabits = habits.where((h) => h.isCompleted).length;
    final completionRate = completedHabits / habits.length;
    
    insights.add({
      'type': 'completion_rate',
      'title': 'Taxa de Conclusão',
      'description': 'Você completou ${(completionRate * 100).toInt()}% dos seus hábitos.',
      'data': completionRate,
      'icon': Icons.check_circle,
      'color': completionRate > 0.5 ? Colors.green : Colors.orange,
    });
    
    return insights;
  }
}
