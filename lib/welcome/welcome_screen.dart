import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/orderinLogo.png', height: 100.0),
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
            Text(
              'Your premier overseas goods ordering app',
              style: TextStyle(
                fontSize: 18.0,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            PrimaryButton(
              text: 'Next',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              },
            ),
          ],
        ),
      ),
    );
  }
}
