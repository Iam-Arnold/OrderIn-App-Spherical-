import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class HeartbeatLoader extends StatefulWidget {
  @override
  _HeartbeatLoaderState createState() => _HeartbeatLoaderState();
}

class _HeartbeatLoaderState extends State<HeartbeatLoader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Navigate to HomePage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.5).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.elasticInOut,
            ),
          ),
          child: Image.asset('assets/dartorderinLogo.png', width: 100, height: 100),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
