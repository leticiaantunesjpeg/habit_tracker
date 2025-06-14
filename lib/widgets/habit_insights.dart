import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_analytics_service.dart';

class HabitInsights extends StatelessWidget {
  final List<Habit> habits;
  final HabitAnalyticsService analyticsService = HabitAnalyticsService();
  
  HabitInsights({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (habits.length < 2) {
      return Container();
    }
    
    final insights = analyticsService.generateInsights(habits);
    
    if (insights.isEmpty) {
      return Container();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: insights.length,
              itemBuilder: (context, index) {
                final insight = insights[index];
                return _buildInsightCard(context, insight);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInsightCard(BuildContext context, Map<String, dynamic> insight) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            insight['color'] ?? Colors.blue,
            insight['color']?.withOpacity(0.7) ?? Colors.blue.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                insight['icon'] ?? Icons.insights,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              insight['description'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
