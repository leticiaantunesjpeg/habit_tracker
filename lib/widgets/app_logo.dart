import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color backgroundColor;
  final bool isAnimated;

  const AppLogoWidget({
    super.key,
    this.size = 60,
    required this.primaryColor,
    required this.backgroundColor,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isAnimated) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        curve: Curves.elasticOut,
        duration: const Duration(seconds: 1),
        builder: (context, value, child) {
          return buildLogo(value);
        },
      );
    } else {
      return buildLogo(1.0);
    }
  }

  Widget buildLogo(double animationValue) {
    return Container(
      width: size * animationValue,
      height: size * animationValue,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            Transform.scale(
              scale: animationValue,
              child: Transform.rotate(
                angle: (animationValue * 2) * 3.14,
                child: Icon(
                  Icons.track_changes,
                  color: Colors.white,
                  size: size * 0.5,
                ),
              ),
            ),
            Transform.scale(
              scale: animationValue,
              child: SizedBox(
                width: size * 0.9,
                height: size * 0.9,
                child: CircularProgressIndicator(
                  value: 1.0,
                  color: Colors.white.withOpacity(0.7),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
