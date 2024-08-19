import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Makes the button's background transparent
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 0, // Removes the shading
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0), // Makes the button fully rounded
          ),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(32.0), // Match the button's border radius
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
              minHeight: 50,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
