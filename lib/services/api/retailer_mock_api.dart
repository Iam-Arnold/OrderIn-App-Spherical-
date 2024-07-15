import 'dart:math';
import '/models/retailer.dart';

class MockApiService {
  Future<List<String>> fetchCategories() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Return 10 hardcoded categories
    return [
      'Electronics',
      'Fashion',
      'Home & Kitchen',
      'Beauty',
      'Toys',
      'Sports',
      'Automotive',
      'Books',
      'Groceries',
      'Music'
    ];
  }

  Future<List<Retailer>> fetchRetailers(String category, {int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Generate a variable number of retailers for each category
    int numberOfRetailers = Random().nextInt(30) + 1; // Between 1 and 30

    print('Printed no:: $numberOfRetailers');
    List<Retailer> allRetailers = List.generate(numberOfRetailers, (index) {
      return Retailer(
        '$category Store $index',
        category,
        '${(index + 1) * 2} min',
        'P${(index + 1) * 5}',
        'assets/images/${category.toLowerCase().replaceAll(' ', '_')}_placeholder.jpg',
      );
    });
    return allRetailers.take(limit).toList();
  }
}
