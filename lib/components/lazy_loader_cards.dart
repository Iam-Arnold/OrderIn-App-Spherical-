import 'package:flutter/material.dart';

class LazyLoaderCard extends StatefulWidget {
  @override
  _LazyLoaderCardState createState() => _LazyLoaderCardState();
}

class _LazyLoaderCardState extends State<LazyLoaderCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat animation indefinitely

    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[200],
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
      animation: _colorAnimation,
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
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        );
      },
    );
  }
}
