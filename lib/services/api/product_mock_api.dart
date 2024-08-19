import '/models/products.dart';

class MockProductApi {
  static List<Product> fetchProductsForRetailer(String retailerName) {
    List<Product> products = [];

    if (retailerName == 'Electronics Store 0') {
      products = [
        Product(
          id: '1',
          name: 'Desktop PC',
          price: 4500.0,
          imageUrl: 'https://www.apple.com/v/imac/p/images/overview/hero_endframe__fpycn08d62ai_large_2x.jpg',
        ),
        Product(
          id: '2',
          name: 'Laptop',
          price: 3500.0,
          imageUrl: 'https://www.apple.com/v/macbook-air/s/images/overview/switchers/anim/new_mac_endframe__zrt2y39bg766_large_2x.jpg',
        ),
        Product(
          id: '3',
          name: 'Keyboard',
          price: 150.0,
          imageUrl: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MK293?wid=890&hei=890&fmt=jpeg&qlt=90&.v=1628006485000',
        ),
        Product(
          id: '4',
          name: 'Mouse',
          price: 100.0,
          imageUrl: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MMMQ3?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1645138486301',
        ),
      ];
    } else if (retailerName == 'FashionHub') {
      products = [
        Product(
          id: '5',
          name: 'Men\'s Jacket',
          price: 250.0,
          imageUrl: 'assets/images/mens_jacket.jpg',
        ),
        Product(
          id: '6',
          name: 'Women\'s Dress',
          price: 180.0,
          imageUrl: 'assets/images/womens_dress.jpg',
        ),
        Product(
          id: '7',
          name: 'Jeans',
          price: 120.0,
          imageUrl: 'assets/images/jeans.jpg',
        ),
        Product(
          id: '8',
          name: 'T-Shirt',
          price: 50.0,
          imageUrl: 'assets/images/tshirt.jpg',
        ),
      ];
    }
    // Add more retailers and their respective products as needed

    return products;
  }
}
