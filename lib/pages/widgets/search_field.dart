import 'package:flutter/material.dart';
import 'package:orderinapp/utils/colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const SearchField({
    Key? key,
    required this.controller,
    this.hintText = 'Search shops...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.lightBlue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightBlue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.ultramarineBlue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.lightBlue),
      ),
    );
  }
}
