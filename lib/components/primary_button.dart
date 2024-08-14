import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  PrimaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.ultramarineBlue,
              Colors.lightBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30.0), // Adjust the border radius if needed
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent, // Remove the button's shadow color if needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Ensure the button has the same radius as the gradient
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ensure the text color contrasts well with the gradient
            ),
          ),
        ),
      ),
    );
  }
}
