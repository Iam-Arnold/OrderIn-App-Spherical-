import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  bool addItem(CartItem item) {
    final existingItem = _items.firstWhere(
      (cartItem) => cartItem.productId == item.productId,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        productImage: '',
        productPrice: '',
        quantity: 0,
      ),
    );

    if (existingItem.productId.isNotEmpty) {
      return false;
    }

    _items.add(item);
    notifyListeners();
    return true;
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      final itemToRemove = _items.firstWhere((item) => item.productId == productId, orElse: () => CartItem(productId: '', productName: '', productImage: '', productPrice: '', quantity: 0));
      if (itemToRemove.productId.isNotEmpty) {
        removeItem(itemToRemove);
      }
    } else {
      final itemIndex = _items.indexWhere((item) => item.productId == productId);
      if (itemIndex != -1) {
        _items[itemIndex] = _items[itemIndex].copyWith(quantity: newQuantity);
        notifyListeners();
      }
    }
  }
}
