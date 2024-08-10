import 'package:flutter/material.dart';

class RetailerProvider with ChangeNotifier {
  bool _isRetailer = false;

  bool get isRetailer => _isRetailer;

  void becomeRetailer() {
    _isRetailer = true;
    notifyListeners();
  }

  void revertToNormalUser() {
    _isRetailer = false;
    notifyListeners();
  }
}
