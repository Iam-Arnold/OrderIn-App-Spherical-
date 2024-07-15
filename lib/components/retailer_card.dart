import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/retailer.dart';
import '../models/products.dart';
import '../pages/store_details_page.dart';
import '../services/api/product_mock_api.dart'; // Import your product API or service here

class RetailerCard extends StatelessWidget {
  final Retailer retailer;

  RetailerCard({required this.retailer});

  @override
  Widget build(BuildContext context) {
    List<String> productImages = [
      'https://t4.ftcdn.net/jpg/01/10/04/51/360_F_110045173_QgmA3gg5OwTlLNQBqmPdFnkh6sPvsvt8.jpg',
      'https://m.media-amazon.com/images/I/51TrBUYh2XL.jpg',
      'https://m.media-amazon.com/images/I/81fRiskSVjL.jpg',
      'https://cdn.thewirecutter.com/wp-content/media/2023/06/laptopsunder500-2048px-aceraspire3spin14.jpg?auto=webp&quality=75&width=1024',
      // Add more image URLs here from your retailer's products
    ];
print(productImages);
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
              placeholderImage: retailer.placeholderImageAsset ?? 'assets/orderinLogo.png',
            ),
          ),
        );
      },
      child: Container(
        width: 180.0, // Increased width for larger card
        margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
              height: 120.0, // Increased height for larger image area
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 120.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16/9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: productImages.map((imageURL) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: imageURL.startsWith('assets')
                                ? AssetImage(imageURL)
                                : NetworkImage(imageURL), // Use AssetImage for local images
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    retailer.storeName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    retailer.retailerType,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Delivery in ${retailer.time}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
