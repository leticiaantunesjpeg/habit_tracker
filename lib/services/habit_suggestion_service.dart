import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_suggestion.dart';

class HabitSuggestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static const String _modelDocPath = 'ml_models/habit_suggestion_model';
  static const String _userInputsCollection = 'user_inputs';
  static const String _unmatchedQueriesCollection = 'unmatched_queries';
  
  static final HabitSuggestionService _instance = HabitSuggestionService._internal();
  factory HabitSuggestionService() => _instance;
  
  HabitSuggestionService._internal();
  
  Future<List<HabitSuggestion>> getSuggestions(String query, {
    String? frequency,
    int limit = 10
  }) async {
    if (query.isEmpty) return [];
    
    try {
      final modelDoc = await _firestore.doc(_modelDocPath).get();
      
      if (!modelDoc.exists) {
        print('Modelo de sugestão não encontrado no Firestore');
        return [];
      }
      
      final rawSuggestions = List<String>.from(modelDoc.data()?['suggestions'] ?? []);
      final categoriesData = modelDoc.data()?['categories'] as Map<String, dynamic>?;
      final queryLower = query.toLowerCase();
      final queryWords = queryLower.split(' ').where((word) => word.length > 2).toList();
      
      List<HabitSuggestion> result = [];
      
      final exactMatchesStrings = rawSuggestions
          .where((suggestion) => suggestion.toLowerCase().contains(queryLower))
          .toList();
      
      for (String suggestionStr in exactMatchesStrings) {
        String? category = await identifyHabitCategory(suggestionStr, frequency: frequency);
        String habitFrequency = frequency ?? _determineFrequencyFromSuggestion(suggestionStr, categoriesData);
        String cleanName = _cleanSuggestionName(suggestionStr);
        
        result.add(HabitSuggestion(
          name: cleanName,
          category: category ?? 'Outros',
          frequency: habitFrequency,
        ));
      }
      
      if ((exactMatchesStrings.length < 7 || query.length > 3) && categoriesData != null) {
        final Map<String, double> categoryScores = {};
        
        categoriesData.forEach((categoryName, _) {
          categoryScores[categoryName] = 0.0;
        });
        
        categoriesData.forEach((categoryName, categoryInfo) {
          final keywords = List<String>.from(categoryInfo['keywords'] ?? []);
          for (String keyword in keywords) {
            final keywordLower = keyword.toLowerCase();
            
            if (queryLower == keywordLower) {
              categoryScores[categoryName] = categoryScores[categoryName]! + 8.0;
              continue;
            }
            
            if (keywordLower.startsWith(queryLower) || queryLower.startsWith(keywordLower)) {
              categoryScores[categoryName] = categoryScores[categoryName]! + 5.0;
              continue;
            }
            
            if (keywordLower.contains(queryLower) || queryLower.contains(keywordLower)) {
              categoryScores[categoryName] = categoryScores[categoryName]! + 3.0;
              continue;
            }
            
            for (String word in queryWords) {
              if (word.length > 2) {
                if (keywordLower.contains(word)) {
                  categoryScores[categoryName] = categoryScores[categoryName]! + 2.0;
                } else if (word.contains(keywordLower)) {
                  categoryScores[categoryName] = categoryScores[categoryName]! + 1.0;
                }
              }
            }
          }
          
          final activities = List<String>.from(categoryInfo['activities'] ?? []);
          for (String activity in activities) {
            final activityLower = activity.toLowerCase();
            
            if (activityLower.startsWith(queryLower)) {
              categoryScores[categoryName] = categoryScores[categoryName]! + 4.0;
              continue;
            }
            
            if (activityLower.contains(queryLower)) {
              categoryScores[categoryName] = categoryScores[categoryName]! + 3.0;
              continue;
            }
            
            for (String word in queryWords) {
              if (word.length > 2 && activityLower.contains(word)) {
                categoryScores[categoryName] = categoryScores[categoryName]! + 1.5;
              }
            }
          }
          
          if (frequency != null && 
              categoryInfo['frequency'].toString().toLowerCase() == frequency.toLowerCase()) {
            categoryScores[categoryName] = categoryScores[categoryName]! + 1.0;
          }
        });
        
        final relevantCategories = categoryScores.entries
            .where((entry) => entry.value > 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
            
        final topCategories = relevantCategories.take(3).map((e) => e.key).toList();
        
        if (topCategories.isNotEmpty) {
          Set<String> categorySuggestionsStr = {};
          
          for (String category in topCategories) {
            final activities = List<String>.from(categoriesData[category]['activities'] ?? []);
            final categoryFrequency = categoriesData[category]['frequency'] as String? ?? 'Semanal';
            
            int maxSuggestions = (exactMatchesStrings.length < 3) ? 8 : 5;
            int count = 0;
            
            for (String activity in activities) {
              if (count >= maxSuggestions) break;
              
              final formattedActivity = "$activity ($categoryFrequency)";
              if (!_suggestionExists(result, activity) && 
                  !categorySuggestionsStr.contains(formattedActivity) && 
                  activity.toLowerCase().startsWith(queryLower)) {
                categorySuggestionsStr.add(formattedActivity);
                result.add(HabitSuggestion(
                  name: activity,
                  category: category,
                  frequency: categoryFrequency,
                ));
                count++;
              }
            }
            
            for (String activity in activities) {
              if (count >= maxSuggestions) break;
              
              final formattedActivity = "$activity ($categoryFrequency)";
              if (!_suggestionExists(result, activity) && 
                  !categorySuggestionsStr.contains(formattedActivity) && 
                  activity.toLowerCase().contains(queryLower)) {
                categorySuggestionsStr.add(formattedActivity);
                result.add(HabitSuggestion(
                  name: activity,
                  category: category,
                  frequency: categoryFrequency,
                ));
                count++;
              }
            }
            
            for (String activity in activities) {
              if (count >= maxSuggestions) break;
              
              final formattedActivity = "$activity ($categoryFrequency)";
              if (!_suggestionExists(result, activity) && 
                  !categorySuggestionsStr.contains(formattedActivity)) {
                categorySuggestionsStr.add(formattedActivity);
                result.add(HabitSuggestion(
                  name: activity,
                  category: category,
                  frequency: categoryFrequency,
                ));
                count++;
              }
            }
          }
        }
      }
      
      if (frequency != null) {
        result = result
          .where((suggestion) => suggestion.frequency.toLowerCase() == frequency.toLowerCase())
          .toList();
      }
      
      if (result.length > limit) {
        result = result.sublist(0, limit);
      }
      
      if (result.isEmpty && query.length > 2) {
        _registerUnmatchedQuery(query, frequency);
      }
      
      return result;
    } catch (e) {
      print('Erro ao buscar sugestões do modelo: $e');
      return [];
    }
  }
  
  bool _suggestionExists(List<HabitSuggestion> suggestions, String name) {
    return suggestions.any((suggestion) => suggestion.name.toLowerCase() == name.toLowerCase());
  }
  
  String _cleanSuggestionName(String suggestion) {
    final regex = RegExp(r'\s*\(\s*(Diária|Semanal|Mensal|Anual)\s*\)\s*$', caseSensitive: false);
    return suggestion.replaceAll(regex, '').trim();
  }
  
  String _determineFrequencyFromSuggestion(String suggestion, Map<String, dynamic>? categoriesData) {
    final frequencyRegex = RegExp(r'\(\s*(Diária|Semanal|Mensal|Anual)\s*\)$', caseSensitive: false);
    final match = frequencyRegex.firstMatch(suggestion);
    
    if (match != null) {
      return match.group(1)!;
    }
    
    if (categoriesData != null) {
      final suggestionLower = suggestion.toLowerCase();
      
      for (var entry in categoriesData.entries) {
        final categoryInfo = entry.value;
        final activities = List<String>.from(categoryInfo['activities'] ?? []);
        
        for (var activity in activities) {
          if (activity.toLowerCase() == suggestionLower) {
            return categoryInfo['frequency'] as String? ?? 'Semanal';
          }
        }
      }
    }
    
    return 'Semanal';
  }
  
  Future<void> registerUserSelection(
    String query,
    HabitSuggestion selectedSuggestion,
    String frequency,
  ) async {
    try {
      await _firestore.collection(_userInputsCollection).add({
        'query': query,
        'selected_suggestion': selectedSuggestion.name,
        'selected_category': selectedSuggestion.category,
        'frequency': frequency,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao registrar seleção do usuário: $e');
    }
  }
  
  Future<void> _registerUnmatchedQuery(String query, String? frequency) async {
    try {
      await _firestore.collection(_unmatchedQueriesCollection).add({
        'query': query,
        'frequency': frequency ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao registrar consulta sem correspondência: $e');
    }
  }
  
  Future<String?> identifyHabitCategory(String habitName, {String? frequency}) async {
    try {
      final modelDoc = await _firestore.doc(_modelDocPath).get();
      
      if (!modelDoc.exists) {
        print('Modelo de categorização não encontrado no Firestore');
        return null;
      }
      
      final categoriesData = modelDoc.data()?['categories'] as Map<String, dynamic>?;
      if (categoriesData == null) {
        return null;
      }
      
      final habitNameLower = habitName.toLowerCase();
      final words = habitNameLower.split(' ');
      
      final Map<String, int> categoryScores = {};
      
      categoriesData.forEach((categoryName, categoryInfo) {
        categoryScores[categoryName] = 0;
        
        final keywords = List<String>.from(categoryInfo['keywords'] ?? []);
        for (var keyword in keywords) {
          if (habitNameLower.contains(keyword.toLowerCase())) {
            categoryScores[categoryName] = categoryScores[categoryName]! + 2;
          }
        }
        
        final activities = List<String>.from(categoryInfo['activities'] ?? []);
        for (var activity in activities) {
          if (habitNameLower == activity.toLowerCase()) {
            categoryScores[categoryName] = categoryScores[categoryName]! + 5;
            break;
          } else if (habitNameLower.contains(activity.toLowerCase())) {
            categoryScores[categoryName] = categoryScores[categoryName]! + 3;
          }
        }
        
        if (frequency != null && 
            categoryInfo['frequency'] == frequency) {
          categoryScores[categoryName] = categoryScores[categoryName]! + 1;
        }
      });
      
      String? bestCategory;
      int highestScore = 0;
      
      categoryScores.forEach((category, score) {
        if (score > highestScore) {
          highestScore = score;
          bestCategory = category;
        }
      });
      
      return (highestScore > 0) ? bestCategory : null;
    } catch (e) {
      print('Erro ao identificar categoria do hábito: $e');
      return null;
    }
  }
}
