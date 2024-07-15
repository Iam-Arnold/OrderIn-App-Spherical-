import '/models/products.dart';

class MockProductApi {
  static List<Product> fetchProductsForRetailer(String retailerName) {
    // Simulate fetching products from an API (hardcoded for mock purposes)
    List<Product> products = [];

    // Example: Products for TechStore
    if (retailerName == 'Electronics Store 0') {
      products = [
        Product(
          name: 'Desktop PC',
          price: 4500.0,
          imageUrl: 'assets/images/desktop_pc.jpg',
        ),
        Product(
          name: 'Laptop',
          price: 3500.0,
          imageUrl: 'assets/images/laptop.jpg',
        ),
        Product(
          name: 'Keyboard',
          price: 150.0,
          imageUrl: 'assets/images/keyboard.jpg',
        ),
        Product(
          name: 'Mouse',
          price: 100.0,
          imageUrl: 'assets/images/mouse.jpg',
        ),
      ];
    }
    // Example: Products for FashionHub
    else if (retailerName == 'FashionHub') {
      products = [
        Product(
          name: 'Men\'s Jacket',
          price: 250.0,
          imageUrl: 'assets/images/mens_jacket.jpg',
        ),
        Product(
          name: 'Women\'s Dress',
          price: 180.0,
          imageUrl: 'assets/images/womens_dress.jpg',
        ),
        Product(
          name: 'Jeans',
          price: 120.0,
          imageUrl: 'assets/images/jeans.jpg',
        ),
        Product(
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
