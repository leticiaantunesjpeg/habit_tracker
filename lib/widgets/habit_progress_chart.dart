import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HabitProgressChart extends StatelessWidget {
  final int daysCompleted;
  final int totalDays;
  final bool isAnimated;
  final ColorScheme colorScheme;

  const HabitProgressChart({
    super.key,
    required this.daysCompleted,
    required this.totalDays,
    this.isAnimated = true,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildLegend(),
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: Row(
            children: _buildBars(),
          ),
        ),
        const SizedBox(height: 10),
        _buildLabel(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Completo',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(width: 20),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Incompleto',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  List<Widget> _buildBars() {
    final List<Widget> bars = [];
    
    final double completionPercentage = daysCompleted / totalDays;
    
    for (int i = 0; i < totalDays; i++) {
      final bool isComplete = i < daysCompleted;
      
      bars.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0.0,
                end: isAnimated ? 1.0 : 0.0,
              ),
              duration: Duration(milliseconds: 300 + (i * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: constraints.maxHeight * 0.3 * value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: isComplete
                                          ? colorScheme.primary
                                          : Colors.white24,
                                      boxShadow: isComplete
                                          ? [
                                              BoxShadow(
                                                color: colorScheme.primary.withOpacity(0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isComplete
                            ? colorScheme.primary
                            : Colors.white24,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    return bars;
  }

  Widget _buildLabel() {
    final double progressPercentage = (daysCompleted / totalDays) * 100;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$daysCompleted de $totalDays',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${progressPercentage.toStringAsFixed(0)}%',
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
