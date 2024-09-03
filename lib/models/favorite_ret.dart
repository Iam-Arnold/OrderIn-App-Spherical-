class LikedRetailer {
  final String storeName;
  final String storeLocation;
  final String storeType;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final String placeholderImage;

  LikedRetailer({
    required this.storeName,
    required this.storeLocation,
    required this.storeType,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.placeholderImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'storeLocation': storeLocation,
      'storeType': storeType,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'placeholderImage': placeholderImage,
    };
  }

  factory LikedRetailer.fromMap(Map<String, dynamic> map) {
    return LikedRetailer(
      storeName: map['storeName'],
      storeLocation: map['storeLocation'],
      storeType: map['storeType'],
      rating: map['rating'],
      deliveryTime: map['deliveryTime'],
      deliveryFee: map['deliveryFee'],
      placeholderImage: map['placeholderImage'],
    );
  }
}
