class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final String productPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? productPrice,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
