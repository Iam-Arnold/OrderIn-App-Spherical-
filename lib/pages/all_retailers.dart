import 'package:flutter/material.dart';
import '../models/retailer.dart';
import './store_details_page.dart';
import '../services/api/product_mock_api.dart';
import '../models/products.dart';

class AllRetailersPage extends StatelessWidget {
  final String category;
  final List<Retailer> retailers;

  const AllRetailersPage({Key? key, required this.category, required this.retailers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: retailers.length,
        itemBuilder: (context, index) {
          Retailer retailer = retailers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreDetailsPage(
                    storeName: retailer.storeName,
                    storeLocation: '1km away',
                    storeType: retailer.retailerType,
                    rating: 4.2,
                    deliveryTime: retailer.time,
                    deliveryFee: retailer.price,
                    promoDeals: _convertProductsToMap(MockProductApi.fetchProductsForRetailer(retailer.storeName)),
                    placeholderImage: retailer.placeholderImageAsset ?? 'assets/images/store_placeholder.png',
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage(retailer.placeholderImageAsset ?? 'assets/images/store_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          retailer.storeName,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          retailer.retailerType,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 14.0, color: Colors.grey),
                            SizedBox(width: 4.0),
                            Text(
                              retailer.time,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.attach_money, size: 14.0, color: Colors.grey),
                            Text(
                              retailer.price,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

    List<Map<String, String>> _convertProductsToMap(List<Product> products) {
    return products.map((product) {
      return {
        'name': product.name,
        'price': product.price.toString(),
        'image': product.imageUrl,
      };
    }).toList();
  }
}
