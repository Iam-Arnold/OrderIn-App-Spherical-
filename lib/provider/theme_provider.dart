import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;
  bool isLightThemeIcon = true;
  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      isLightThemeIcon = false;
    } else {
      _themeData = lightTheme;
      isLightThemeIcon = true;
    }
    notifyListeners();
  }
  switchThemeIcon(){
    if(isLightThemeIcon) { 
      return true;
  }else{
    return false;
  }
}
}