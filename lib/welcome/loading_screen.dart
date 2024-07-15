import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/colors.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [           
            Image.asset('assets/dartorderinLogo.png', height: 100.0),
            // Image.asset('assets/orderinLogo.png', height: 100.0),  // Adjust the path as needed
            SizedBox(height: 20.0),
            // Text(
            //   'OrderIn',
            //   style: TextStyle(
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //     color: AppColors.ultramarineBlue,
            //   ),
            // ),
            SizedBox(height: 20.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.ultramarineBlue),
            ),
          ],
        ),
      ),
    );
  }
}
