import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';

class OrderManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();
        return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders', style: TextStyle(color:isDarkTheme ? AppColors.ultramarineBlue: AppColors.white, fontWeight: FontWeight.w500,),),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          'Order management features for retailers',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  });
}
}