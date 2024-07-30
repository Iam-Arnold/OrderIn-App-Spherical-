import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCustomer;

  MessageBubble({required this.message, required this.isCustomer});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isCustomer ? AppColors.lightBlue : AppColors.ultramarineBlue,
          borderRadius: BorderRadius.only(
            topLeft: isCustomer ? Radius.circular(10.0) : Radius.circular(0),
            topRight: !isCustomer ? Radius.circular(10.0) : Radius.circular(0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
