import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.lightBlue : AppColors.ultramarineBlue,
          borderRadius: BorderRadius.only(
            topLeft: isMe ? Radius.circular(10.0) : Radius.circular(0),
            topRight: !isMe ? Radius.circular(10.0) : Radius.circular(0),
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
