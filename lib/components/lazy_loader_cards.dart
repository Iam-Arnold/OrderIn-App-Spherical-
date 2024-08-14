import 'package:flutter/material.dart';

class LazyLoaderCard extends StatefulWidget {
  @override
  _LazyLoaderCardState createState() => _LazyLoaderCardState();
}

class _LazyLoaderCardState extends State<LazyLoaderCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500), // Adjust duration for smoother animation
      vsync: this,
    )..repeat(reverse: true);

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(_animationController);

    _colorAnimation = ColorTween(
      begin: Colors.grey[400],
      end: Colors.grey[300],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 1.0,
          child: Container(
            width: 150.0,
            height: 200.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                begin: _alignmentAnimation.value,
                end: _alignmentAnimation.value == Alignment.topLeft 
                      ? Alignment.bottomRight 
                      : Alignment.topLeft,
                colors: [_colorAnimation.value!, Colors.grey[400]!],
              ),
            ),
          ),
        );
      },
    );
  }
}
