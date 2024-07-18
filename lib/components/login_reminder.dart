import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LoginReminderPopup extends StatelessWidget {
  final VoidCallback onClose;

  LoginReminderPopup({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.ultramarineBlue,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Please log in to access full features.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: onClose,
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
