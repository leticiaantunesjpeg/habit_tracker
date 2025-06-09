import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedProgressButton extends StatefulWidget {
  final bool isCompleted;
  final bool hasMultipleSteps;
  final int progress;
  final int total;
  final VoidCallback? onTap;

  const AnimatedProgressButton({
    super.key,
    required this.isCompleted,
    this.hasMultipleSteps = false,
    this.progress = 0,
    this.total = 1,
    this.onTap,
  });

  @override
  State<AnimatedProgressButton> createState() => _AnimatedProgressButtonState();
}

class _AnimatedProgressButtonState extends State<AnimatedProgressButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );

    if (widget.isCompleted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isCompleted ? _pulseAnimation.value : _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.hasMultipleSteps)
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: widget.progress / widget.total,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.isCompleted 
                          ? AppTheme.successColor.withOpacity(0.9) 
                          : Colors.white,
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                if (widget.hasMultipleSteps)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: widget.isCompleted 
                        ? AppTheme.successColor.withOpacity(0.2) 
                        : Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.progress}/${widget.total}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.isCompleted 
                        ? AppTheme.successColor.withOpacity(0.2) 
                        : Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (widget.isCompleted)
                          BoxShadow(
                            color: AppTheme.successColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: Icon(
                      widget.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                      color: widget.isCompleted ? AppTheme.successColor : Colors.white,
                      size: 30,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
