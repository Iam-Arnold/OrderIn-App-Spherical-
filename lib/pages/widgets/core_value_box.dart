import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class CoreValueBox extends StatelessWidget {
  final IconData icon;
  final String title;

  CoreValueBox({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: AppColors.ultramarineBlue,
          child: Icon(icon, color: AppColors.white, size: 30.0),
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
