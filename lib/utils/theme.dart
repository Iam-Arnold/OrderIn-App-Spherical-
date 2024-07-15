import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.ultramarineBlue,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.ultramarineBlue,
    secondary: AppColors.lightBlue,
    background: AppColors.white,
  ),
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.ultramarineBlue,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(
      color: AppColors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkBlue),
    bodyMedium: TextStyle(color: AppColors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.ultramarineBlue,
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
);
